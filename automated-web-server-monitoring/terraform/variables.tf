variable "aws_region" {
  type        = string
  description = "Target AWS region for infrastructure deployment"
  default     = "ap-south-1"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance size (free tier eligible)"
  default     = "t2.micro"
}

variable "instance_name" {
  type        = string
  description = "Name tag for the EC2 target instance"
  default     = "devops-web-server"
}

variable "allowed_ssh_cidr" {
  type        = string
  description = "CIDR block allowed to SSH into the instance"
  default     = "0.0.0.0/0"
}

variable "key_pair_name" {
  type        = string
  description = "Name of the AWS Key Pair to create"
  default     = "devops-web-server-key"
}

