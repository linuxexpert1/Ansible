#!/usr/bin/env bash
#Auth: Abdi Hersi
#Date:
#script to add  SG to all instances.
#Get security Group ID using security name from specific VPC e.g. ./test-sg-add.sh  vpc-be1b64db  SG_Ansible_Master_01

export VPCID=$1
export SGname=$2

ADDSG=$(aws ec2 describe-security-groups --filter Name=vpc-id,Values=$VPCID Name=group-name,Values=$SGname --query 'SecurityGroups[*].[GroupId]' --output text)

echo $ADDSG
