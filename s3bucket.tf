resource "aws_s3_bucket" "prudhvirajdevbucket" {
  bucket = "prudhvirajdevbucket"
  acl    = "public"

  tags = {
    Name        = "prudhvirajdevbucket"
    Environment = "Dev"
  }
}


resource "aws_s3_bucket" "prudhvirajdevbucket" {
  bucket = "s3-prudhvirajdevbucket"
  acl    = "public-read"
  policy = file("policy.json")

  website {
    index_document = "index.html"
    error_document = "error.html"

    routing_rules = <<EOF
[{
    "Condition": {
        "KeyPrefixEquals": "docs/"
    },
    "Redirect": {
        "ReplaceKeyPrefixWith": "documents/"
    }
}]
EOF
  }
}

resource "aws_s3_bucket" "prudhvirajdevbucket" {
  bucket = "my-tf-test-bucket"
}

resource "aws_s3_bucket_policy" "prudhvirajdevbucket" {
  bucket = aws_s3_bucket.prudhvirajdevbucket.id


  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "MYBUCKETPOLICY"
    Statement = [
      {
        Sid       = "IPAllow"
        Effect    = "Deny"
        Principal = "*"
        Action    = "s3:*"
        Resource = [
          aws_s3_bucket.b.arn,
          "${aws_s3_bucket.prudhvirajdevbucket.arn}/*",
        ]
        Condition = {
          IpAddress = {
            "aws:SourceIp" = "10.10.0.0/16"
          }
        }
      },
    ]
  })
}