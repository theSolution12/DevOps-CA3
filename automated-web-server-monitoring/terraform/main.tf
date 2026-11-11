data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

# SSH Key Pair generation for secure automated deployment
resource "tls_private_key" "deployer" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "deployer" {
  key_name   = var.key_pair_name
  public_key = tls_private_key.deployer.public_key_openssh
}

resource "local_sensitive_file" "private_key" {
  content         = tls_private_key.deployer.private_key_pem
  filename        = "${path.module}/../id_rsa"
  file_permission = "0600"
}

# Security Group: HTTP (80), Nagios Web UI (8080), SSH (22)
resource "aws_security_group" "web" {
  name        = "devops-web-server-sg"
  description = "Security group for DevOps automated web server and monitoring"

  ingress {
    description = "SSH administrative access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
  }

  ingress {
    description = "HTTP traffic for static website"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Nagios Core web UI access"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "devops-web-server-sg"
  }
}

# Provision the single real Ubuntu target server
resource "aws_instance" "web" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.deployer.key_name
  vpc_security_group_ids      = [aws_security_group.web.id]
  associate_public_ip_address = true

  root_block_device {
    volume_size           = 20
    volume_type           = "gp3"
    delete_on_termination = true
  }

  tags = {
    Name = var.instance_name
  }
}

# Automatically generate the Ansible inventory with the provisioned EC2 Public IP
resource "local_file" "ansible_inventory" {
  content         = <<-EOT
    [webservers]
    target-node ansible_host=${aws_instance.web.public_ip} ansible_user=ubuntu ansible_ssh_private_key_file=../id_rsa
  EOT
  filename        = "${path.module}/../ansible/inventory.ini"
  file_permission = "0644"
}

