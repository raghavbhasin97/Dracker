import random
from datetime import datetime

first_names = ['Malinda', 'Melodie', 'Emilee', 'Jin', 'Jasmine', 'Nobuko', 'Adrianna', 'Adam', 'Shelby', 'Ethelyn', 'Dora', 'Violet', 'Lizzie', 'Olivia', 'Noelle', 'Daphne', 'Angelica']
last_names = ['Smith', 'Johnson', 'Williams', 'Jones', 'Brown', 'Davis', 'Miller', 'Wilson', 'White', 'Jackson']
domains = ['com', 'org', 'net', 'int', 'edu', 'mil', 'gov', 'io', 'bz', 'me']
hosts = ['gmail', 'mail', 'outlook', 'icloud', 'opaque', 'blurme', 'inbox']
cities = ['Huntsville', 'Anchorage', 'Phoenix', 'Little Rock', 'Sacramento', 'Los Angeles', 'Beverly Hills', 'Denver', 'Hartford', 'Dover', 'Washington', 'Pensacola', 'Miami', 'Orlando', 'Atlanta', 'Chicago']
states = ["AL", "AK", "AZ", "AR", "CA", "CO", "CT", "DE", "FL", "GA", "HI", "ID", "IL", "IN", "IA", "KS", "KY", "LA", "ME", "MD", "MA", "MI", "MN", "MS", "MO", "MT", "NE", "NV", "NH", "NJ", "NM", "NY", "NC", "ND", "OH", "OK", "OR", "PA", "RI", "SC", "SD", "TN", "TX", "UT", "VT", "VA", "WA", "WV", "WI", "WY"]
street = ['Abby Park Street', 'Arthur Street', 'Barn Street', 'Bay Avenue', 'California Street', 'Delaware Avenue', 'Elisabeth Street', 'French Street', 'Main Street', 'Second Street', 'Gateway Street', 'Innovation Avenue']
account_type = ['checking', 'savings']
currency = ['USD']
micro_deposit = ["0.02", "0.03", "0.04", "0.05", "0.06", "0.07", "0.08", "0.09"]


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

def random_string(size):
	random_string = ""
	for i in range(size):
		random_string = random_string + chr(97 + random.randint(0,25)) 
	return random_string

def random_number(size):
	phone = ""
	for i in range(size):
		phone = phone + str(random.randint(0,9))
	return phone

def random_email():
	return random_string(8) + '@' + hosts[random.randint(0,len(hosts) - 1)] + '.' + domains[random.randint(0,len(domains) - 1)]

def random_currency():
	return currency[random.randint(0,len(currency) - 1)]

def random_deposit():
	return micro_deposit[random.randint(0,len(micro_deposit) - 1)]

def random_name():
	return first_names[random.randint(0,len(first_names) - 1)] + ' ' + last_names[random.randint(0,len(last_names) - 1)]

def random_password():
	return random_string(random.randint(6,12))

def random_phone():
	return random_number(10)

def random_street():
	return random_number(4) + ' ' + street[random.randint(0,len(street) - 1)]

def random_city():
	return cities[random.randint(0,len(cities) - 1)]

def random_state():
	return states[random.randint(0,len(states) - 1)]

def random_zip():
	return random_number(5)

def random_ssn():
	return random_number(4)
	
def random_birthday():
	year = random.randint(1950, 1999)
	month = random.randint(1, 12)
	day = random.randint(1, 28)
	birthdate = datetime(year, month, day)
	return birthdate.strftime('%Y-%m-%d')

def random_checking():
	checking = {}
	checking['name'] =  random_string(5) + ' ' + random_string(5)
	checking['routingNumber'] = '222222226' #Has to be hardcoded for verification in sandbox
	checking['accountNumber'] = random_number(9)
	checking['bankAccountType'] = account_type[random.randint(0,len(account_type) - 1)]
	return checking

def random_amount():
	return random_number(random.randint(1,3)) + '.' + random_number(2)

def random_description():
	desc = ''
	for _ in range(1, random.randint(2,4), 1):
		desc += random_string(random.randint(2,5)) + ' '
	return desc

def current_time():
	time = datetime.now()
	return time.strftime('%m/%d/%y %H:%M:%S.%f %p %z') + ' -0400'

def validate_transaction_id(data):
	return len(data) == 32

def sanatize(data):
	return data.replace('\"', '')

def validate_data(data, expected):
	transaction = data['unsettled']
	return (str(data['debit']) == str(expected['amount']) or str(data['credit']) == str(expected['amount'])) and (transaction[0]['transaction_id'] == expected['transaction_id'])

def validate_user(user, expected):
	return user['email'] == expected['email'] and user['name'] == expected['name']

def validate_transaction(transaction, expected):
	return transaction['amount'] == expected['amount'] and transaction['description'] == expected['description'] and transaction['time'] == expected['time']
