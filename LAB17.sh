Create an AWS IAM policy for BigQuery:-


{
    "Statement": [
        {
            "Action": [
                "s3:ListBucket"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:s3:::<BUCKET_NAME>"
            ],
            "Sid": "BucketLevelAccess"
        },
        {
            "Action": [
                "s3:GetObject"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:s3:::<BUCKET_NAME>",
                "arn:aws:s3:::<BUCKET_NAME>/*"
            ],
            "Sid": "ObjectLevelGetAccess"
        },
        {
            "Action": [
                "s3:PutObject"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:s3:::<BUCKET_NAME>",
                "arn:aws:s3:::<BUCKET_NAME>/*"
            ],
            "Sid": "ObjectLevelPutAccess"
        }
    ],
    "Version": "2012-10-17"
}




Add a Trust Relationship to the AWS role:-

{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "accounts.google.com"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "accounts.google.com:sub": "00000"
        }
      }
    }
  ]
}




