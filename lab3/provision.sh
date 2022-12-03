aws ec2 create-default-vpc
aws ec2 create-key-pair --key-name keyPair --query 'KeyMaterial' --output text > keyPair.pem 
chmod 400 keyPair.pem 
Vpc_ID=$(aws ec2 describe-vpcs --query 'Vpcs[0].VpcId' --output text) 
aws ec2 create-security-group --group-name SecurityGroup --description "security group" 
Security_group=$(aws ec2 describe-security-groups --query 'SecurityGroups[0].GroupId' --output text) 
aws ec2 authorize-security-group-ingress --group-id $Security_group --protocol tcp --port 22 --cidr 0.0.0.0/0 
aws ec2 authorize-security-group-ingress --group-id $Security_group  --protocol tcp --port 80 --cidr 0.0.0.0/0 
aws ec2 authorize-security-group-ingress --group-id $Security_group  --protocol tcp --port 443 --cidr 0.0.0.0/0 
Net_ID=$(aws ec2 describe-subnets --query 'Subnets[0].SubnetId' --output text) 
Instance_ID=$(aws ec2 run-instances --image-id ami-0b0dcb5067f052a63 --count 1 --instance-type t2.micro --key-name keyPair --security-group-ids $Security_group --user-data file://data.sh --query 'Instances[*].[InstanceId]' --output text) 
aws ec2 create-tags --resources $Instance_ID --tags Key=Name,Value=Instance 
echo $Instance_ID 