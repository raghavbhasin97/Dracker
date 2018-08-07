import boto3

def lambda_handler(event, context):
    uid = event['uid']
    transaction_id = event['transaction_id']
    client = boto3.resource('dynamodb')
    table = client.Table(uid)
    item = table.get_item(
        Key={
        'transaction_id': transaction_id
        }
    )
    try:
        data = item['Item']
    except:
        return 400
    
    return data
