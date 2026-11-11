# Automated Web Server Configuration and Monitoring System

**Author:** Parth Patidar | **Reg. No.:** 12316831 | **Course:** INT333  
**Project:** Automated Web Server Configuration and Monitoring System Using Terraform, Puppet, Ansible and Nagios Core

---

## 1. Project Overview & Architecture
This project demonstrates an end-to-end automated DevOps infrastructure and delivery pipeline.

```text
Operator / Presentation Client (Control Node)
       |
       | Terraform (Infrastructure as Code)
       v
One Ubuntu Target Server (AWS EC2 t2.micro, ap-south-1)
       |
       +-- Puppet Manifest (Enforces Nginx package, config, service running)
       |
       +-- Ansible Playbook (Deploys responsive static website artifacts)
       |
       +-- Nginx Web Server (Port 80: serves static website)
       |
       +-- Nagios Core (Port 8080: polls HTTP availability and alerts on failure)
```

### Strict Separation of Tool Responsibilities
| Tool | Dedicated Responsibility |
|---|---|
| **Terraform** | Provisions AWS EC2 instance, security group rules (22, 80, 8080), and key pair. |
| **Puppet** | Desired state configuration: ensures Nginx package installation and active service state. |
| **Ansible** | Orchestrates deployment prerequisites, static website files (`index.html`, `style.css`). |
| **Nagios Core** | Performs active polling on HTTP port 80; web dashboard accessible on port 8080. |
| **Git** | Tracks source code, playbooks, manifests, and verification logs without committing secrets. |

---

## 2. Directory Structure
```text
automated-web-server-monitoring/
├── README.md
├── bootstrap-control-node.sh
├── terraform/
│   ├── versions.tf
│   ├── provider.tf
│   ├── variables.tf
│   ├── main.tf
│   └── outputs.tf
├── ansible/
│   ├── ansible.cfg
│   ├── inventory.ini.example
│   ├── playbook.yml
│   └── group_vars/webservers.yml
├── puppet/
│   └── manifests/site.pp
├── nagios/
│   ├── README.md
│   └── configs/web-server.cfg
└── website/
    ├── index.html
    └── style.css
```

---

## 3. Quick Start & Execution Guide

### Step 1: Provision Infrastructure with Terraform
```bash
cd terraform
terraform init
terraform plan
terraform apply
```

### Step 2: Deploy Configuration and Website with Ansible
```bash
cd ../ansible
ansible-playbook playbook.yml
```

### Step 3: Access Live Services
- **Website**: `http://<TARGET_PUBLIC_IP>/`
- **Nagios Web UI**: `http://<TARGET_PUBLIC_IP>:8080/nagios/` (User: `nagiosadmin`, Password: `DevopsAdmin2026!`)

---

## 4. Controlled Failure and Recovery Testing
To demonstrate active monitoring:
1. Stop Nginx:
   ```bash
   ssh -i id_rsa ubuntu@<TARGET_PUBLIC_IP> "sudo systemctl stop nginx"
   ```
   *Nagios HTTP check transitions from OK to CRITICAL.*
2. Recover Nginx:
   ```bash
   ssh -i id_rsa ubuntu@<TARGET_PUBLIC_IP> "sudo systemctl start nginx"
   ```
   *Nagios HTTP check recovers from CRITICAL back to OK.*

