import boto3

bucket = 'drackerimages'

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
    #Get the image name and delete
    response = payer_table.get_item(
        Key={
            'transaction_id' : transaction_id
        }
    )
    item = response['Item']
    item_key = item['tagged_image']
    payer_table.delete_item(
        Key={
            'transaction_id': transaction_id
        }
    )
    # Delete Image
    if item_key != 'noImage':
        s3 = boto3.client('s3')
        response = s3.delete_object(
        Bucket=bucket,
        Key=item_key,
        )
    return 200
