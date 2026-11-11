# Gemini Coding Agent Instructions

Build, run, test, debug and document the project. Do not merely generate files. The submitted synopsis is the source of truth; do not change its scope or replace required tools.

## Required responsibilities
- Terraform: provision one real Ubuntu server/target.
- Ansible: deploy static website files and required deployment prerequisites.
- Puppet: manage Nginx package, configuration and service state.
- Nagios Core: perform a real HTTP availability check and show its status in the web UI.
- Nginx: serve the static website.
- Git: version-control project source and evidence.

## First: inspect the environment
Inspect OS/version, RAM/disk, installed Terraform, Ansible, Puppet, Nagios, Git and SSH, available virtualization providers, and whether AWS CLI credentials are configured. Never print credentials or secret environment variables. Inspect the working directory and Git status before modifying anything.

## Infrastructure decision gate
Use one target only:
1. AWS EC2 only if AWS credentials/region are configured and the user explicitly approves potentially billable resource creation.
2. Local VM only if a working virtualization stack and Terraform provider are already installed.
3. If neither is ready, stop and report the blocker. Ask before installing a hypervisor, creating cloud resources, changing billing exposure or changing the architecture.

Terraform must provision/manage a real infrastructure resource. Do not pretend an existing manually-created VM was provisioned by Terraform. Do not use `local_file` as fake infrastructure. Never commit Terraform state or credentials.

## Avoid tool conflicts
- Ansible owns deployment of `website/index.html` and `website/style.css`.
- Puppet owns Nginx package and service state. It may own Nginx configuration only if Ansible does not also manage that file.
- Nagios owns monitoring configuration.
- Terraform owns infrastructure.
Use local `puppet apply` if no Puppet Server/Agent environment exists; do not build a master-agent topology for this small synopsis project.

## Build order
1. Inspect host and select a safe target.
2. Create repo and static website.
3. Provision one target with Terraform.
4. Deploy website with Ansible.
5. Enforce Nginx package/service with Puppet.
6. Install/configure Nagios Core and a real HTTP check.
7. Stop Nginx and verify Nagios detects failure; start it and verify recovery.
8. Document and review Git contents.

## Safety
Ask before paid cloud creation, public ingress changes, firewall changes or destruction. Restrict Nagios UI access; do not expose it publicly without controls. Never commit credentials, private keys, secret tfvars, `.tfstate`, logs containing secrets, or unrelated files. Do not destroy infrastructure automatically. Do not fabricate outputs, screenshots, URLs or monitoring states.

## Time discipline
Target 8 hours. Prioritize an end-to-end working path. If a tool installation is blocked, document the exact blocker and continue only where possible without falsely claiming completion. Do not spend the entire budget trying providers or distributions.

## Definition of done
Terraform really provisions the target; Ansible deploys and is repeatable; Puppet applies and is idempotent on a second run; Nginx serves the page; Nagios shows a real HTTP check as OK; stopping Nginx produces a detected failure; restarting it returns the check to OK; documentation and test evidence are accurate.

## Final handover
Report architecture/target, files created, status per tool, actual commands/results, website and Nagios URLs (no credentials), evidence location, cleanup instructions, limitations, blocked and unverified items. Never describe partial work as complete.
