import firebase_admin
import json
from firebase_admin import auth
from firebase_admin import credentials
import boto3
import sendgrid
import os
import dwollav2

client = boto3.resource('dynamodb') #get client
table = client.Table('DrackerUser')
cred = credentials.Certificate("./dracker-9443c-firebase-adminsdk-gmc2g-7d48bbd323.json")
main = firebase_admin.initialize_app(cred)
def lambda_handler(event, context):
    # Extract Parameters
    email = event['email']
    name = event['name']
    password = event['password']
    phone = event['phone']
    street = event['street']
    city = event['city']
    state = event['state']
    zipcode = event['zip']
    ssn = event['ssn']
    birthdate = event['birthdate']
    first,last = name.split(' ')
    # First try creating a dwolla entry and validating data
    dwolla_entry = create_dwolla_entry(first, last, email, street, city, state, zipcode, ssn, birthdate)
    if dwolla_entry["message"] != "SUCCESS":
      return dwolla_entry
    customer_url = dwolla_entry["customer_url"]
    register_event = firebase_register(phone, name, email, password)

    # Try Firebase Register
    if register_event["message"] != "SUCCESS":
        return register_event
    uid = register_event["uid"]

    # Add to Database
    #Table put item
    table.put_item(
        Item={
            'phone': phone,
            'email': email, 
            'name': name,
            'uid' : uid,
            'customer_url': customer_url
         }
    )
    create_table(uid)
    send_welcome_email(name, email, uid)
    return {"message" : "SUCCESS", "uid": uid}


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
    api_key = os.environ.get('sg_key')
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

def create_dwolla_entry(first, last, email, street, city, state, zipcode, ssn, birthdate):
  client = dwollav2.Client(
  key = os.environ.get('dwolla_key'),
  secret = os.environ.get('dwolla_secret'),
  environment = os.environ.get('dwolla_env')
  )
  app_token = client.Auth.client()
  request_body = {
  'firstName': first,
  'lastName': last,
  'email': email,
  'type': 'personal',
  'address1': street,
  'city': city,
  'state': state,
  'postalCode': zipcode,
  'dateOfBirth': birthdate,
  'ssn': ssn
  }
  try:
    customer = app_token.post('customers', request_body)
    customer_url = customer.headers['location']
    return {"message" : "SUCCESS", "customer_url": customer_url}
  except Exception as exp:
    return {"message" : 'ERROR'}
