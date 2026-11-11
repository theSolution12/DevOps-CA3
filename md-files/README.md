# Gemini Build Specification

**Project:** Automated Web Server Configuration and Monitoring System Using Terraform, Puppet, Ansible and Nagios Core  
**Owner:** Parth Patidar | **Reg. No.:** 12316831 | **Course:** INT333  
**Target effort:** approximately 8 hours

This specification is based on the submitted four-page synopsis. Read `AGENT_INSTRUCTIONS.md` first.

## Exact scope
- One Ubuntu server/target environment.
- Terraform provisions the minimal server infrastructure.
- Ansible deploys a static HTML/CSS website.
- Puppet manages the Nginx package, configuration and service state.
- Nagios Core monitors HTTP availability and selected host/service checks.
- Nginx serves the site; Git tracks source and evidence.
- Demonstrate Nginx failure detection and recovery.

## Explicit exclusions
No database, custom backend, load balancer, multi-server cluster, Kubernetes, Docker orchestration, CI/CD, Prometheus or Grafana.

## Deliverables
Terraform configuration; Ansible inventory/playbook; Puppet manifest; Nagios configuration; static website; README; `evidence/test-results.md`; honest completion/blocker report.
