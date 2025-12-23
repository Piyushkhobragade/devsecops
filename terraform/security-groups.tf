# Application Security Group
resource "aws_security_group" "app" {
  name        = "dev-devsecops-app-sg"
  description = "Security group for DevSecOps application (dev)"
  vpc_id      = aws_vpc.main.id

  # HTTP access (application)
  ingress {
    description = "HTTP from anywhere"
    from_port   = var.application_port
    to_port     = var.application_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # SSH access - INTENTIONALLY OPEN (will be caught by Checkov)
  ingress {
    description = "SSH from anywhere (intentional misconfiguration)"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_ssh_cidr
  }

  # Outbound traffic
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "dev-devsecops-app-sg"
    Project     = "DevSecOps-Pipeline"
    Environment = "dev"
    Owner       = "piyush"
  }
}
