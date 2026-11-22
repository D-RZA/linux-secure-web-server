# Command Reference

| Command | Purpose |
|---|---|
| `id` / `groups` | Inspect user and group membership |
| `getent group webadmin` | Inspect group record |
| `chown` | Change file ownership |
| `chmod` | Change permissions |
| `newgrp webadmin` | Start a shell with the selected group active |
| `sshd -t` | Validate SSH daemon configuration syntax |
| `sshd -T` | Display effective SSH configuration |
| `systemctl status` | Inspect service state |
| `ufw status verbose` | Inspect firewall policy |
| `nginx -t` | Validate Nginx configuration (run with `sudo`) |
| `curl -I` | Inspect HTTP response headers |
| `journalctl` | Query systemd journal |
| `top` | Inspect processes and CPU activity |
| `free -h` | Inspect memory |
| `df -hT` | Inspect filesystem capacity |
| `ss -tulpn` | Inspect listening sockets |
