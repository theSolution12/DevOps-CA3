# Nagios Core Monitoring Guide

## Overview
Nagios Core is deployed to continuously monitor the health and HTTP availability of the Nginx web server.

## Architecture & Conflict Avoidance
- **Nginx HTTP Web Server**: Binds to standard HTTP port **80**.
- **Nagios Core Web UI (Apache)**: Configured to listen on port **8080**, avoiding any port collision or tool conflict with Nginx.
- **Service Monitored**: Active HTTP poll checking `GET /` on port 80 expecting `HTTP/1.1 200 OK`.

## Configuration Files
- `nagios/configs/web-server.cfg`: Contains definitions for the `devops-web-server` host and the `HTTP Web Server Availability` service check.

## Verification & Testing
1. **Normal Status**:
   - Web UI accessible at `http://<TARGET_IP>:8080/nagios/`
   - User: `nagiosadmin`
   - Service status: **OK**
2. **Failure Injection**:
   - `sudo systemctl stop nginx` on target.
   - Wait 60 seconds (or force check in UI).
   - Service status transitions to: **CRITICAL**.
3. **Recovery**:
   - `sudo systemctl start nginx` on target.
   - Wait 60 seconds (or force check in UI).
   - Service status returns to: **OK**.

