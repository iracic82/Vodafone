import boto3
import json
from boto3.dynamodb.conditions import Key

def handler(event, context):
    # Parse the JSON body from the event
    try:
        body = json.loads(event.get('body', ''))
        customer_id = body.get('customer_id')
    except json.JSONDecodeError:
        return {
            'statusCode': 400,
            'body': json.dumps({'error': 'Invalid JSON in request body'})
        }

    if not customer_id:
        return {
            'statusCode': 400,
            'body': json.dumps({'error': 'Customer ID not provided'})
        }

    try:
        dynamodb = boto3.resource('dynamodb')
        table = dynamodb.Table('CustomerData')

        response = table.query(
            KeyConditionExpression=Key('CustomerID').eq(customer_id)
        )
        return {
            'statusCode': 200,
            'body': json.dumps(response['Items'])
        }

    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }
