import boto3
import dwollav2
import os

client = boto3.resource('dynamodb')
bucket = 'drackerimages'
user_table = client.Table('DrackerUser')
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
    return 200
def initiate_transfer(payer_phone, payee_phone, amount):
    try:
        payer_resource = user_table.get_item(
            Key={
                'phone': payer_phone
                }
        )
        payer_item = payer_resource['Item']
        dest = payer_item['funding_source']
        payee_resource = user_table.get_item(
            Key={
                'phone': payee_phone
                }
        )
        payee_item = payee_resource['Item']
        source = payee_item['funding_source']
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
        return {"message" : "SUCCESS"}
    except Exception as err:
        print(err)
        return {"message" : "ERROR"}