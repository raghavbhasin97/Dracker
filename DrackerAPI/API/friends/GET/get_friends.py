import boto3
import json
from collections import defaultdict
from datetime import datetime

def lambda_handler(event, context):
    path = event['path']
    query = path.replace('/friends/', '')
    client = boto3.resource('dynamodb')
    table = client.Table(query)
    transactions = table.scan()['Items']
    friends = defaultdict(list)
    for item in transactions:
        friends[item['uid']].append(item)
    friends_data = {}
    for key, value in friends.items():
        details = get_info(value)
        amount = calculate_amount(value)
        transactions_list = process_list(value)
        friends_data[key] = {'phone':details["phone"], 'name':details["name"],'amount':amount,'transactions': transactions_list}
        
    return generate_response(friends_data)

def generate_response(response_dictionary):
    return {'statusCode' : 200,
            'headers' : {
                "Content-Type" : "application/json",
                "Access-Control-Allow-Origin": "*"
            },
            'body' : json.dumps(response_dictionary)
    }

def get_info(transactions_list):
    data = {}
    for item in transactions_list:
        data['phone'] = item['phone']
        data['name'] = item['name']
        break
    return data

def calculate_amount(transactions_list):
    amount = 0.0
    for item in transactions_list:
        try:
          _ =  item["settelement_time"]
        except:
            if item["is_debt"]:
                amount -= float(item["amount"])
            else:
                amount += float(item["amount"])
    return amount
def process_list(transactions_list):
    new_list = []
    for item in transactions_list:
        item.pop("tagged_image", None)
        item.pop("uid", None)
        item.pop("transaction_id", None)
        item.pop("phone", None)
        item.pop("notification_identifier", None)
        new_list.append(item)
    return sorted(new_list, key=lambda transaction: sort_key(transaction), reverse = True)
def get_date(time_string):
    return datetime.strptime(time_string, '%m/%d/%y %H:%M:%S.%f %p %z')
def sort_key(transaction):
    try:
        _ = transaction['time']
        return get_date(transaction['time'])
    except:
        return get_date(transaction['settelement_time'])