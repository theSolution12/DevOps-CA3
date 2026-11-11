# Project Plan

## Objective
Implement the submitted Automated Web Server Configuration and Monitoring System using Terraform, Puppet, Ansible and Nagios Core on one Ubuntu server/target.

## Requirements
1. Terraform provisions one real target.
2. Ansible installs deployment prerequisites and deploys static HTML/CSS files.
3. Puppet ensures Nginx package/configuration/service desired state.
4. Nagios Core monitors website HTTP availability and selected host/service health.
5. Nagios web interface displays actual service status.
6. Controlled Nginx stop/start test demonstrates failure detection and recovery.
7. Git stores code and documentation without secrets.

## Scope exclusions
No database, backend, load balancer, multi-server cluster, container orchestration, CI/CD, Prometheus or Grafana.

## Eight-hour work breakdown

| Phase | Task | Target |
|---|---|---:|
| 0 | Inspect OS/tools/credentials/providers and choose target | 30 min |
| 1 | Create repository and static website | 30 min |
| 2 | Terraform configuration and provisioning | 60 min |
| 3 | Ansible inventory/playbook and deployment | 75 min |
| 4 | Puppet manifest and idempotence check | 45 min |
| 5 | Nagios Core installation and HTTP check | 100 min |
| 6 | Failure/recovery test | 35 min |
| 7 | Documentation, evidence and Git hygiene | 45 min |

Time targets are not permission to bypass safety or fake completion.

## Milestones
- M1: One target selected and provisioned.
- M2: Nginx serves static website.
- M3: Ansible deployment is repeatable.
- M4: Puppet enforces Nginx state.
- M5: Nagios HTTP check visible and operational.
- M6: Failure and recovery demonstrated.
- M7: Documentation and evidence complete.

## Risks
- No AWS credentials: check for an already-working local Terraform provider; otherwise report blocker.
- Cloud cost: require approval before EC2 creation.
- Puppet/Ansible conflict: assign website content to Ansible, Nginx package/service to Puppet.
- Nagios setup delays: use a supported method for detected Ubuntu release; prioritize real HTTP check.
- Nagios on same host: document that it cannot independently report total failure of its own host.
- Restrict Nagios UI access.

## Completion
Use `TESTING.md`. Every criterion must be marked PASS, FAIL, BLOCKED or NOT RUN with evidence.
