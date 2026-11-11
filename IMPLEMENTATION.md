# Implementation Guide

## Suggested repository tree

```text
automated-web-server-monitoring/
├── README.md
├── .gitignore
├── terraform/
│   ├── versions.tf
│   ├── provider.tf
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
├── ansible/
│   ├── inventory.ini.example
│   ├── playbook.yml
│   └── group_vars/webservers.yml
├── puppet/manifests/site.pp
├── nagios/README.md
├── nagios/configs/web-server.cfg.example
├── website/index.html
├── website/style.css
└── evidence/test-results.md
```

Create only files actually used.

## Terraform
- Pin compatible Terraform/provider versions.
- Provision one Ubuntu target only.
- Use AWS EC2 only with configured credentials and explicit approval for cost.
- Use a local provider only if virtualization/provider is already operational.
- Do not claim Terraform provisioned a manually-created existing VM.
- Use variables; do not hard-code secrets.
- Run `fmt`, `init`, `validate`, `plan`; apply only after plan review and approval where needed.
- Document safe cleanup; do not auto-destroy.

## Website
Create responsive static HTML/CSS titled **DevOps Web Server Configuration and Monitoring**. Include project purpose, toolchain and a simple Nginx-served status message. No backend, database or external JS dependencies.

## Ansible
- Create inventory for the actual target and SSH user.
- Use an idempotent playbook.
- Install deployment prerequisites if needed.
- Copy website files into the Nginx document root.
- Use variables for paths/target-specific values.
- Include useful tags, e.g. `deploy` and `web`.
- Include a handler only when a managed configuration change requires service reload/restart.
- Run syntax check and playbook; verify with curl.

## Puppet
- Create manifest with Nginx package and service resources.
- Ensure package installed, service enabled and running.
- Manage Nginx config only if Ansible does not manage the same file.
- Prefer local `puppet apply` if no Puppet server exists.
- Apply twice and record idempotence.
- Verify website still works after apply.

## Nagios Core
- Install using a supported method for detected Ubuntu release.
- Verify Nagios Core and Nagios Plugins.
- Configure host and HTTP service check for actual website.
- Validate Nagios configuration before restart/reload.
- Confirm dashboard reports actual HTTP state.
- Resource checks are stretch goals; HTTP check is mandatory.
- Restrict web interface access.

## Git
- Add `.gitignore` for `.terraform/`, `*.tfstate*`, secret tfvars, keys and logs.
- Inspect `git status` and staged files before committing.
- Do not copy third-party code without checking its license.
