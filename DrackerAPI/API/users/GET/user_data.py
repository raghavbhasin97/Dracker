import boto3

def lambda_handler(event, context):
    phone = event['phone']
    client = boto3.resource('dynamodb')
    table = client.Table('DrackerUser')
    item = table.get_item(
        Key={
        'phone': phone
        }
    )
    try:
        data = item['Item']
    except:
        data = None
    
    return data