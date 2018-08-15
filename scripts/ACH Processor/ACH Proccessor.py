import boto3
import dwollav2
import os


dwolla_client = dwollav2.Client(
    key = os.environ.get('dwolla_key'),
    secret = os.environ.get('dwolla_secret'),
    environment = os.environ.get('dwolla_env')
    )
dwolla_token = dwolla_client.Auth.client()

client = boto3.resource('dynamodb')
transactions_table = client.Table('DrackerTransactions')
def lambda_handler(event, context):
    rows = transactions_table.scan()['Items']
    for row in rows:
        transactions = row['transactions']
        new_list = []
        for item in transactions:
            status = check_status(item['id'])
            if status == 'processed':
                print('Processed: ' + item['id'])
            else:
                new_list.append(item)

        if len(new_list) == 0:
            transactions_table.delete_item(
                Key={
                    'email': row['email']
                }
            )
        else:
            row['transactions'] = new_list
            transactions_table.put_item(Item=row)

    return 200


def check_status(transaction_id):
    transfer_url = 'https://api-sandbox.dwolla.com/transfers/'+transaction_id
    transfer = dwolla_token.get(transfer_url)
    return transfer.body['status']
