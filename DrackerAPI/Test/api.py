import requests
import json
from utils import *

class api:
	def __init__(self, filename):
		self.keys = json.loads((open(filename,"r")).read())
		self.stage = self.keys['stage']
		self.base_url = "https://uwjxhdmmub.execute-api.us-east-1.amazonaws.com/%s" % (self.stage) 
		self.headers = {"x-api-key" : self.keys['dracker-key']}

	def new_user(self, user):
		endpoint = '%s/users/create' % (self.base_url) 
		return requests.put(endpoint, headers=self.headers, params=user)

	def create_transaction(self, user1, user2):
		endpoint = '%s/transaction/add' % (self.base_url) 
		params = {}
		params['amount'] = random_amount()
		params['description'] = random_description()
		params['image'] = 'noImage' #Blank Image
		params['notification'] = random_string(4)
		params['payee_name'] = user1['name']
		params['payee_phone'] = user1['phone']
		params['payee_uid'] = user1['uid']
		params['payer_name'] = user2['name']
		params['payer_phone'] = user2['phone']
		params['payer_uid'] = user2['uid']
		params['time'] = current_time()

		return (params, requests.put(endpoint, headers=self.headers, params=params))

	def delete_transaction(self, uid1, uid2, transaction_id):
		endpoint = '%s/transaction/delete' % (self.base_url)
		params = {}
		params['payer_uid'] = uid2
		params['payee_uid'] = uid1
		params['transaction_id'] = transaction_id
		return requests.get(endpoint, headers=self.headers, params=params)

	def settle_transaction(self, uid1, uid2, transaction_id):
		endpoint = '%s/transaction/settle' % (self.base_url)
		params = {}
		params['payer_uid'] = uid2
		params['payee_uid'] = uid1
		params['transaction_id'] = transaction_id
		params['time'] = current_time()
		return requests.get(endpoint, headers=self.headers, params=params)

	def get_user_transactions(self, uid):
		endpoint = ('%s/users/' % (self.base_url)) + uid
		return requests.get(endpoint, headers=self.headers)

	def get_transaction(self, uid, transaction_id):
		endpoint = '%s/transaction' % (self.base_url)
		params = {}
		params['uid'] = uid
		params['transaction_id'] = transaction_id
		return requests.get(endpoint, headers=self.headers, params=params)

	def get_user(self, phone):
		endpoint = '%s/users' % (self.base_url)
		params = {}
		params['phone'] = phone
		return requests.get(endpoint, headers=self.headers, params=params)

	def get_keys(self):
		return self.keys