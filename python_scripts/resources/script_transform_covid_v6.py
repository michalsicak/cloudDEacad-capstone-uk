import urllib.request as request
import json
import boto3
import pandas as pd

def lambda_handler(event, context):
    #print(event)
    #print(event['Records'][0]['s3']['bucket']['name'])
    bucket_name_dump = event['Records'][0]['s3']['bucket']['name']
    #read the timestamd data to combine into a filename to load 
    #print(bucket_name_dump)
    s3_read = boto3.resource('s3')
    itemname = 'raw-zone/timestamp_file_covid.txt'
    obj = s3_read.Object(bucket_name_dump, itemname)
    body_timestamp = obj.get()['Body'].read()
    timestamp = body_timestamp.decode()
    #print(timestamp)
    covid_filename = 'covid-data-'+timestamp+'.json'
    itemname = 'raw-zone/covid-data/'+covid_filename
    obj = s3_read.Object(bucket_name_dump, itemname)
    body = obj.get()['Body'].read()
    data = json.loads(body)
    json_simple = data['features']
    new_list_of_dicts = [x['attributes'] for x in json_simple]
    data_f = pd.DataFrame(new_list_of_dicts)
    #filter out non-county values
    filter_list = ['OUT OF STATE', 'UNKNOWN', 'INTERNATIONAL']
    #two ways to filter data frames
    data_f_filter = data_f[~data_f['LABEL'].isin(filter_list)]
    #data_f_filter_chain = data_f[~data_f.LABEL.isin(filter_list)]
    data_f_filter.to_csv('/tmp/covid-data.csv',index=False)
    s3_upload = boto3.client('s3')
    #save file to terraform-created S3 bucket under raw-zone for further processing
    #first define an s3 object
    s3_stage = boto3.client('s3')
    #then list all buckets
    bucket_response = s3_stage.list_buckets()
    buckets = bucket_response["Buckets"]
    #then find the bucket containing 'data-stage-bucket'
    correct_bucket = []
    for i in range(0,len(buckets)):
        if 'data-stage-bucket' in buckets[i]['Name']:
            correct_bucket.append(buckets[i]['Name'])
        else:
            continue
    bucket_name_stage = correct_bucket[0]
    #print(bucket_name_stage)
    with open('/tmp/covid-data.csv', "rb") as f:
        s3_upload.upload_fileobj(f, bucket_name_stage, "covid-data/covid-data-"+timestamp+".csv",ExtraArgs={"ServerSideEncryption": "aws:kms"})
    return {
        'statusCode': 200,
        'body': json.dumps('the data has been transformed and stored on S3')
    }