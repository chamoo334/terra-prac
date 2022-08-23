# # Module =====================================
# terraform {
#   required_version = ">=1.2.6"
# }
# # ==============================================

# S3 Bucket =====================================
resource "aws_s3_bucket" "practice-bucket-ex" {
  bucket = var.s3-bucket-name
  force_destroy = true

  tags = {
    Name        = "${var.s3-bucket-name}"
  }
}
# aws s3 rm s3://practice-bucket-ex --recursive

resource "aws_s3_bucket_acl" "practice-bucket-ex" {
  bucket = aws_s3_bucket.practice-bucket-ex.id
  acl = "public-read"
}
# ================================================


# Data =====================================
/* Use default vpc */
data "aws_vpc" "default" {
  default = true
}
# ==============================================