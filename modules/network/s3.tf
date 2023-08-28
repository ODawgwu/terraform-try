resource "aws_s3_bucket" "cf_bucket" {
  bucket_prefix = var.bucketname
}

resource "aws_s3_object" "folder_image" {
  bucket = aws_s3_bucket.cf_bucket.id
  key    = "Images/"
}

resource "aws_s3_object" "folder_log" {
  bucket = aws_s3_bucket.cf_bucket.id
  key    = "Logs/"
}

resource "aws_s3_bucket_lifecycle_configuration" "bucket_lifecycle" {
  bucket = aws_s3_bucket.cf_bucket.id

  # rule for image folder objects
  rule {
    id = "image_rule"

    filter {
      prefix = "Images/"
    }

    transition {
      days          = 90
      storage_class = "GLACIER"
    }

    status = "Enabled"
  }

  # rule for log folder objects
  rule {
    id = "log_rule"

    filter {
      prefix = "Logs/"
    }

    expiration {
      days = 90
    }

    status = "Enabled"
  }
}
