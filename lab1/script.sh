{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": "*",
            "Action": "*",
            "Resource":  "arn:aws:s3:::itstepfirstbucket/*",
            "Condition": {
                "NotIpAddress": {
                    "aws:SourceIp": "50.31.252.0/24"
                },
                "Bool": {
                    "aws:ViaAWSService": "false"
                }
            }
        }
    ]
}

aws s3api create-bucket --bucket itstepfirstbucket --region us-east-1 \
&& aws s3api put-bucket-policy --bucket itstepfirstbucket --policy file://policy.json \
&& aws s3 sync ./ s3://itstepfirstbucket/ \
&& aws s3 website s3://itstepfirstbucket/ --index-document index.html --error-document error.html