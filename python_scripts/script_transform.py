import urllib.request as request
import json
import boto3
import pandas as pd

def lambda_handler(event, context):
    print(event)
    print(event['Records'][0]['s3']['bucket']['name'])
    bucket_name = event['Records'][0]['s3']['bucket']['name']
    #read the timestamd data to combine into a filename to load 
    s3_read = boto3.resource('s3')
    #bucketname = 'capstone-team-uk-2-data-dump-bucket'
    itemname = 'raw-zone/timestamp_file_covid.txt'
    obj = s3_read.Object(bucket_name, itemname)
    body_timestamp = obj.get()['Body'].read()
    timestamp = body_timestamp.decode()
    print(timestamp)
    covid_filename = 'covid-data-'+timestamp+'.json'
    #load from s3 raw zone
    s3_read = boto3.resource('s3')
    #bucketname = 'capstone-team-uk-2-data-dump-bucket'
    itemname = 'raw-zone/'+covid_filename
    obj = s3_read.Object(bucket_name, itemname)
    body = obj.get()['Body'].read()
    data = json.loads(body)
    json_simple = data['features']
    new_list_of_dicts = [x['attributes'] for x in json_simple]
    data_f = pd.DataFrame(new_list_of_dicts)
    data_f.index.name = 'id'
    #output_csv = pd.DataFrame.to_csv(data_f)
    output_csv = data_f.to_csv('/tmp/covid-data.csv')
    s3_upload = boto3.client('s3')
    with open('/tmp/covid-data.csv', "rb") as f:
        s3_upload.upload_fileobj(f, "capstone-team-uk-2-data-dump-bucket", "covid-data/covid-data"+timestamp+".csv")
    return {
        'statusCode': 200,
        'body': json.dumps('Hello from Lambda!')
    }