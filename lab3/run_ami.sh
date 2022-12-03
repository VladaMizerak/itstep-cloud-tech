Image_ID=$(aws ec2 describe-images --owners 372532513477 --query 'Images[*].ImageId' --output text) 
echo $Image_ID 
aws ec2 run-instances --image-id $Image_ID --count 1 --instance-type t2.micro --key-name keyPair --security-group-ids $Security_group --user-data file://data.sh