import json
import boto3
from datetime import datetime

client = boto3.resource('dynamodb')

def lambda_handler(event, context):
	path = event['path']
	query = path.replace('/users/', '')
	table = client.Table(query)
	transactions = table.scan()['Items']
	settled_transactions = []
	unsettled_transactions = []
	for item in transactions:
		try:
			item['settelement_time'] #Only tring to access this key to throw an error if not setteled yet
			#Remove unnecessary information if exists
			item.pop('notification_identifier', None)
			item.pop('tagged_image', None)
			item.pop('phone', None)
			item.pop('time', None)
			item.pop('uid', None)
			item.pop('transaction_id', None)
			settled_transactions.append(item)
		except:
			unsettled_transactions.append(item)
	credit, debit = calculate_balance(unsettled_transactions)
	unsettled_transactions = sorted(unsettled_transactions, key=lambda transaction: get_date(transaction['time']), reverse = True)
	settled_transactions = sorted(settled_transactions, key=lambda transaction: get_date(transaction['settelement_time']), reverse = True)
	settled_transactions = list(map(reduce, settled_transactions ))
	return generate_response({'settled' : json.dumps(settled_transactions), 'unsettled' : json.dumps(unsettled_transactions), 'credit' : credit, 'debit' : debit})


def generate_response(response_dictionary):
	return {'statusCode' : 200,
			'headers' : {
                "Content-Type" : "application/json"
            },
            'body' : json.dumps(response_dictionary)
    }

def calculate_balance(unsettled_transactions):
	credit = 0.0
	debit = 0.0
	for transaction in unsettled_transactions:
		if transaction['is_debt']:
			debit += float(transaction['amount'])
		else:
			credit += float(transaction['amount'])
	return (credit,debit)
def get_date(time_string):
	return datetime.strptime(time_string, '%m/%d/%y %H:%M:%S.%f %p %z')
def reduce(item):
	item.pop("settelement_time", None)
	return item