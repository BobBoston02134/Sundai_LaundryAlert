resource "aws_s3_bucket" "laundry_alert" {
  bucket = "sundai-laundry-alert-${var.region}"
}

resource "aws_s3_bucket_public_access_block" "laundry_alert" {
  bucket = aws_s3_bucket.laundry_alert.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "laundry_alert" {
  bucket     = aws_s3_bucket.laundry_alert.id
  depends_on = [aws_s3_bucket_public_access_block.laundry_alert]

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.laundry_alert.arn}/*"
      },
      {
        Sid       = "PublicPutObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:PutObject"
        Resource  = "${aws_s3_bucket.laundry_alert.arn}/*"
      }
    ]
  })
}

resource "aws_s3_bucket_versioning" "laundry_alert" {
  bucket = aws_s3_bucket.laundry_alert.id

  versioning_configuration {
    status = "Disabled"
  }
}

output "s3_bucket_name" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.laundry_alert.id
}

output "s3_bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = aws_s3_bucket.laundry_alert.arn
}
