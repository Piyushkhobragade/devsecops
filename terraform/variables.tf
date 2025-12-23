variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
}

variable "environment" {
  description = "Deployment environment (dev, staging, prod)"
  type        = string
}

variable "application_port" {
  description = "Port on which the application runs"
  type        = number
}

variable "allowed_ssh_cidr" {
  description = "CIDR blocks allowed to SSH into EC2"
  type        = list(string)
}
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "enable_detailed_monitoring" {
  description = "Enable detailed CloudWatch monitoring"
  type        = bool
}
