import dwollav2
import firebase_admin
from firebase_admin import auth
from firebase_admin import credentials
import boto3
import json


class Cleanup:
	def __init__(self):
		self.keys = json.loads((open("keys.json","r")).read())
		cred = credentials.Certificate("./dracker-9443c-firebase-adminsdk-gmc2g-7d48bbd323.json")
		firebase_admin.initialize_app(cred)
		self.dynamodb = boto3.resource('dynamodb', region_name='us-east-1', aws_access_key_id=self.keys['aws_access_key_id'], aws_secret_access_key=self.keys['aws_secret_access_key'])
		self.s3 = boto3.resource('s3', region_name='us-east-1', aws_access_key_id=self.keys['aws_access_key_id'], aws_secret_access_key=self.keys['aws_secret_access_key'])

	def start(self, omit):
		table = self.dynamodb.Table(self.keys['user_table'])
		rows = table.scan()['Items']
		for item in rows:
			if item['uid'] in omit:
				continue
			try:
				self.s3.Object(self.keys['profile'], item['uid']).delete()
				auth.delete_user(item['uid'])
				table.delete_item(
					Key={
					'phone': item['phone']
					}
				)
				self.dynamodb.Table(item['uid']).delete()
				transactioon_images = Cleanup.get_images(self, item['uid'])
				for image in transactioon_images:
					self.s3.Object(self.keys['transaction'], image).delete()
			except Exception as err:
				pass

	def get_images(self, uid):
		images = []
		table = self.dynamodb.Table(uid)
		rows = table.scan()['Items']
		for item in row:
			if item['tagged_image'] != 'noImage':
				images.append(item['tagged_image'])
		return images


if __name__ == "__main__":
	cleanup = Cleanup()
	#Clean all, but the three testing accounts for now
	cleanup.start({'rgYSeuGaHihLExi2bGLoh7TjwcB3', 'kJGc3Hnb2jY9HsExcZw4VOgOwDB3', 'vSS8SEcWLAQYu1HddSntntH6SnZ2'})