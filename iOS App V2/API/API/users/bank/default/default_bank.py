import boto3
import json

client = boto3.resource('dynamodb') #get client
table = client.Table('DrackerUser')

def lambda_handler(event, context):
    try:
        url = event['url']
        phone = event['phone']
        item = table.get_item(
                Key={
                    'phone': phone
                }
            )
        item = item['Item']
        data = json.loads(item['funding_source'])
        for account in data['list']:
            if account["url"] == url:
                data['default'] = account
                break
        item['funding_source'] = json.dumps(data)
        table.put_item(Item=item)
    except Exception as exp:
        print(exp)
        return {"message" : "ERROR"}
    return {"message" : "SUCCESS"}
