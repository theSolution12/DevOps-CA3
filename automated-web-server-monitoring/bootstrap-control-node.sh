#!/usr/bin/env bash
# ==============================================================================
# Bootstrap Script for Presentation Control Node (Client EC2 Instance)
# Author: Parth Patidar | Reg. No.: 12316831 | Course: INT333
# Project: Automated Web Server Configuration and Monitoring System
# ==============================================================================
set -euo pipefail

echo "=========================================================="
echo " Setting up DevOps Presentation Control Node Environment"
echo "=========================================================="

# Update system
sudo apt-get update -y
sudo apt-get install -y curl unzip git software-properties-common python3 python3-pip

# Install AWS CLI v2 if not present
if ! command -v aws &> /dev/null; then
    echo "[+] Installing AWS CLI v2..."
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip -q awscliv2.zip
    sudo ./aws/install
    rm -rf aws awscliv2.zip
fi

# Install Terraform if not present
if ! command -v terraform &> /dev/null; then
    echo "[+] Installing HashiCorp Terraform..."
    wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
    sudo apt-get update -y
    sudo apt-get install -y terraform
fi

# Install Ansible
if ! command -v ansible &> /dev/null; then
    echo "[+] Installing Ansible..."
    sudo apt-get install -y ansible
fi

# Install Puppet Agent
if ! command -v puppet &> /dev/null; then
    echo "[+] Installing Puppet..."
    sudo apt-get install -y puppet
fi

echo "=========================================================="
echo " Control Node Bootstrap Complete!"
echo " Terraform: $(terraform version | head -n 1)"
echo " Ansible:   $(ansible --version | head -n 1)"
echo " Puppet:    $(puppet --version)"
echo " AWS CLI:   $(aws --version)"
echo "=========================================================="
echo "Next steps:"
echo "1. Run 'aws configure' with your AWS access credentials"
echo "2. Run 'cd terraform && terraform init && terraform apply'"
echo "3. Run 'cd ../ansible && ansible-playbook playbook.yml'"
echo "=========================================================="

