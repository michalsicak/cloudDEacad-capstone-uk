#s3 encryption
resource "aws_kms_key" "capstone_key" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
  tags = {
      Name = "capstone_key"
  }
}