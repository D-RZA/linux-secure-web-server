# Secure and Monitored Linux Web Server

A hands-on Linux infrastructure project: deploy and secure an Ubuntu web server on Microsoft Azure, serve a custom website with Nginx, monitor the host, investigate logs, and automate health checks with Bash.

## Project goals

- Manage Linux users, groups, ownership and permissions.
- Configure SSH public-key authentication and hardening.
- Apply host firewall rules with UFW.
- Control cloud-level ingress with an Azure Network Security Group (NSG).
- Deploy a custom static website with Nginx.
- Inspect authentication, system and web-server logs.
- Monitor disk, memory, uptime, processes and listening sockets.
- Run a Bash health-check script.

## Architecture

```text
Client
  |
  | SSH TCP/22 or HTTP TCP/80
  v
Azure Network Security Group
  |
  v
Ubuntu 24.04.5 LTS VM
  |
  +--> UFW host firewall
  |
  +--> OpenSSH (key-based administration)
  |
  +--> Nginx (HTTP)
          |
          +--> /var/www/linux-capstone
```

The Azure NSG and UFW are separate security layers. Both must permit the intended traffic. The captured NSG configuration allows SSH on TCP/22 from a restricted source range and HTTP on TCP/80 from Any. Review and tighten source ranges to suit your deployment.

## Environment

| Component | Captured configuration |
|---|---|
| Cloud | Microsoft Azure |
| VM | `vm-1` |
| OS | Ubuntu Server 24.04.5 LTS |
| Kernel | Linux 7.0.0-1017-azure (at initial inspection) |
| Web server | Nginx 1.24.0 (Ubuntu package) |
| Host firewall | UFW |
| Cloud firewall | Azure NSG |
| SSH key | Ed25519 |
| Automation | Bash |

## Security controls implemented

### Linux identity and permissions
- Created the `webadmin` group and added the `azure` account.
- Set the web root owner/group to `root:webadmin`.
- Applied mode `2775` to the web root, enabling group write access and SetGID group inheritance.
- Set the health-check script to `root:webadmin` with mode `750`.

### SSH
- Generated an Ed25519 key pair on the Windows client.
- Installed the public key in the VM user's `~/.ssh/authorized_keys`.
- Verified a fresh public-key SSH login.
- Effective SSH settings captured:
  - `PermitRootLogin no`
  - `PubkeyAuthentication yes`
  - `PasswordAuthentication no`
  - `KbdInteractiveAuthentication no`
  - `AllowTcpForwarding no`

### UFW
- Default incoming policy: deny.
- Default outgoing policy: allow.
- Allowed inbound TCP/22 (SSH) and TCP/80 (HTTP).
- Enabled low-level logging.

### Azure NSG
- Inbound SSH: TCP/22, source restricted to `102.90.0.0/16` in the captured configuration.
- Inbound HTTP: TCP/80, source Any in the captured configuration.

## Nginx deployment

The website document root is `/var/www/linux-capstone`. A dedicated Nginx site configuration serves `index.html` and writes site-specific logs to:

- `/var/log/nginx/linux-capstone-access.log`
- `/var/log/nginx/linux-capstone-error.log`

The captured validation includes:
- Nginx service active.
- Local HTTP request returning `HTTP/1.1 200 OK`.
- Privileged `sudo nginx -t` reporting syntax OK and test successful.
- The custom page loaded in a browser through the VM public IP.

## Monitoring and investigation

Commands used during the project include:

- `journalctl -u ssh` for SSH service events.
- `tail` for Nginx access and error logs.
- `top` for process and CPU activity.
- `free -h` for memory.
- `df -hT` for filesystem capacity.
- `uptime` for load and uptime.
- `ss -tulpn` for listening sockets.

## Bash health check

`scripts/health-check.sh` checks:
1. Nginx service state.
2. Local HTTP response code.
3. Root filesystem usage against an 80% threshold.
4. Memory usage against a 90% threshold.
5. System uptime.

It exits with status `0` when no critical check fails and `1` when a critical check fails. Disk and memory threshold breaches are warnings in this version.

Run it with:

```bash
bash scripts/health-check.sh
```

## Evidence

The `screenshots/` directory contains implementation evidence. See [`docs/evidence-index.md`](docs/evidence-index.md) for descriptions.

## Limitations and next improvements

- The website is served over HTTP; HTTPS/TLS was not implemented in this capstone.
- The Bash script is run on demand; scheduling with a systemd timer or cron is a possible extension.
- Monitoring is local and lightweight; centralized metrics and alerting are possible extensions.
- SSH source restrictions should be kept aligned with the administrator's current public IP and access requirements.
- Review screenshots for sensitive identifiers before making the repository public.

## Skills demonstrated

Linux administration · users and permissions · SSH hardening · UFW · Azure NSG · Nginx · systemd · log investigation · resource monitoring · Bash scripting · troubleshooting · Git

## Project status

Implementation and evidence capture completed — November 2026.
