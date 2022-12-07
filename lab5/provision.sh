Topics=$(aws sns create-topic --name load_balancer_health --query 'TopicArn' --output text)
Subscribe=$(aws sns subscribe --topic-arn $Topics --protocol email --notification-endpoint mizerak.vlada@gmail.com --query 'SubscriptionArn' --output text)
aws cloudwatch put-metric-alarm --alarm-name Alarm --alarm-description "Instance in target group is deleted." --metric-name HealthyHostCount \

--namespace AWS/ApplicationELB --statistic SampleCount --period 10 --threshold 2 --comparison-operator LessThanThreshold \
--dimensions Name=TargetGroup,Value=targetgroup/TargetGroup/aaf223479a21cd1b Name=LoadBalancer,Value=app/LoadBalancer/9eb8da9008c2a242 \
--evaluation-periods 1 --alarm-actions $Topics --unit Count


