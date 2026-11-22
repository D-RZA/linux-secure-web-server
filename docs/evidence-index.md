# Linux Secure Web Server — Evidence Index

This archive contains 10 implementation-evidence screenshots.

1. `01-linux-users-and-permissions.png` — `azure` membership in `webadmin`;
   web root ownership `root:webadmin` and SetGID permission.
2. `02-ssh-key-authentication.png` — fresh Windows PowerShell SSH connection
   using the Ed25519 private key.
3. `03-ssh-hardening-and-authentication-logs.png` — effective SSH hardening
   settings, active SSH service and successful public-key authentication log.
4. `04-ufw-firewall-status.png` — UFW active; default deny incoming, allow
   outgoing; SSH and HTTP allowed.
5. `05-azure-nsg-inbound-rules.png` — Azure NSG inbound rules for SSH TCP 22
   and HTTP TCP 80.
6. `06-nginx-service-and-http-response.png` — Nginx active and local HTTP 200.
7. `07-nginx-configuration-validation.png` — privileged `sudo nginx -t`
   reports syntax OK and configuration test successful.
8. `08-azure-vm-overview.png` — Azure VM running, Ubuntu 24.04, VM size,
   region and network context. This screenshot contains a subscription ID
   and public IP; redact these before public publication if desired.
9. `09-live-website.png` — custom Linux Capstone webpage in a browser.
10. `10-bash-health-check.png` — Bash health-check PASS results for Nginx,
    HTTP, disk, memory and uptime.

Before publishing, review screenshots for IP addresses, subscription identifiers,
usernames or other information you do not want public. Never publish private keys,
passwords, tokens or credentials.
