import urllib.request as request
import json
import time
import boto3

def lambda_handler(event, context):
    #call Colorado covid data API and store in a dict
    with request.urlopen('https://services3.arcgis.com/66aUo8zsujfVXRIT/arcgis/rest/services/Colorado_COVID19_Positive_Cases/FeatureServer/0/query?where=1%3D1&objectIds=&time=&geometry=&geometryType=esriGeometryEnvelope&inSR=&spatialRel=esriSpatialRelIntersects&resultType=none&distance=0.0&units=esriSRUnit_Meter&returnGeodetic=false&outFields=*&returnGeometry=false&returnCentroid=false&featureEncoding=esriDefault&multipatchOption=xyFootprint&maxAllowableOffset=&geometryPrecision=&outSR=&datumTransformation=&applyVCSProjection=false&returnIdsOnly=false&returnUniqueIdsOnly=false&returnCountOnly=false&returnExtentOnly=false&returnQueryGeometry=false&returnDistinctValues=false&cacheHint=false&orderByFields=&groupByFieldsForStatistics=&outStatistics=&having=&resultOffset=&resultRecordCount=&returnZ=false&returnM=false&returnExceededLimitFeatures=true&quantizationParameters=&sqlFormat=none&f=pjson&token=') as response:
        source = response.read()
        data_dict = json.loads(source)
    #create a new json file and save contents of API in it
    timestamp = time.strftime("%Y-%m-%d_%I_%M_%p")
    file_name = 'covid-data-'+timestamp+'.json'
    with open('/tmp/'+file_name, 'w') as data_json_file:
        json.dump(data_dict, data_json_file)
    with open('/tmp/timestamp_file.txt', 'w') as timestamp_file:
        timestamp_file.write(timestamp)
        timestamp_file.close()
    timestamp_file_name = "timestamp_file_covid.txt"
    timestamp_file = open("/tmp/"+timestamp_file_name, 'w')
    timestamp_file.write(timestamp)
    timestamp_file.close()
    #save file to terraform-created S3 bucket under raw-zone for further processing
    #first define an s3 object
    s3 = boto3.client('s3')
    #then list all buckets
    bucket_response = s3.list_buckets()
    buckets = bucket_response["Buckets"]
    #then find the bucket containing 'data-dump-bucket'
    correct_bucket = []
    for i in range(0,len(buckets)):
        if 'data-dump-bucket' in buckets[i]['Name']:
            correct_bucket.append(buckets[i]['Name'])
        else:
            continue
    correct_bucket_name = correct_bucket[0]
    with open('/tmp/'+file_name, "rb") as f:
        s3.upload_fileobj(f, correct_bucket_name, "raw-zone/covid-data/"+file_name,ExtraArgs={"ServerSideEncryption": "aws:kms"})
    #upload latest timestamp to a file to construct file names for download
    with open("/tmp/"+timestamp_file_name, "rb") as f:
        s3.upload_fileobj(f, correct_bucket_name, "raw-zone/"+timestamp_file_name,ExtraArgs={"ServerSideEncryption": "aws:kms"})
    return {
        'statusCode': 200,
        'body': json.dumps('the data has been downloaded and stored on S3')
    }