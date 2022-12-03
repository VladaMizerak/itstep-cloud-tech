Topics=$(aws sns create-topic --name load_balancer_health --query 'TopicArn' --output text)
Subscribe=$(aws sns subscribe --topic-arn $Topics --protocol email --notification-endpoint mizerak.vlada@gmail.com --query 'SubscriptionArn' --output text)
aws cloudwatch put-metric-alarm --alarm-name Alarm --alarm-description "Instance in target group is deleted." --metric-name HealthyHostCount \
--namespace AWS/ApplicationELB --statistic Average --period 60 --threshold 2 --comparison-operator LessThanThreshold \
--dimensions Name=TargetGroup,Value=targetgroup/TargetGroup/6f9aca4fb77d2df3 Name=LoadBalancer,Value=app/LoadBalancer/2e713b709b250f51 \
--evaluation-periods 1 --alarm-actions $Topics



