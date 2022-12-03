LB=$(aws elbv2 describe-load-balancers --query 'LoadBalancers[*].LoadBalancerArn' --output text)
echo $LB
TG=$(aws elbv2 describe-target-groups --query 'TargetGroups[*].TargetGroupArn' --output text)
echo $TG
Instance1=$(aws ec2 describe-instances --query 'Reservations[-1].Instances[*].[InstanceId]' --filters Name=instance-state-name,Values=running --output text)
Instance2=$(aws ec2 describe-instances --query 'Reservations[-2].Instances[*].[InstanceId]' --filters Name=instance-state-name,Values=running --output text)
echo $Instance1
echo $Instance2
aws elbv2 register-targets --target-group-arn $TG --targets Id=$Instance1 Id=$Instance2
aws elbv2 create-listener --load-balancer-arn $LB --protocol HTTP --port 80 --default-actions Type=forward,TargetGroupArn=$TG
aws elbv2 describe-target-health --target-group-arn $TG
aws autoscaling create-auto-scaling-group --auto-scaling-group-name ASG --instance-id $Instance1 --min-size 2 --max-size 2 --target-group-arns $TG 
aws autoscaling describe-load-balancer-target-groups --auto-scaling-group-name ASG
aws autoscaling update-auto-scaling-group --auto-scaling-group-name ASG --health-check-type ELB --health-check-grace-period 15 
LB_DNS=$(aws elbv2 describe-load-balancers --query 'LoadBalancers[0].DNSName' --output text)
aws autoscaling describe-auto-scaling-groups --auto-scaling-group-name ASG
echo $LB_DNS
