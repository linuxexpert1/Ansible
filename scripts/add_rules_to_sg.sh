#!/bin/bash
##Auth: Abdi Hersi
# This was implemented by Abdihakim Hersi


export port=$1
export description=$2

for i in default
do
    OWNER_ID=`aws iam get-user --profile $i --output text | awk -F ':' '{print $5}'`
    tput setaf 2;echo "Profile : $i";tput sgr0
    tput setaf 2;echo "OwnerID : $OWNER_ID";tput sgr0
    for region in us-east-1
    do
        tput setaf 1;echo  "Adding new CIDRs to Security Group rule in $region";tput sgr0
        export AWS_DEFAULT_REGION=${region}
      echo "Please wait..."
      for sg in $(cat sg_id-file.txt )
        do
           for ansrule in $(cat security_list_ip.txt)
            do
              aws ec2 authorize-security-group-ingress --group-id ${sg} --ip-permissions '[{"IpProtocol": "tcp", "FromPort": $1, "ToPort": $1, "IpRanges":  [{"CidrIp": "'$rule'","Description":"'$2'" }]}]'
           done
    done
    done &
done
wait
