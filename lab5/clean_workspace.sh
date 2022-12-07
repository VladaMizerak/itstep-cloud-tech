Topics=$(aws sns list-topics --query 'Topics[*].TopicArn' --output text)
Alarm=$(aws cloudwatch describe-alarms --query 'MetricAlarms[*].AlarmName' --output text)
aws sns delete-topic --topic-arn $Topics
aws cloudwatch delete-alarms --alarm-names $Alarm