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
		dwollaclient = dwollav2.Client(
			key = self.keys['dwolla_key'],
			secret = self.keys['dwolla_secret'],
			environment = self.keys['dwolla_env']
		)
		self.dwolla = dwollaclient.Auth.client()

	def start(self, omit):
		table = self.dynamodb.Table(self.keys['user_table'])
		rows = table.scan()['Items']
		for item in rows:
			if item['uid'] in omit or item['phone'] in omit or item['email'] in omit:
				continue
			try:
				if 'funding_source' in item:
					Cleanup.cleanup_funding_sources(self, item['funding_source'])

				customer_url = item['customer_url']
				request_body = {
					'status': 'deactivated'
				}
				self.dwolla.post(customer_url, request_body)
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
				print('Some Error in cleaning up: ' + item['email'])
				print('Item Details: ' + item)
				print('Error: ' + err)

	def get_images(self, uid):
		images = []
		table = self.dynamodb.Table(uid)
		rows = table.scan()['Items']
		for item in rows:
			if item['tagged_image'] != 'noImage':
				images.append(item['tagged_image'])
		return images

	def cleanup_funding_sources(self, data):
		funding_list = json.loads(data)['list']
		request_body = {
			'removed': True
		}
		for item in funding_list:
			url = item['url']
			self.dwolla.post(url, request_body)

if __name__ == "__main__":
	cleanup = Cleanup()
	#Load users to exclude
	preserve_users = open('preserve_users.txt', 'rb').read().split('\n')
	cleanup.start(preserve_users)
	print("Cleanup complete!")
