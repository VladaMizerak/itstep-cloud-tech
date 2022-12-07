Instance_ID=$(aws ec2 describe-instances --filters Name=instance-state-name,Values=stopped Name=instance-type,Values=t2.micro --query 'Reservations[*].Instances[].InstanceId' --output text) 
Image_ID=$(aws ec2 create-image --instance-id $Instance_ID --name 'image' --description 'AMI.' --query ImageId --output text) 
echo $Image_ID 
echo $Instance_ID 

