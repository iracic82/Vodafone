import json
import boto3
import logging

# Set up logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

s3_client = boto3.client('s3')

def handler(event, context):
    logger.info(f"Received event: {event}")

    try:
        # Assuming 'event' is a dictionary that contains 'image_url'
        # For API Gateway Lambda Proxy Integration, event body is a string
        body = json.loads(event.get('body', '{}'))
        image_url = body.get('image_url')

        if not image_url:
            logger.error('No image URL provided')
            return {
                'statusCode': 400,  # Bad Request
                'headers': {'Content-Type': 'application/json'},
                'body': json.dumps({'message': 'No image URL provided'})
            }

        # Parsing bucket name and object key from the URL
        # This accounts for virtual-hosted–style URL format
        path_parts = image_url.split('.s3.')[1]
        region_and_bucket = image_url.split('//')[1].split('.s3.')[0]
        bucket_name = region_and_bucket
        object_key = path_parts.split('/', 1)[1]  # Split once, take everything after the first slash

        logger.info(f"Bucket: {bucket_name}, Key: {object_key}")

        # Fetch the object metadata using head_object
        response = s3_client.head_object(Bucket=bucket_name, Key=object_key)
        image_metadata = {
            'Content-Type': response['ContentType'],
            'Content-Length': response['ContentLength']
        }

        return {
            'statusCode': 200,
            'headers': {'Content-Type': 'application/json'},
            'body': json.dumps(image_metadata)
        }

    except Exception as e:
        logger.error(f"Exception occurred: {e}")
        return {
            'statusCode': 500,  # Internal Server Error
            'headers': {'Content-Type': 'application/json'},
            'body': json.dumps({'error': str(e)})
        }
