import boto3
import json

client = boto3.resource('dynamodb') #get client
table = client.Table('DrackerUser')

def lambda_handler(event, context):
    try:
        phone = event['phone']
        item = table.get_item(
            Key={
                'phone': phone
            }
        )
        item = item['Item']
        data = json.loads(item['funding_source'])
        sources = []
        default_url = data["default"]["url"]
        for item in data["list"]:
            if item["url"] == default_url:
                item["is_default"] = True
            else:
                item["is_default"] = False
            sources.append(item)
        return {"message" : "SUCCESS", "list" : json.dumps(sources)}
    except:
        return {"message" : "ERROR"}
