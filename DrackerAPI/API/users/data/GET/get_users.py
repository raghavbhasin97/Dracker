import boto3
import json
from boto3.dynamodb.conditions import  Attr

client = boto3.resource('dynamodb')
table = client.Table('DrackerUser')
    
def lambda_handler(event, context):
    if 'phone' in event:
        item = table.get_item(Key={'phone' : event['phone']})['Item']
        if 'friends' in item:
            friends = []
            for key in item['friends']:
                friends.append(get_item_for_key(key))
            return json.dumps(friends)
        else:
            return get_all_users()
            
    elif 'search' in event:
        response = table.scan(Select='ALL_ATTRIBUTES', FilterExpression=Attr('phone').begins_with(event['search']))['Items']
        result = []
        for item in response:
            result.append(process_item(item))
        return json.dumps(result)
    else:
        return get_all_users()
    #Should Never happen
    return "ERROR"

def get_all_users():
    response = table.scan()
    data = response['Items']
    response = []
    for item in data:
        response.append(process_item(item))
    return json.dumps(response)

def get_item_for_key(key):
    item = table.get_item(Key={'phone' : key})['Item']
    return process_item(item)

def process_item(item):
    item.pop('email', None)
    item.pop('customer_url', None)
    item.pop('funding_source', None)
    item.pop('friends', None)
    return item
    