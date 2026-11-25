#!/bin/bash
# ==============================================================================
# Nagios Event Handler: Automated Nginx Self-Healing
# Parameters passed by Nagios:
#   $1 = SERVICESTATE (OK, WARNING, UNKNOWN, CRITICAL)
#   $2 = SERVICESTATETYPE (SOFT, HARD)
#   $3 = SERVICEATTEMPT (1, 2, 3...)
# ==============================================================================

STATE="$1"
STATETYPE="$2"
ATTEMPT="$3"

logger -t nagios-event-handler "Nagios Event: HTTP State=$STATE, Type=$STATETYPE, Attempt=$ATTEMPT"

case "$STATE" in
CRITICAL|WARNING)
    logger -t nagios-event-handler "Outage detected ($STATE/$STATETYPE). Triggering automated self-healing restart..."
    sudo /usr/bin/systemctl start nginx
    ;;
OK)
    logger -t nagios-event-handler "Service is healthy (OK)."
    ;;
esac

exit 0
