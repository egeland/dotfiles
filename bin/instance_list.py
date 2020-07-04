#!/usr/bin/env python3

import boto3
session = boto3.Session(profile_name='containers-nonproduction')
ec2 = session.client('ec2')
response = ec2.describe_instances()

for reservation in response['Reservations']:
    for instance in reservation['Instances']:
        if 'PrivateIpAddress' in instance:
            ip = instance['PrivateIpAddress']
        else:
            ip = '-'
        i_tags = [ip, '-', '-',instance['InstanceId'],instance['InstanceType'],'ondemand','state_unknown']
        if 'State' in instance:
            i_tags[6] = instance['State']['Name']
        if 'Tags' in instance:
            for tag in instance['Tags']:
                if tag['Key'] == 'Name':
                    i_tags[0] = tag['Value']
                if tag['Key'] == 'Project':
                    i_tags[1] = tag['Value']
                if tag['Key'] == 'aws:cloudformation:stack-name':
                    i_tags[2] = tag['Value']
        if 'InstanceLifecycle' in instance:
            i_tags[5] = instance['InstanceLifecycle']
        print(','.join(i_tags))
