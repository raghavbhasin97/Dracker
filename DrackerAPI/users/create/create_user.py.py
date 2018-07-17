import firebase_admin
import json
from firebase_admin import auth
from firebase_admin import credentials
import boto3
import sendgrid

client = boto3.resource('dynamodb') #get client
table = client.Table('DrackerUser')
cred = credentials.Certificate("./dracker-9443c-firebase-adminsdk-gmc2g-7d48bbd323.json")
main = firebase_admin.initialize_app(cred)
def lambda_handler(event, context):
    email = event['email']
    name = event['name']
    password = event['password']
    phone = event['phone']
    register_event = firebase_register(phone, name, email, password)
    if register_event["message"] != "SUCCESS":
        return register_event
    uid = register_event["uid"]
    #Table put item
    table.put_item(
        Item={
            'phone': phone,
            'email': email, 
            'name': name,
            'uid' : uid
         }
    )
    create_table(uid)
    send_welcome_email(name, email, uid)
    return {"message" : "SUCCESS"}


def firebase_register(phone, name, email, password):
	try:
		user = auth.create_user(
			email=email,
			email_verified=False,
			phone_number='+1' + phone,
			password=password,
			display_name=name,
			disabled=False)
		return {"message" : "SUCCESS", "uid": user.uid}
	except Exception as new_user_exception:
		error = new_user_exception.detail.response.content
		response = json.loads(error)
		error_code = response["error"]["message"]
		return {"message" : error_code}

def create_table(table_name):
    _ = client.create_table(
        AttributeDefinitions=[
            {
                'AttributeName': 'transaction_id',
                'AttributeType': 'S',
            }
        ],
        KeySchema=[
            {
                'AttributeName': 'transaction_id',
                'KeyType': 'HASH',
            }
        ],
        ProvisionedThroughput={
            'ReadCapacityUnits': 5,
            'WriteCapacityUnits': 5,
        },
        TableName=table_name,
    )

def send_welcome_email(name, email, uid):
    api_key = '.....'
    sg = sendgrid.SendGridAPIClient(apikey=api_key)
    data = {
      "personalizations": [
        {
          "to": [
            {
              "email": email
            }
          ],
          "subject": "Welcome to Dracker!"
        }
      ],
      "from": {
        "email": "no-reply@dracker.com"
      },
      "content": [
        {
          "type": "text/html",
          "value": get_email_template(name, email, uid)
        }
      ]
    }
    sg.client.mail.send.post(request_body=data)

def get_email_template(name, email, uid):
  file = open("welcome_email.html","r")
  contents =file.read()
  return contents.replace('{name}', name).replace('{email}', email).replace('{uid}', uid)

