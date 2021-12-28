resource "aws_s3_bucket" "s3-my-bucket" {
  bucket = "s3-my-bucket"
  acl    = "private"

  tags = {
    Name        = "s3-my-bucket"
    Environment = "shared"
  }
}