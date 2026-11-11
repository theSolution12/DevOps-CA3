# Test Results and Verification Evidence

**Project:** Automated Web Server Configuration and Monitoring System  
**Owner:** Parth Patidar | **Reg. No.:** 12316831 | **Course:** INT333  
**Target Environment:** AWS EC2 `t2.micro` (Ubuntu 24.04 LTS Noble, `ap-south-1`)  
**Instance ID:** `i-0e1df2965b14fbd04`  
**Target Public IP:** `13.200.222.54`  
**Execution Date:** November 11, 2026  

---

## 1. Acceptance Checklist Summary

| Checklist Item | Requirement | Actual Result | Status |
|---|---|---|:---:|
| **Terraform Format** | `terraform fmt -check` passes | Clean exit, code 0 | **PASS** |
| **Terraform Init** | Downloads providers (`aws`, `tls`, `local`) | Successfully initialized backend & lock file | **PASS** |
| **Terraform Validate** | Configuration syntax is valid | `Success! The configuration is valid.` | **PASS** |
| **Terraform Plan** | Plan reviewed before apply | 5 to add, 0 to change, 0 to destroy | **PASS** |
| **Terraform Provision** | Real target server provisioned on AWS | Instance `i-0e1df2965b14fbd04` active in `ap-south-1` | **PASS** |
| **Ansible Inventory** | Inventory parses and resolves host | `target-node` resolves to `13.200.222.54` | **PASS** |
| **Ansible Ping** | Ping module validates SSH connectivity | `target-node \| SUCCESS => {"ping": "pong"}` | **PASS** |
| **Ansible Playbook** | Executes all tasks without errors | `ok=16 changed=12 unreachable=0 failed=0` | **PASS** |
| **Ansible Repeatability** | Second run produces no unexpected drift | Verified idempotent across all core tasks | **PASS** |
| **Puppet Validation** | `puppet parser validate` passes | Clean exit, zero syntax errors | **PASS** |
| **Puppet Enforcement** | First apply installs & starts Nginx | Applied catalog: Nginx package & service running | **PASS** |
| **Puppet Idempotency** | Second apply produces zero resource changes | `Applied catalog in 0.31 seconds` (0 changed) | **PASS** |
| **Nginx Serving** | Serves static site on HTTP port 80 | `HTTP/1.1 200 OK`, Title & styles verified | **PASS** |
| **Nagios Service** | Nagios Core daemon active & valid | Pre-flight check: 0 errors, 0 warnings | **PASS** |
| **Nagios HTTP Check** | Active check polls Nginx on port 80 | `HTTP OK: Status line output matched "HTTP/1.1 200 OK"` | **PASS** |
| **Nagios Dashboard** | Web UI accessible on port 8080 | HTTP 200 OK with authenticated access | **PASS** |
| **Failure Detection** | Stopped Nginx -> Nagios turns CRITICAL | Nagios alert: `CRITICAL - Connection refused` | **PASS** |
| **Recovery Detection** | Started Nginx -> Nagios returns to OK | Nagios alert: `OK - HTTP/1.1 200 OK` | **PASS** |
| **Git Hygiene** | No `.env`, `.tfstate`, or private keys tracked | `.gitignore` verified, clean staged repository | **PASS** |

---

## 2. Terraform Evidence

### 2.1 Format, Init, and Validation
```bash
$ terraform fmt -check
# (clean exit, code 0)

$ terraform init
Initializing the backend...
Initializing provider plugins...
- Installing hashicorp/tls v4.4.2...
- Installing hashicorp/local v2.9.1...
- Installing hashicorp/aws v5.100.0...
Terraform has been successfully initialized!

$ terraform validate
Success! The configuration is valid.
```

### 2.2 Provisioning Execution Output
```text
Plan: 5 to add, 0 to change, 0 to destroy.
- tls_private_key.deployer: Creation complete after 0s
- local_sensitive_file.private_key: Creation complete after 0s
- aws_key_pair.deployer: Creation complete after 2s [id=devops-web-server-key]
- aws_security_group.web: Creation complete after 5s [id=sg-01bec88a0c918376c]
- aws_instance.web: Creation complete [id=i-0e1df2965b14fbd04]

Target Public IP: 13.200.222.54
Target DNS: ec2-13-200-222-54.ap-south-1.compute.amazonaws.com
```

---

## 3. Puppet Configuration & Idempotency Evidence

### 3.1 First Apply (Nginx Package & Service Desired State)
```bash
$ puppet apply /etc/puppet/code/environments/production/manifests/site.pp
Notice: Compiled catalog for ip-172-31-15-128.ap-south-1.compute.internal in environment production
Notice: /Stage[main]/Main/Node[default]/Package[nginx]/ensure: created
Notice: /Stage[main]/Main/Node[default]/Service[nginx]/ensure: running
Notice: Applied catalog in 8.42 seconds
```

### 3.2 Second Apply (Verification of Idempotency)
```bash
$ sudo puppet apply /etc/puppet/code/environments/production/manifests/site.pp
Notice: Compiled catalog for ip-172-31-15-128.ap-south-1.compute.internal in environment production in 0.35 seconds
Notice: Applied catalog in 0.31 seconds
```
*Interpretation: The second run converged with 0 changes and 0 errors, proving complete idempotence.*

---

## 4. Ansible Playbook & Website Deployment Evidence

### 4.1 SSH Connectivity Test
```bash
$ ansible webservers -m ping
target-node | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3.12"
    },
    "changed": false,
    "ping": "pong"
}
```

### 4.2 Playbook Recap
```text
PLAY RECAP *********************************************************************
target-node : ok=16   changed=12   unreachable=0    failed=0    skipped=0    rescued=0
```

### 4.3 Website HTTP Verification (Port 80)
```text
$ python3 query_web.py
Status Code: 200 OK
Headers:
  Server: nginx/1.24.0 (Ubuntu)
  Content-Type: text/html
  Content-Length: 3515
  Last-Modified: Wed, 11 Nov 2026 12:58:18 GMT

Page Title: DevOps Web Server Configuration and Monitoring
System Status: Active & Operational
Owner: Parth Patidar (Reg. No. 12316831)
```

---

## 5. Nagios Core Monitoring Evidence

### 5.1 Configuration Validation (Pre-flight Check)
```text
$ nagios4 -v /etc/nagios4/nagios.cfg
Total Warnings: 0
Total Errors:   0
Things look okay - No serious problems were detected during the pre-flight check
```

### 5.2 Direct HTTP Check Plugin Execution
```bash
$ /usr/lib/nagios/plugins/check_http -H 127.0.0.1 -I 127.0.0.1 -p 80 -u /
HTTP OK: HTTP/1.1 200 OK - 3758 bytes in 0.000 second response time |time=0.000233s;;;0.000000;10.000000 size=3758B;;;0;
```

### 5.3 Web Dashboard Verification (Port 8080)
```text
URL: http://13.200.222.54:8080/nagios4/
HTTP Status: 200 OK
Credentials Required: HTTP Basic Auth (nagiosadmin)
Dashboard Title: Nagios: 13.200.222.54
```

---

## 6. Controlled Failure and Recovery Demonstration Evidence

### 6.1 Step 1: Baseline Healthy State (OK)
```text
[1794402619] SERVICE ALERT: devops-web-server;HTTP Web Server Availability;OK;HARD;2;HTTP OK: Status line output matched "HTTP/1.1 200 OK" - 3758 bytes in 0.000 second response time
```

### 6.2 Step 2: Injected Failure (Stopping Nginx)
Command: `sudo systemctl stop nginx`  
Timestamp: `Wed Nov 11 13:10:38 UTC 2026`

**Immediate Plugin Output:**
```text
connect to address 127.0.0.1 and port 80: Connection refused
HTTP CRITICAL - Unable to open TCP socket
(Exit code: 2 - CRITICAL)
```

**Nagios Core Daemon Log Entry:**
```text
[1794402679] SERVICE ALERT: devops-web-server;HTTP Web Server Availability;CRITICAL;SOFT;1;connect to address 127.0.0.1 and port 80: Connection refused
```
*Nagios `status.dat` Record:*
```text
current_state=2 (CRITICAL)
plugin_output=connect to address 127.0.0.1 and port 80: Connection refused
long_plugin_output=HTTP CRITICAL - Unable to open TCP socket
```

### 6.3 Step 3: Service Recovery (Starting Nginx)
Command: `sudo systemctl start nginx`  
Timestamp: `Wed Nov 11 13:11:52 UTC 2026`

**Nagios Core Daemon Log Entry:**
```text
[1794402739] SERVICE ALERT: devops-web-server;HTTP Web Server Availability;OK;SOFT;2;HTTP OK: Status line output matched "HTTP/1.1 200 OK" - 3758 bytes in 0.000 second response time
```
*Nagios `status.dat` Record:*
```text
current_state=0 (OK)
plugin_output=HTTP OK: Status line output matched "HTTP/1.1 200 OK" - 3758 bytes in 0.000 second response time
```

---

## 7. Safe Cleanup Instructions

To terminate all cloud resources without leaving billable remnants:
```bash
cd automated-web-server-monitoring/terraform
terraform destroy -auto-approve
```
This safely removes:
- AWS EC2 Instance (`i-0e1df2965b14fbd04`)
- Security Group (`devops-web-server-sg`)
- AWS Key Pair (`devops-web-server-key`)
- Local private key file (`id_rsa`)
