import boto3
import os
import dwollav2
from plaid import Client
import json

client = boto3.resource('dynamodb') #get client
table = client.Table('DrackerUser')

def lambda_handler(event, context):
	try:
		phone = event['phone']
		account_id = event['account_id']
		token = event['token']
		account_name = event["name"]
		institution_name = event["institution_name"]
		item = table.get_item(
			Key={
				'phone': phone
				
			}
		)
		item = item['Item']
		customer_url = item['customer_url']
		plaid_client = Client(
			client_id=os.environ.get('plaid_client'), 
			secret=os.environ.get('plaid_secret'), 
			public_key=os.environ.get('plaid_public'), 
			environment=os.environ.get('plaid_env')
		)
		exchange_token_response = plaid_client.Item.public_token.exchange(token)
		access_token = exchange_token_response['access_token']
		dwolla_response = plaid_client.Processor.dwollaBankAccountTokenCreate(access_token, account_id)
		bank_account_token = dwolla_response['processor_token']
		request_body = {
			'plaidToken': bank_account_token,
			'name': account_name
		}
		dwolla_client = dwollav2.Client(
			key = os.environ.get('dwolla_key'),
			secret = os.environ.get('dwolla_secret'),
			environment = os.environ.get('dwolla_env')
		)
		app_token = dwolla_client.Auth.client()
		funding_source = app_token.post('%s/funding-sources' % customer_url, request_body)
		source_url = funding_source.headers['location']
		new_account = {"url": source_url, "name": account_name, "institution": institution_name}
		if item.has_key('funding_source'):
			data = json.loads(item['funding_source'])
			data["list"].append(new_account)
			item['funding_source'] = json.dumps(data)
		else:
			data = {"default" : new_account, "list": [new_account]}
			item['funding_source'] = json.dumps(data)
		table.put_item(Item=item)
		return  {"message" : "SUCCESS", "url" : source_url}
	except Exception as exp:
		print(exp)
		return  {"message" : "ERROR"}