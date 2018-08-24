import dwollav2
import firebase_admin
from firebase_admin import auth
from firebase_admin import credentials
from utils import *
from api import *
import boto3
import time

#Setup firebase, and API
cred = credentials.Certificate("./dracker-9443c-firebase-adminsdk-gmc2g-7d48bbd323.json")
firebase_admin.initialize_app(cred)
api_instance = api("keys.json")
keys = api_instance.get_keys() 


def register_user(user):
	# Test new User
	res = api_instance.new_user(user)
	data = res.json()
	#Need to do this because, the data is not sanatized
	if data['message'] != 'SUCCESS':
		print("Register new user: Test Failed! initial create")
		return (None,None)
	uid = data['uid']
	#After successful creation of a user, check for duplicate registration possibility
	org_phone = user['phone']
	org_email = user['email']
	#Test duplicate email
	user['phone'] = random_phone()
	res = api_instance.new_user(user)
	data = res.json()
	if data['message'] != 'EMAIL_EXISTS':
		print("Register new user: Test Failed! at duplicate email")
		return (uid,org_phone)
	#Test duplicate email
	user['phone'] = org_phone
	user['email'] = random_email()
	res = api_instance.new_user(user)
	data = res.json()
	if data['message'] != 'PHONE_NUMBER_EXISTS':
		print("Register new user: Test Failed! at duplicate phone number")
		return (uid,org_phone)
	print("Register new user: Test Passed!")
	return (uid,org_phone)

def clean_data(uid, phone):
	auth.delete_user(uid) #Clear Firebase
	client = boto3.resource('dynamodb', region_name='us-east-1', aws_access_key_id=keys['aws_access_key_id'], aws_secret_access_key=keys['aws_secret_access_key'])
	table = client.Table('DrackerUser')
	#Clear Entry in Dwolla
	item = table.get_item(
		Key={
			'phone': phone
		}
	)
	url = item['Item']['customer_url']
	request_body = {
		'status': 'deactivated'
	}
	dwollaclient = dwollav2.Client(
		key = keys['dwolla_key'],
		secret = keys['dwolla_secret'],
		environment = keys['dwolla_env']
		)
	app_token = dwollaclient.Auth.client()
	app_token.post(url, request_body)    
    #Clear Entry in DrackerUser
	table.delete_item(
        Key={
            'phone': phone
        }
    )
    #Remove table
	while True:
		try:
			client.Table(uid).delete()
			break
		except client.meta.client.exceptions.ResourceInUseException:
			pass

def test_register():
	user = create_data()
	(uid,phone) = register_user(user)
	if uid != None:
		clean_data(uid, phone)

def test_register_fail():
	user = create_data()
	user['birthdate'] = '2018-01-01' #Set Invalid date so Dwolla verification fails
	res = api_instance.new_user(user)
	data = res.json()
	if data['message'] != 'ERROR':
		print("Register new user (Failure - Invalid Birthdate): Test Failed! shoul've returned ERROR but returned success")
		clean_data(data['uid'], user['phone'])
		return
	print("Register new user (Failure - Invalid Birthdate): Test Passed!")

def test_transaction1():
	#Create first user
	user1 = create_data()
	res = api_instance.new_user(user1)
	data = res.json()
	user1['uid'] = data['uid']
	#Create second user
	user2 = create_data()
	res = api_instance.new_user(user2)
	data = res.json()
	user2['uid'] = data['uid']
	#Wait for DynamoDB resources to be created
	time.sleep(5)
	transaction1, res = api_instance.create_transaction(user1, user2)
	amount1 = transaction1['amount']
	transaction_id = sanatize(res.text)
	if validate_transaction_id(transaction_id):
		print("Add a new transaction1 (Add Transaction): Test Passed!")
	else:
		print("Add a new transaction1 (Add Transaction): Test Failed!")

	res = api_instance.get_transaction(user1['uid'], transaction_id)
	data = res.json()
	if validate_transaction(transaction1, data):
		print("Test transaction data 1: Test Passed!")
	else:
		print("Test transaction data 1: Test Failed!")

	transaction2, res = api_instance.create_transaction(user1, user2)
	amount2 = transaction2['amount']
	transaction_id2 = sanatize(res.text)
	if validate_transaction_id(transaction_id):
		print("Add a new transaction2 (Add Transaction): Test Passed!")
	else:
		print("Add a new transaction2 (Add Transaction): Test Failed!")

	res = api_instance.get_transaction(user2['uid'], transaction_id2)
	data = res.json()
	if validate_transaction(transaction2, data):
		print("Test transaction data 2: Test Passed!")
	else:
		print("Test transaction data 2: Test Failed!")

	res = api_instance.get_user_transactions(user1['uid'])
	data = res.json()
	if validate_data(data, {'amount': str(float(amount1) + float(amount2)), 'transaction_id': transaction_id2}):
		print("Get User dash Data1: Test Passed!")
	else:
		print("Get User dash Data1: Test Failed!")

	res = api_instance.get_user_transactions(user2['uid'])
	data = res.json()
	if validate_data(data, {'amount': str(float(amount1) + float(amount2)), 'transaction_id': transaction_id2}):
		print("Get User dash Data2: Test Passed!")
	else:
		print("Get User dash Data2: Test Failed!")


	#Test Settle Transaction This should fail right now
	res = api_instance.settle_transaction(user1['uid'], user2['uid'], transaction_id)
	response_status = sanatize(res.text)
	if response_status == "404":
		print("Add a new transaction (Settle Transaction: Failure - Nonexistent Funding Source): Test Passed!")
	else:
		print("Add a new transaction (Settle Transaction: Failure - Nonexistent Funding Source): Test Failed!")

	#Test delete this transaction now
	res = api_instance.delete_transaction(user1['uid'], user2['uid'], transaction_id)
	response_status = sanatize(res.text)
	if response_status == "200":
		print("Add a new transaction1 (Delete Transaction): Test Passed!")
	else:
		print("Add a new transaction1 (Delete Transaction): Test Failed!")

	#Test delete this transaction now
	res = api_instance.delete_transaction(user1['uid'], user2['uid'], transaction_id2)
	response_status = sanatize(res.text)
	if response_status == "200":
		print("Add a new transaction2 (Delete Transaction): Test Passed!")
	else:
		print("Add a new transaction 2(Delete Transaction): Test Failed!")

	#CleanUp
	clean_data(user1['uid'], user1['phone'])
	clean_data(user2['uid'], user2['phone'])

def test_deep1():
	#Create user
	user = create_data()
	res = api_instance.new_user(user)
	data = res.json()
	user['uid'] = data['uid']
	#Wait for DynamoDB resources to be created
	time.sleep(5)
	res = api_instance.get_transaction(user['uid'], random_string(5))
	response_status = sanatize(res.text)
	if response_status == '400':
		print("Test transaction data (Failure - Nonexistent Transaction): Test Passed!")
	else:
		print("Test transaction data (Failure - Nonexistent Transaction): Test Failed!")

	res = api_instance.get_user(user['phone'])
	data = res.json()
	if validate_user(data, user):
		print("Get User Data: Test Passed!")
	else:
		print("Get User Data: Test Failed!")

	res = api_instance.get_user(random_phone())
	data = res.json()
	if data == None:
		print("Get User Data (Failure - Nonexistent Phone): Test Passed!")
	else:
		print("Get User Data (Failure - Nonexistent Phone): Test Failed!")
	
	#CleanUp
	clean_data(user['uid'], user['phone'])

def test_deep2():
	#Create first user
	user1 = create_data()
	res = api_instance.new_user(user1)
	data = res.json()
	user1['uid'] = data['uid']
	#Create second user
	user2 = create_data()
	res = api_instance.new_user(user2)
	data = res.json()
	user2['uid'] = data['uid']
	#Wait for DynamoDB resources to be created
	time.sleep(5)
	transaction, res = api_instance.create_transaction(user1, user2)
	transaction_id = sanatize(res.text)
	#Attach a bank account
	source1 = attach_funding(user1)
	source2 = attach_funding(user2)
	res = api_instance.settle_transaction(user1['uid'], user2['uid'], transaction_id)
	response_status = sanatize(res.text)
	if response_status == "200":
		print("Settle Transaction: Test Passed!")
	else:
		print("Settle Transaction: Test Failed!")

	#Cleanup dwolla
	client = dwollav2.Client(
		key = keys['dwolla_key'],
		secret = keys['dwolla_secret'],
		environment = keys['dwolla_env']
		)
	app_token = client.Auth.client()
	request_body = {
		'removed': True
	}
	app_token.post(source1, request_body)
	app_token.post(source2, request_body)
	#CleanUp
	clean_data(user1['uid'], user1['phone'])
	clean_data(user2['uid'], user2['phone'])

def test_update():
	#Create user
	user = create_data()
	res = api_instance.new_user(user)
	data = res.json()
	user['uid'] = data['uid']
	#Wait for DynamoDB resources to be created
	time.sleep(5)
	old_email = user['email']
	new_email = random_email()
	res = api_instance.update_email(new_email, old_email)
	data = res.json()
	if data['message'] == "SUCCESS":
		print("Update Email: Test Passed!")
	else:
		print("Update Email: Test Failed!")

	updated_user = user
	updated_user['email'] = new_email
	res = api_instance.get_user(updated_user['phone'])
	data = res.json()
	if validate_user(data, updated_user):
		print("Update Email (Consistency): Test Passed!")
	else:
		print("Update Email (Consistency): Test Failed!")

	res = api_instance.update_email(old_email, new_email)
	data = res.json()
	if data['message'] == "SUCCESS":
		print("Update Email (Revert): Test Passed!")
	else:
		print("Update Email (Revert): Test Failed!")

	#check Error
	res = api_instance.update_email(new_email, new_email)
	data = res.json()
	if data['message'] == "ERROR":
		print("Update Email (Failure - Nonexistent Email): Test Passed!")
	else:
		print("Update Email (Failure - Nonexistent Email): Test Failed!")

	side_user = create_data()
	res = api_instance.new_user(side_user)
	data = res.json()
	side_user['uid'] = data['uid']

	res = api_instance.update_email(old_email, side_user['email'])
	data = res.json()
	if data['message'] == "EMAIL_EXISTS":
		print("Update Email (Failure - Duplicate Email): Test Passed!")
	else:
		print("Update Email (Failure - Duplicate Email): Test Failed!")

	#CleanUp
	clean_data(user['uid'], user['phone'])
	clean_data(side_user['uid'], side_user['phone'])




def attach_funding(user):
	res = api_instance.get_user(user['phone'])
	data = res.json()
	customer_url = data['customer_url']
	checking = random_checking()
	client = dwollav2.Client(
		key = keys['dwolla_key'],
		secret = keys['dwolla_secret'],
		environment = keys['dwolla_env']
		)
	app_token = client.Auth.client()
	client = boto3.resource('dynamodb', region_name='us-east-1', aws_access_key_id=keys['aws_access_key_id'], aws_secret_access_key=keys['aws_secret_access_key'])
	table = client.Table('DrackerUser')
	item = table.get_item(
		Key={
			'phone': user['phone']
		}
	)
	item = item['Item']
	funding_source = app_token.post('%s/funding-sources' % customer_url, checking)
	source_url = funding_source.headers['location']
	app_token.post('%s/micro-deposits' % source_url)
	#verify with micro deposits
	currency = random_currency()
	request_body = {
		"amount1": {
			"value": random_deposit(),
			"currency": currency
		},
		"amount2": {
			"value": random_deposit(),
			"currency": currency
		}
	}
	app_token.post('%s/micro-deposits' % source_url, request_body)
	new_account = {"url": source_url, "name": random_string(5), "institution": random_string(5)}
	data = {"default" : new_account, "list": [new_account]}
	item['funding_source'] = json.dumps(data)
	table.put_item(Item=item)
	return source_url

def get_number():
	client = boto3.resource('dynamodb', region_name='us-east-1', aws_access_key_id=keys['aws_access_key_id'], aws_secret_access_key=keys['aws_secret_access_key'])
	table = client.Table('DrackerUser')
	return table.scan()['Count']

def check_configrations():
	s3 = boto3.resource('s3', region_name='us-east-1', aws_access_key_id=keys['aws_access_key_id'], aws_secret_access_key=keys['aws_secret_access_key'])
	bucket = s3.Bucket('drackerimages')
	key = 'noImage'
	objs = list(bucket.objects.filter(Prefix=key))
	if len(objs) > 0 and objs[0].key == key:
	    print("Exit condition check: Test Passed!")
	else:
	    print("Exit condition check: Test Failed!")

if __name__ == "__main__":
	before = get_number()
	#test_register()
	#test_register_fail()
	#test_transaction1()
	test_deep1()
	#test_deep2()
	#test_update()
	check_configrations()
	after = get_number()
	if before != after:
		print("Testing data wasn't successfull cleaned up: try running the cleanup script")
		print('Before:%s After:%s' % (before, after))