import firebase_admin
import json
from firebase_admin import auth
from firebase_admin import credentials
import boto3
import sendgrid
import os

client = boto3.resource('dynamodb') #get client
table = client.Table('DrackerUser')
cred = credentials.Certificate("./dracker-9443c-firebase-adminsdk-gmc2g-7d48bbd323.json")
main = firebase_admin.initialize_app(cred)
def lambda_handler(event, context):
  new_email = event['new_email']
  old_email = event['old_email']
  try:
      user = auth.get_user_by_email(old_email)
      phone = user.phone_number
      uid = user.uid
      auth.update_user(
          uid,
          email=new_email,
          email_verified=False)
      phone = phone[2:]
      item = table.get_item(
            Key={
            'phone': phone
            }
        )

      item = item['Item']
      item['email'] = new_email
      table.put_item(Item=item)
      name = user.display_name
      send_verification_email(name, old_email, new_email, uid)
      return {"message" : "SUCCESS"}
  except Exception as new_user_exception:
      print(new_user_exception)
      error = new_user_exception.detail.response.content
      response = json.loads(error)
      error_code = response["error"]["message"]
      return {"message" : error_code}

def send_verification_email(name, old_email, new_email, uid):
    api_key = os.environ.get('sg_key')
    sg = sendgrid.SendGridAPIClient(apikey=api_key)
    data = {
      "personalizations": [
        {
          "to": [
            {
              "email": new_email
            }
          ],
          "subject": "Verify Email"
        }
      ],
      "from": {
        "email": "no-reply@dracker.com"
      },
      "content": [
        {
          "type": "text/html",
          "value": get_email_template(name, old_email, new_email, uid)
        }
      ]
    }
    sg.client.mail.send.post(request_body=data)

def get_email_template(name, old_email, new_email, uid):
  file = open("verification_email.html","r")
  contents =file.read()
  return contents.replace('{old_email}', old_email).replace('{new_email}', new_email).replace('{name}', name).replace('{uid}', uid)