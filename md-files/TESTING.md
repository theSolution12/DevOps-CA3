# Testing and Acceptance Checklist

Record actual results in `evidence/test-results.md`. Mark each PASS, FAIL, BLOCKED or NOT RUN. Include command, output, timestamp and interpretation. Never invent results.

## Terraform
- [ ] `terraform fmt -check` passes.
- [ ] `terraform init` completes.
- [ ] `terraform validate` passes.
- [ ] Plan reviewed.
- [ ] One real infrastructure target provisioned, or blocker documented.
- [ ] Output/address recorded without secrets.
- [ ] Cleanup instructions documented; no automatic destroy.

## Ansible and website
- [ ] Inventory parses.
- [ ] Playbook syntax check passes.
- [ ] Playbook runs successfully.
- [ ] Second run is repeatable/idempotent.
- [ ] Nginx serves intended page.
- [ ] `curl -I http://TARGET/` returns successful HTTP status.
- [ ] Expected project heading appears in page content.

## Puppet
- [ ] Manifest syntax validates.
- [ ] First `puppet apply` succeeds.
- [ ] Nginx package installed.
- [ ] Nginx enabled and active.
- [ ] Second apply demonstrates idempotence or explains remaining changes.
- [ ] Website works after Puppet apply.
- [ ] No conflict with Ansible-managed website files.

## Nagios Core
- [ ] Nagios installed and service running.
- [ ] Configuration validates.
- [ ] HTTP plugin exists and is executable.
- [ ] Host/service check targets actual website.
- [ ] Dashboard shows actual HTTP service as OK.
- [ ] UI access appropriately restricted.

## Failure and recovery
- [ ] Record initial Nginx and Nagios state.
- [ ] Stop Nginx on the project target.
- [ ] Wait for Nagios check.
- [ ] Confirm HTTP check changes to CRITICAL/expected failure state.
- [ ] Record evidence and timestamp.
- [ ] Start Nginx.
- [ ] Wait for next check.
- [ ] Confirm HTTP returns to OK.
- [ ] Record evidence and timestamp.

If check scheduling or permissions prevent observation, document it; do not mark PASS.

## Git and documentation
- [ ] README explains architecture, prerequisites, setup and commands.
- [ ] Test results recorded.
- [ ] Limitations documented.
- [ ] No credentials, private keys or Terraform state committed.
- [ ] Git status reviewed.

## Final acceptance
The end-to-end deployment and HTTP monitoring must work, and failure/recovery must be observed. If Terraform provisioning is blocked, disclose it clearly rather than claiming full completion.
