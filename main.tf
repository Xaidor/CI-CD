# Security Group for Jenkins Server
resource "aws_security_group" "jenkins-sg" {
  name = "jenkins-sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# IAM Role for Jenkins EC2 Instance
resource "aws_iam_role" "jenkins_role" {
  name = "jenkins-role"

  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "ec2.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  })
}

# IAM Policy for S3 Read/Write Access with ACL Modification Permission
resource "aws_iam_policy" "s3_read_write_acl_policy" {
  name = "s3_read_write_acl_policy"

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket",
          "s3:PutBucketAcl"  
        ],
        "Resource": [
          "arn:aws:s3:::jenkins-artifacts-bucket",
          "arn:aws:s3:::jenkins-artifacts-bucket/*"
        ]
      }
    ]
  })
}

# Attach IAM Policy to Role
resource "aws_iam_role_policy_attachment" "attach_s3_policy" {
  role       = aws_iam_role.jenkins_role.name
  policy_arn = aws_iam_policy.s3_read_write_acl_policy.arn
}

# IAM Instance Profile for attaching role to EC2 instance
resource "aws_iam_instance_profile" "jenkins_instance_profile" {
  name = "jenkins-instance-profile"
  role = aws_iam_role.jenkins_role.name
}

# EC2 Instance for Jenkins Server
resource "aws_instance" "jenkins-instance" {
  ami                    = var.ubuntu-ami
  instance_type          = "t2.micro"
  key_name               = var.keyname
  vpc_security_group_ids = [aws_security_group.jenkins-sg.id]
  user_data              = "${file("jenkins-install.sh")}"

  # Attach the IAM Instance Profile to allow S3 access
  iam_instance_profile = aws_iam_instance_profile.jenkins_instance_profile.name

  tags = {
    Name = "Jenkins Server"
  }
}

# S3 Bucket 
resource "aws_s3_bucket" "jenkins_artifacts_bucket" {
  bucket = "jenkins-artifacts-bucket"
}

# S3 Bucket ACL resource for setting the ACL 
resource "aws_s3_bucket_acl" "jenkins_bucket_acl" {
  bucket = aws_s3_bucket.jenkins_artifacts_bucket.id
  acl    = "private"
}

# Output for Jenkins IP Address
output "jenkins_ip_address" {
  value = aws_instance.jenkins-instance.public_dns
}

