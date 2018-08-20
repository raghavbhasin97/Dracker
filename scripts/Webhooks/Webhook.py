import hmac
from hashlib import sha256
import os
import json
import boto3
from twilio.rest import Client

client = boto3.resource('dynamodb')
transactions_table = client.Table('DrackerTransactions')
queue = (boto3.resource('sqs')).get_queue_by_name(QueueName='DrackerFailedTransactions')
twillio_client = Client(os.environ.get('twillio_sid'), os.environ.get('twillio_token'))


def verify_gateway_signature(proposed_signature, payload_body):
  signature = hmac.new(os.environ.get('webhook_secret'), payload_body, sha256).hexdigest()
  return True if (signature == proposed_signature) else False

def lambda_handler(event, context):
    proposed_signature = event['headers']['X-Request-Signature-SHA-256']
    if verify_gateway_signature(proposed_signature, event['body']) == False:
        return generate_response({"message" : "ERROR - Signature mismatched"})
    event_body = json.loads(event['body'])
    topic = event_body['topic']
    if topic == 'customer_transfer_completed':
        resource = event_body['_links']['resource']['href']
        payment_id = resource.split(os.environ.get('transfer_base'))[-1]
        try:
            item = transactions_table.get_item(Key={'id' : payment_id})['Item']
            message = 'Transaction ' + item['id'] + ' of $' + item['amount'] + ' has been processed from your bank account'
            try:
                twillio_client.messages.create(to=item['phone'], from_= os.environ.get('twillio_phone'), body= message)                    
            except:
                pass
            finally:
                transactions_table.delete_item(Key={'id' : payment_id})
        except:
            return generate_response({"message" : "Resoure already processed"})
    elif topic == 'customer_transfer_failed':
        resource = event_body['_links']['resource']['href']
        payment_id = resource.split(os.environ.get('transfer_base'))[-1]
        try:
            item = transactions_table.get_item(Key={'id' : payment_id})['Item']
            #Dump to SQS for furthee inquiry in matter
            queue.send_message(MessageBody=json.dumps(item))
            message = 'Transaction ' + item['id'] + ' of $' + item['amount'] + ' to ' + item['name'] + ' for \"' + item['description'] + '\"'+ ' could not be cleared'
            try:
                twillio_client.messages.create(to=item['phone'], from_= os.environ.get('twillio_phone'), body= message)
            except:
                pass
            finally:
                transactions_table.delete_item(Key={'id' : payment_id})
        except:
            return generate_response({"message" : "Resoure already processed"})
    else:
        return generate_response({"message" : "Event ignored"})
    return generate_response({"message" : "SUCCESS"})

def generate_response(response_dictionary):
    return {'statusCode' : 200,
            'headers' : {
                "Content-Type" : "application/json"
            },
            'body' : json.dumps(response_dictionary)
    }
