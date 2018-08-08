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

#Create test data
def create_data():
	user = {}
	user['email'] = random_email()
	user['name'] = random_name()
	user['password'] = random_password()
	user['phone'] = random_phone()
	user['street'] = random_street()
	user['city'] = random_city()
	user['state'] = random_state()
	user['zip'] = random_zip()
	user['ssn'] = random_ssn()
	user['birthdate'] = random_birthday()
	return user

def clean_data(uid, phone):
	auth.delete_user(uid) #Clear Firebase
	#Clear Entry in DrackerUser
	keys = api_instance.get_keys() 
	client = boto3.resource('dynamodb', region_name='us-east-1', aws_access_key_id=keys['aws_access_key_id'], aws_secret_access_key=keys['aws_secret_access_key'])
	table = client.Table('DrackerUser')
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
		print("Register new user (Case: failure): Test Failed! shoul've returned ERROR but returned success")
		clean_data(data['uid'], user['phone'])
		return
	print("Register new user (Case: failure): Test Passed!")

def test_add_transaction1():
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
	res = api_instance.create_transaction(user1, user2)
	transaction_id = sanatize(res.text)
	if validate_transaction_id(transaction_id):
		print("Add a new transaction (Add Transaction): Test Passed!")
	else:
		print("Add a new transaction (Add Transaction): Test Failed!")

	#Test Settle Transaction This should fail right now
	res = api_instance.settle_transaction(user1['uid'], user2['uid'], transaction_id)
	response_status = sanatize(res.text)
	if response_status == "404":
		print("Add a new transaction (Settle Transaction): Test Passed!")
	else:
		print("Add a new transaction (Settle Transaction): Test Failed!")

	#Test delete this transaction now
	res = api_instance.delete_transaction(user1['uid'], user2['uid'], transaction_id)
	response_status = sanatize(res.text)
	if response_status == "200":
		print("Add a new transaction (Delete Transaction): Test Passed!")
	else:
		print("Add a new transaction (Delete Transaction): Test Failed!")
	#CleanUp
	clean_data(user1['uid'], user1['phone'])
	clean_data(user2['uid'], user2['phone'])


if __name__ == "__main__":
	test_register()
	test_register_fail()
	test_add_transaction1()
	