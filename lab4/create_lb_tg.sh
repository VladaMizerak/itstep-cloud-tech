Vpc_ID=$(aws ec2 describe-vpcs --query 'Vpcs[0].VpcId' --output text) 
Net1=$(aws ec2 describe-subnets --query 'Subnets[0].SubnetId' --output text) 
Net2=$(aws ec2 describe-subnets --query 'Subnets[-1].SubnetId' --output text) 
Net_all=$(aws ec2 describe-subnets --query 'Subnets[*].SubnetId' --output text)
Security_group=$(aws ec2 describe-security-groups --query 'SecurityGroups[-1].GroupId' --output text)
New_SG=$(aws ec2 describe-security-groups --query 'SecurityGroups[-3].GroupId' --output text)
Load_balancer=$(aws elbv2 create-load-balancer --name LoadBalancer --subnets $Net_all --security-group $Security_group --query 'LoadBalancers[*].LoadBalancerArn' --output text)
Target_group=$(aws elbv2 create-target-group --name TargetGroup --protocol HTTP --port 80 --vpc-id $Vpc_ID --query 'TargetGroups[*].TargetGroupArn' --output text) 
Image_ID=$(aws ec2 describe-images --owners 372532513477 --query 'Images[0].ImageId' --output text) 
Instance1=$(aws ec2 run-instances --image-id $Image_ID --count 1 --instance-type t2.micro --key-name MyKeyPair1 --security-group-ids $Security_group --subnet-id $Net1 --query 'Instances[-1].[InstanceId]' --output text) 
Instance2=$(aws ec2 run-instances --image-id $Image_ID --count 1 --instance-type t2.micro --key-name MyKeyPair1 --security-group-ids $Security_group --subnet-id $Net2 --query 'Instances[-1].[InstanceId]' --output text)
echo $Security_group
echo $Image_ID
echo $Instance1
echo $Instance2