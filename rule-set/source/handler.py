import json


def hello(event, context):
    body = {
        "message": "test",
        "input": event
    }

    response = {
        "statusCode": 200,
        "body": json.dumps(body)
    }

    print response
    return response
