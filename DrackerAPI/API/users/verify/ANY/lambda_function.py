import firebase_admin
from firebase_admin import auth
from firebase_admin import credentials


cred = credentials.Certificate("./dracker-9443c-firebase-adminsdk-gmc2g-7d48bbd323.json")
main = firebase_admin.initialize_app(cred)
def lambda_handler(event, context):
  path = event['path']
  uid = path.replace('/users/verify/', '')
  auth.update_user(
        uid,
        email_verified=True)
  response = get_email_template()
  return generate_response(response)

def generate_response(response):
  return {'statusCode' : 200,
      'headers' : {
                "Content-Type" : "text/html"
            },
            'body' : response
    }

def get_email_template():
  file = open("email.html","r")
  contents =file.read()
  return contents