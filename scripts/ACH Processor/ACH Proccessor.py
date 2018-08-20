import boto3
import dwollav2
import os
from twilio.rest import Client
import json


dwolla_client = dwollav2.Client(
    key = os.environ.get('dwolla_key'),
    secret = os.environ.get('dwolla_secret'),
    environment = os.environ.get('dwolla_env')
    )
dwolla_token = dwolla_client.Auth.client()
twillio_client = Client(os.environ.get('twillio_sid'), os.environ.get('twillio_token'))

client = boto3.resource('dynamodb')
transactions_table = client.Table('DrackerTransactions')
queue = (boto3.resource('sqs')).get_queue_by_name(QueueName='DrackerFailedTransactions')

def lambda_handler(event, context):
    try:
        rows = transactions_table.scan()['Items']
        for row in rows:
            transactions = row['transactions']
            new_list = []
            for item in transactions:
                status = check_status(item['id'])
                if status == 'processed':
                    message = 'Transaction ' + item['id'] + ' for $' + item['amount'] + ' has been processed from your bank account'
                    try:
                        twillio_client.messages.create(to=item['phone'], from_= os.environ.get('twillio_phone'), body= message)
                    except Exception as err:
                        print(err)
                elif status == 'failed':                 
                    #Dump to SQS for furthe inquiry in matter
                    queue.send_message(MessageBody=json.dumps(item))
                    message = 'Transaction ' + item['id'] + ' for $' + item['amount'] + ' could not be cleared'
                    try:
                        twillio_client.messages.create(to=item['phone'], from_= os.environ.get('twillio_phone'), body= message)
                    except Exception as err:
                        print(err)
                else:
                    new_list.append(item)

            if len(new_list) == 0:
                transactions_table.delete_item(
                    Key={
                        'email': row['email']
                    }
                )
            else:
                row['transactions'] = new_list
                transactions_table.put_item(Item=row)
    except Exception as err:
        print(err)
    return 200


def check_status(transaction_id):
    transfer_url = 'https://api-sandbox.dwolla.com/transfers/'+transaction_id
    transfer = dwolla_token.get(transfer_url)
    return transfer.body['status']
