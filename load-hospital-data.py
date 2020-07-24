#!/usr/bin/env python
# coding: utf-8

# In[11]:


import urllib.request as request
import json
import time
import boto3


# In[12]:


#call USA hospital data API and store in a dict
with request.urlopen('https://services7.arcgis.com/LXCny1HyhQCUSueu/arcgis/rest/services/Definitive_Healthcare_USA_Hospital_Beds/FeatureServer/0/query?where=STATE_NAME+%3D+%27Colorado%27&outFields=*&outSR=4326&f=json') as response:
    source = response.read()
    data_dict = json.loads(source)


# In[13]:


#create a new json file and save contents of API in it
timestamp = time.strftime("%Y-%m-%d_%I_%M_%p")
#create a dynamic file name for incremental uploads
file_name = 'hospital-data-'+timestamp+'.json'
#save contents of the API into the file to later upload to S3
with open(file_name, 'w') as data_json_file:
    json.dump(data_dict, data_json_file)


# In[14]:


timestamp_file = open("timestamp_file_hospitals.txt", 'w')
timestamp_file.write(timestamp)
timestamp_file.close()


# In[15]:


#ensure key access key and secret are in the credentials folder or environment variables
#see https://boto3.amazonaws.com/v1/documentation/api/latest/guide/credentials.html

#save file to terraform-created S3 bucket under raw-zone for further processing
s3 = boto3.client('s3')
with open(file_name, "rb") as f:
    s3.upload_fileobj(f, "capstone-team-uk-data-dump-bucket", "raw-zone/"+file_name)


# In[16]:


#upload latest timestamp to a file to construct file names for download
with open("timestamp_file_hospitals.txt", "rb") as f:
    s3.upload_fileobj(f, "capstone-team-uk-data-dump-bucket", "raw-zone/timestamp_file_hospitals.txt")

