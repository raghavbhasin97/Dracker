import json
import os
import dwollav2
import boto3

client = boto3.resource('dynamodb') #get client
table = client.Table('DrackerUser')

def lambda_handler(event, context):
  try: 
    phone = event['phone']
    url = event['url']
    client = dwollav2.Client(
      key = os.environ.get('dwolla_key'),
      secret = os.environ.get('dwolla_secret'),
      environment = os.environ.get('dwolla_env')
    )
    app_token = client.Auth.client()
    request_body = {
    'removed': True
    }
    app_token.post(url, request_body)
    item = table.get_item(
      Key={
        'phone': phone
        }
    )
    table_row = item['Item']
    data = json.loads(table_row['funding_source'])
    sources = []
    for item in data["list"]:
      if item["url"] != url:
        sources.append(item)
    data["list"] = sources
    table_row['funding_source'] = json.dumps(data)
    table.put_item(Item=table_row)
    return  {"message" : "SUCCESS"}
  except Exception as err:
    print(err)
    return  {"message" : "ERROR" }

