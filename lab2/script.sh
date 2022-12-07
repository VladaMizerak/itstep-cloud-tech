aws ec2 create-vpc --cidr-block 10.0.0.0/16 
Vpc_ID=$(aws ec2 describe-vpcs --query 'Vpcs[0].VpcId' --output text) 

aws ec2 create-subnet --vpc-id $Vpc_ID --cidr-block 10.0.1.0/24 
Net1=$(aws ec2 describe-subnets --query 'Subnets[0].SubnetId' --output text) 

aws ec2 create-internet-gateway 
Internet_gw=$(aws ec2 describe-internet-gateways --query 'InternetGateways[0].InternetGatewayId' --output text) 
aws ec2 attach-internet-gateway --internet-gateway-id $Internet_gw --vpc-id $Vpc_ID 
Alloc_id=$(aws ec2 describe-addresses --query 'Addresses[1].AllocationId' --output text) 

aws ec2 create-nat-gateway --subnet-id $Net1 --allocation-id $Alloc_id 
Nat_gw=$(aws ec2 describe-nat-gateways --query 'NatGateways[-1].NatGatewayId' --output text) 

aws ec2 create-route-table --vpc-id $Vpc_ID 
Route_table=$(aws ec2 describe-route-tables --query 'RouteTables[0].RouteTableId' --output text) 
aws ec2 create-route --route-table-id $Route_table --destination-cidr-block 0.0.0.0/0 --gateway-id $Internet_gw 
aws ec2 associate-route-table --route-table-id $Route_table --subnet-id $Net1 

aws ec2 create-security-group --group-name public-group --description "public group" --vpc-id $Vpc_ID 
Public_group=$(aws ec2 describe-security-groups --query 'SecurityGroups[0].GroupId' --output text) 
aws ec2 authorize-security-group-ingress --group-id $Public_group --protocol tcp --port 22 --cidr 0.0.0.0/0 

aws ec2 create-key-pair --key-name cli-keyPair --query 'KeyMaterial' --output text > cli-keyPair.pem 
chmod 400 cli-keyPair.pem 

aws ec2 run-instances --image-id ami-0533f2ba8a1995cf9 --instance-type t2.micro --count 1 --subnet-id $Net1 --security-group-ids $Public_group --associate-public-ip-address --key-name cli-keyPair 
Instance_ID=$(aws ec2 describe-instances --instance-ids --query 'Reservations[0].Instances[0].InstanceId' --output text) 
aws ec2 modify-vpc-attribute --enable-dns-hostnames --vpc-id $Vpc_ID 
itstepuser=$(aws ec2 describe-instances --instance-ids $Instance_ID --query 'Reservations[].Instances[].PublicDnsName' --output text) 
echo ssh -i "cli-keyPair.pem" ec2-itstepuser@$itstepuser
