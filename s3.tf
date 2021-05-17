resource "aws_s3_bucket" "s3_bucket" {
  bucket = "${local.name}-s3-bucket-${random_id.prefix.hex}"
  acl    = "private"

  tags = {
    Name = "${local.name}-s3-bucket-${random_id.prefix.hex}"
  }
}

resource "aws_s3_bucket_policy" "s3_policy" {
  bucket = aws_s3_bucket.s3_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "${local.name}-s3-public"
    Statement = [
      {
        Sid       = "PublicRead"
        Effect    = "Allow"
        Principal = "*"
        Action = [
          "s3:GetObject",
          "s3:GetObjectVersion"
        ],
        Resource = [
          aws_s3_bucket.s3_bucket.arn,
          "${aws_s3_bucket.s3_bucket.arn}/*",
        ]
      },
    ]
  })
}
