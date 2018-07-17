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
        response.append(item)
    return json.dumps(response)
