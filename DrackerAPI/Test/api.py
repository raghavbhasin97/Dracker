import requests
import json

class api:
	def __init__(self, filename):
		self.keys = json.loads((open(filename,"r")).read())
		self.stage = self.keys['stage']
		self.base_url = "https://uwjxhdmmub.execute-api.us-east-1.amazonaws.com/%s" % (self.stage) 
		self.headers = {"x-api-key" : self.keys['dracker-key']}

	def new_user(self, user):
		create_endpoint = '%s/users/create' % (self.base_url) 
		return requests.put(create_endpoint, headers=self.headers, params=user)
	def get_keys(self):
		return self.keys