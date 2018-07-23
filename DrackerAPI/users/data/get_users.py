import boto3
import json

def lambda_handler(event, context):
    client = boto3.resource('dynamodb')
    table = client.Table('DrackerUser')
    response = table.scan()
    data = response['Items']
    response = []
    for item in data:
        item.pop('email', None)
        item.pop('customer_url', None)
        item.pop('funding_source', None)
        response.append(item)
    return json.dumps(response)
