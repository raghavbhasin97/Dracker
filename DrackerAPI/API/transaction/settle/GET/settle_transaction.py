import boto3
import dwollav2
import os
import json
import sendgrid
from twilio.rest import Client

client = boto3.resource('dynamodb')
bucket = 'drackerimages'
user_table = client.Table('DrackerUser')
twillio_client = Client(os.environ.get('twillio_sid'), os.environ.get('twillio_token'))
def lambda_handler(event, context):
    transaction_id = event['transaction_id']
    payer_uid = event['payer_uid']
    payee_uid = event['payee_uid']
    time = event['time']
    #Get client and tables
    payee_table = client.Table(payee_uid)
    payer_table = client.Table(payer_uid)
    payee_response = payee_table.get_item(
        Key={
            'transaction_id' : transaction_id
        }
    )
    payer_response = payer_table.get_item(
        Key={
            'transaction_id' : transaction_id
        }
    )
    payee_item = payee_response['Item']
    payer_phone = payee_item['phone']
    payer_item = payer_response['Item']
    payee_phone = payer_item['phone']
    amount = payer_item['amount']
    transfer = initiate_transfer(payer_phone, payee_phone, amount)
    if transfer["message"] != "SUCCESS":
        return 404
    transaction_payload = transfer["payload"]
    transaction_payload['description'] = payee_item['description']
    transaction_payload['name'] = payer_item['name']
    transaction_payload['person_name'] = payee_item['name']
    #update time
    payee_item['settelement_time'] = time
    #remove unnecessary info
    payee_item.pop('notification_identifier', None)
    payee_item.pop('tagged_image', None)
    payee_item.pop('time', None)
    payee_table.put_item(Item=payee_item)
    #Update payer table
    item_key = payer_item['tagged_image']
    #update time
    payer_item['settelement_time'] = time
    #remove unnecessary info
    payer_item.pop('notification_identifier', None)
    payer_item.pop('tagged_image', None)
    payer_item.pop('time', None)
    payer_table.put_item(Item=payer_item)
    # Delete Image
    if item_key != 'noImage':
        s3 = boto3.client('s3')
        response = s3.delete_object(
        Bucket=bucket,
        Key=item_key,
        )
    send_transaction_email(transaction_payload['email'], transaction_payload)
    track_transaction(transaction_payload)
    try:
        message = transaction_payload['name'] + ' payed you $' + transaction_payload['amount'] + ' for\"' + transaction_payload['description'] + "\""
        twillio_client.messages.create(to=payer_phone, from_= os.environ.get('twillio_phone'), body= message)
    except Exception as err:
        print(err)
        return 200
    return 200
def initiate_transfer(payer_phone, payee_phone, amount):
    transaction_payload = {}
    try:
        payer_resource = user_table.get_item(
            Key={
                'phone': payer_phone
                }
        )
        payer_item = payer_resource['Item']
        payer_sources = json.loads(payer_item['funding_source'])
        dest = payer_sources['default']['url']
        payee_resource = user_table.get_item(
            Key={
                'phone': payee_phone
                }
        )
        payee_item = payee_resource['Item']
        payee_sources = json.loads(payee_item['funding_source'])
        source = payee_sources['default']['url']
        client = dwollav2.Client(
            key = os.environ.get('dwolla_key'),
            secret = os.environ.get('dwolla_secret'),
            environment = os.environ.get('dwolla_env')
        )
        app_token = client.Auth.client()
        request_body = {
            '_links': {
                'source': {
                'href': source
                },
                'destination': {
                  'href': dest
                }
            },
            'amount': {
                'currency': 'USD',
                'value': amount
            }
        }
        transfer = app_token.post('transfers', request_body)
        res = transfer.headers['location'].split('/')
        transaction_payload['transaction_id'] = res[-1]
        transaction_payload['amount'] = amount
        transaction_payload['email'] = payee_item['email']
        transaction_payload['phone'] = payee_item['phone']
        transaction_payload['bank_account'] = payee_sources['default']['institution'] + ' - ' + payee_sources['default']['name']
        return {"message" : "SUCCESS", "payload": transaction_payload}
    except Exception as err:
        print(err)
        return {"message" : "ERROR"}

def send_transaction_email(email, transaction_payload):
    api_key = os.environ.get('sg_key')
    sg = sendgrid.SendGridAPIClient(apikey=api_key)
    data = {
      "personalizations": [
        {
          "to": [
            {
              "email": email
            }
          ],
          "subject": "Transaction Settled"
        }
      ],
      "from": {
        "email": "no-reply@dracker.com"
      },
      "content": [
        {
          "type": "text/html",
          "value": get_email_template(transaction_payload)
        }
      ]
    }
    sg.client.mail.send.post(request_body=data)

def get_email_template(transaction_payload):
  file = open("transaction_settled.html","r")
  contents =file.read()
  return contents.replace('{name}', transaction_payload['name']).replace('{person_name}', transaction_payload['person_name']).replace('{amount}', transaction_payload['amount']).replace('{description}', transaction_payload['description']).replace('{transaction_id}', transaction_payload['transaction_id']).replace('{bank_account}', transaction_payload['bank_account'])

def track_transaction(transaction_payload):
    transactions_table = client.Table('DrackerTransactions')
    new_transaction = {'id': transaction_payload['transaction_id'], 'amount': transaction_payload['amount'], 'phone': transaction_payload['phone']}
    try:
        item = transactions_table.get_item(
                Key={
                    'email': transaction_payload['email']
                }
        )
        item = item['Item']
        item['transactions'].append(new_transaction)
        transactions_table.put_item(Item=item)
    except Exception as err:
        print(err)
        new_item = {}
        new_item['email'] = transaction_payload['email']
        new_item['transactions'] = [new_transaction]
        transactions_table.put_item(Item=new_item)

