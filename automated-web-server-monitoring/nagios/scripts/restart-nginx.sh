#!/bin/bash
# ==============================================================================
# Nagios Event Handler: Automated Puppet Desired-State Enforcement & Self-Healing
# Parameters passed by Nagios:
#   $1 = SERVICESTATE (OK, WARNING, UNKNOWN, CRITICAL)
#   $2 = SERVICESTATETYPE (SOFT, HARD)
#   $3 = SERVICEATTEMPT (1, 2, 3...)
# ==============================================================================

STATE="$1"
STATETYPE="$2"
ATTEMPT="$3"
PUPPET_MANIFEST="/etc/puppet/code/environments/production/manifests/site.pp"

logger -t nagios-event-handler "Nagios Event: HTTP State=$STATE, Type=$STATETYPE, Attempt=$ATTEMPT"

case "$STATE" in
CRITICAL|WARNING)
    logger -t nagios-event-handler "Outage detected ($STATE/$STATETYPE). Waiting 10s before healing..."
    sleep 10

    # Enforce state via Puppet
    PUPPET_BIN="$(command -v puppet 2>/dev/null || echo '/usr/bin/puppet')"
    OUTPUT=$(sudo "$PUPPET_BIN" apply "$PUPPET_MANIFEST" 2>&1)
    logger -t nagios-event-handler "Puppet remediation output: $OUTPUT"

    # Ensure Nginx is running as safety fallback
    sudo /usr/bin/systemctl start nginx
    logger -t nagios-event-handler "Self-healing completed. Nginx running."
    ;;
OK)
    logger -t nagios-event-handler "Service is healthy (OK)."
    ;;
esac

exit 0
