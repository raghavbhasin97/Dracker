import dwollav2
import firebase_admin
from firebase_admin import auth
from firebase_admin import credentials
from utils import *
from api import *
import boto3

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
	print('Clean up started')
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
			print('Clean up interupted => Table still being created, Retry...')
	print('Clean up ended')


def test_register():
	user = create_data()
	(uid,phone) = register_user(user)
	if uid != None:
		clean_data(uid, phone)

def test_register_fail():
	user = create_data()
	user['birthdate'] = '2018-01-01'
	res = api_instance.new_user(user)
	data = res.json()
	if data['message'] != 'ERROR':
		print("Register new user (Case: failure): Test Failed! shoul've returned ERROR but returned success")
		clean_data(data['uid'], user['phone'])
		return
	print("Register new user (failure): Test Passed!")
if __name__ == "__main__":
	test_register()
	test_register_fail()
	