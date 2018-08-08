import boto3
import uuid

def lambda_handler(event, context):
    #Get query parameters
    amount = event['amount']
    description = event['description']
    image = event['image']
    notification = event['notification']
    payee_name = event['payee_name']
    payee_phone = event['payee_phone']
    payee_uid = event['payee_uid']
    payer_name = event['payer_name']
    payer_phone = event['payer_phone']
    payer_uid = event['payer_uid']
    time = event['time']

    transaction_id = uuid.uuid4().hex
    #Get client and tables
    client = boto3.resource('dynamodb')
    debit_table = client.Table(payee_uid)
    credit_table = client.Table(payer_uid)
    _ = debit_table.put_item(
        Item={
            'transaction_id': transaction_id,
            'time': time,
            'amount': amount,
            'description': description,
            'is_debt': True,
            'name': payer_name,
            'phone': payer_phone,
            'tagged_image': image,
            'uid': payer_uid,
            'notification_identifier': notification
        }
    )

    _ = credit_table.put_item(
        Item={
            'transaction_id': transaction_id,
            'time': time,
            'amount': amount,
            'description': description,
            'is_debt': False,
            'name': payee_name,
            'phone': payee_phone,
            'tagged_image': image,
            'uid': payee_uid,
        }
    )

    return transaction_id
