# Data source for latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# IAM Role for EC2
resource "aws_iam_role" "app" {
  name = "dev-devsecops-app-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name        = "dev-devsecops-app-role"
    Project     = "DevSecOps-Pipeline"
    Environment = "dev"
    Owner       = "piyush"
  }
}

# Attach CloudWatch policy
resource "aws_iam_role_policy_attachment" "cloudwatch" {
  role       = aws_iam_role.app.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

# IAM Instance Profile
resource "aws_iam_instance_profile" "app" {
  name = "dev-devsecops-app-profile"
  role = aws_iam_role.app.name
}

# EC2 Instance
resource "aws_instance" "app" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.app.id]
  iam_instance_profile   = aws_iam_instance_profile.app.name

  # INTENTIONAL VULNERABILITY: Root volume encryption disabled (Checkov will flag)
  root_block_device {
    volume_size = 8
    volume_type = "gp3"
    encrypted   = false
  }

  user_data = base64encode(templatefile("${path.module}/user-data.sh", {
    application_port = var.application_port
  }))

  monitoring = var.enable_detailed_monitoring

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required" # IMDSv2 enforced (GOOD)
    http_put_response_hop_limit = 1
  }

  tags = {
    Name        = "dev-devsecops-app"
    Project     = "DevSecOps-Pipeline"
    Environment = "dev"
    Owner       = "piyush"
  }
}

# Elastic IP
resource "aws_eip" "app" {
  domain   = "vpc"
  instance = aws_instance.app.id

  tags = {
    Name        = "dev-devsecops-app-eip"
    Project     = "DevSecOps-Pipeline"
    Environment = "dev"
    Owner       = "piyush"
  }
}
