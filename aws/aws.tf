resource "aws_security_group" "ssh_access" {
  name        = "ssh-access"
  description = "Allow SSH access on port 22"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "SSH Security Group"
  }
}

resource "aws_iam_role" "some_aws_role" {
  name               = "some-aws-role"
  assume_role_policy = jsonencode({
    Version : "2012-10-17"
    Statement : [
      {
        Effect : "Allow"
        Principal : {
          Service : "ec2.amazonaws.com"
        }
        Action : "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_instance_profile" "some_aws_role_instance_profile" {
  name = "some-iam-instance-profile"
  role = aws_iam_role.some_aws_role.name
}

resource "aws_instance" "some_aws_instance" {
  ami                    = "ami-012967cc5a8c9f891"
  instance_type          = "t2.micro"
  key_name               = "SOME-EXISTING-AWS-KEYPAIR-NAME" # TODO: generate this...
  iam_instance_profile   = aws_iam_instance_profile.some_aws_role_instance_profile.name
  vpc_security_group_ids = [aws_security_group.ssh_access.id]

  tags = {
    Name = "FEDERATED-EXAMPLE-TF-1"
  }
}
