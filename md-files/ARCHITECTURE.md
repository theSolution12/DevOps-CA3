# Architecture

```text
Operator / Control Node
       |
       | Terraform init / plan / apply
       v
One Ubuntu Target
       |
       +-- Ansible inventory + playbook
       |      +-- Deploy index.html and style.css
       |
       +-- Puppet manifest
       |      +-- Ensure Nginx package/config/service
       |
       +-- Nginx HTTP server :80
              +-- Serves static website

Nagios Core (same target or an already-available management host)
       +-- HTTP service check
       +-- Optional basic host/service checks
       +-- Web interface

Git repository stores Terraform, Ansible, Puppet, Nagios config,
website, README and test evidence.
```

## Responsibilities
| Component | Owns |
|---|---|
| Terraform | One real infrastructure target |
| Ansible | Static website deployment |
| Puppet | Nginx package, configuration (if not Ansible-owned), service state |
| Nagios Core | HTTP and selected host/service monitoring |
| Nginx | Static HTTP serving |
| Git | Source and documentation version control |

## Workflow
1. Terraform provisions target.
2. Ansible connects over SSH and deploys website.
3. Puppet enforces Nginx desired state.
4. Browser/curl reaches Nginx on HTTP.
5. Nagios periodically checks HTTP and reports status.
6. Stop Nginx: Nagios detects failure. Restart Nginx: check returns to OK.

If Nagios and Nginx share one host, document that host failure also takes down the monitor. This is a classroom lab, not a highly available monitoring architecture.

## Security
Restrict SSH and Nagios UI access. Open only required ports. Never commit credentials, private keys or Terraform state.
