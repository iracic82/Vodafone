# /usr/bin/python3
import boto3
import csv

# Initialize a DynamoDB resource. Ensure AWS credentials are correctly set up in your environment.
dynamodb = boto3.resource('dynamodb', region_name='eu-west-2')
table = dynamodb.Table('CustomerData')

# Replace 'your_data.csv' with the actual name of your CSV file.
with open('selected.csv', newline='', encoding='utf-8') as csvfile:
    reader = csv.DictReader(csvfile)
    for row in reader:
        table.put_item(Item=row)
