#!/usr/bin/env bash
#Auth: Abdi Hersi
#Date:
#script to add  SG to all instances.
# e.g  export AWS_DEFAULT_REGION=us-east-1 && ./add_sg_to_ec2.sh vpc-be1b64db  SG_Ansible_Master_01

export VPCID=$1
export SGname=$2

ADDSG=$(aws ec2 describe-security-groups --filter Name=vpc-id,Values=$1 Name=group-name,Values=$2 --query 'SecurityGroups[*].[GroupId]' --output text)
for instid in $(cat  instid-file)
    do
      echo "Checking Security Groups..."
      SG=$(aws  ec2 describe-instances --instance-ids $instid --output json | jq ".[][].Instances[].SecurityGroups[].GroupId" -r | xargs)
      echo "Existing SGs: $SG"
        if [[ $SG == *$ADDSG* ]]; then
        echo "$ADDSG already associated, do nothing"

         else
           aws ec2 modify-instance-attribute --instance-id ${instid} --groups  $SG  $ADDSG
           echo "New SGs: $(aws  ec2 describe-instances --instance-ids $instid --output json | jq ".[][].Instances[].SecurityGroups[].GroupId" -r | xargs)"
      fi
done 
