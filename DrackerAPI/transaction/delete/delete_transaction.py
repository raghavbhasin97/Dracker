import boto3

def lambda_handler(event, context):
    transaction_id = event['transaction_id']
    payer_uid = event['payer_uid']
    payee_uid = event['payee_uid']
    #Get client and tables
    client = boto3.resource('dynamodb')
    payee_table = client.Table(payee_uid)
    payer_table = client.Table(payer_uid)
    payee_table.delete_item(
        Key={
            'transaction_id': transaction_id
        }
    )

    payer_table.delete_item(
        Key={
            'transaction_id': transaction_id
        }
    )
    return 200
