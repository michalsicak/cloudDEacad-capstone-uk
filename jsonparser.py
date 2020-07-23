import json
import logging
import fastjsonschema
logger = logging.getLogger()
logger.setLevel(logging.INFO)
def validate_json(json_data, validator):
    try:
        validator(json_data)
    except fastjsonschema.JsonSchemaException as err:
        logger.warning(err.message)
        logger.warning(err.value)
        logger.warning(err.rule)
        logger.warning(err.rule_definition)
        return False
    return True
def convert_data(content: list, report_name):
    
    if (report_name == 'SlalomStock'):
        json_schema = {'type': 'object',
                        'properties': {
                                'PID Number': {'type': 'string'},
                                'SKU': {'type': 'string'},
                                'Depot Code': {'type': 'string'},
                                'Location Code': {'type': 'string'},
                                'Location Type': {'type': 'string'},
                                'SupplierBatchNumber': {'type': 'string'},
                                'Order No': {'type': 'string'},
                                'Weight': {'type': 'number'},
                                'Volume': {'type': 'number'},
                                'Loading Metres': {'type': 'number'},
                                'No of Pieces': {'type': 'number'},
                                'PID Value': {'type': 'number'},
                                'Job Number': {'type': 'string'},
                                'Trip No': {'type': 'string'},
                                'Address': {'type': 'string'},
                                'Addres type': {'type': 'string'},
                                'POD': {'type': 'string'},
                                'Comments': {'type': 'string'},
                                'Rejected Date': {'type': 'string'},
                                'Rejected Reason': {'type': 'string'},
                                'User': {'type': 'string'},
                                'Action Code': {'type': 'string'},
                                'Updated On Screen': {'type': 'string'},
                                'Movement Date': {'type': 'string'}
                        },
                        'required':["PID Number",
                                    "SKU",
                                    "Depot Code",
                                    "Location Code",
                                    "Location Type",
                                    "SupplierBatchNumber",
                                    "Order No",
                                    "Weight",
                                    "Volume",
                                    "Loading Metres",
                                    "No of Pieces",
                                    "PID Value",
                                    "Job Number",
                                    "Trip No",
                                    "Address",
                                    "Addres type",
                                    "POD",
                                    "Comments",
                                    "Rejected Date",
                                    "Rejected Reason",
                                    "User",
                                    "Action Code",
                                    "Updated On Screen",
                                    "Movement Date"],
                        'additionalProperties': False
            }
    elif (report_name == 'SlalomJob'):
        json_schema = {'type': 'object',
                        'properties': {
                                    "Job Number": {'type': 'integer'},
                                    "Job Status": {'type': "string"},
                                    "Status Description": {'type': "string"},
                                    "Job Entered Time": {'type':"string"},
                                    "Order No": {'type':"string"},
                                    "Tracking Action": {'type': "string"},
                                    "Tracking Entry Date": {'type': "string"}
                        },
                        'required':["Job Number",
                                    "Job Status",
                                    "Status Description",
                                    "Job Entered Time",
                                    "Order No",
                                    "Tracking Action",
                                    "Tracking Entry Date"],
                        'additionalProperties': False
            }
    elif (report_name == 'SlalomTrip'):
        json_schema = {'type': 'object',
                        'properties': {
                                    "Trip number": {'type': 'integer'},
                                    "Trip Created Date": {'type': "string"},
                                    "Trip Status": {'type': "string"},
                                    "Trip Date": {'type': "string"},
                                    "Driver 1": {'type':"string"},
                                    "Driver 2": {'type':"string"},
                                    "Job Number": {'type': "integer"},
                                    "Tracking Action": {'type': "string"},
                                    "Tracking Description": {'type': "string"},
                                    "Tracking action Date": {'type': "string"}
                        },
                        'required':["Trip number",
                                    "Trip Created Date",
                                    "Trip Status",
                                    "Trip Date",
                                    "Driver 1",
                                    "Driver 2",
                                    "Job Number",
                                    "Tracking Action",
                                    "Tracking Description",
                                    "Tracking action Date"],
                        'additionalProperties': False
            }
    valid_lines = ""
    invalid_lines = ""
    validator = fastjsonschema.compile(json_schema)
    for json_line in content:
        is_valid = validate_json(json_line,validator)
        converted_json = json.dumps(json_line)
        if is_valid == True:
            valid_lines += converted_json + "\n"
        else:
            invalid_lines += converted_json + "\n"
            
    return {"valid_lines" : valid_lines
            , "error_lines" : invalid_lines}

if json_lines["valid_lines"]:
 s3_key = s3_key_path + s3_key_file
 s3_response = s3_client.put_object(Body=json_lines["valid_lines"], Bucket=os.environ["S3_BUCKET"], Key=s3_key)
 logger.info(s3_response)