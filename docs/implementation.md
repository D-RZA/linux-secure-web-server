# Implementation Notes

## 1. Inspect the VM

The baseline inspection used `hostnamectl`, `/etc/os-release`, `uname`, `id`, `uptime`, `free`, `df` and `ss`.

## 2. Create the web administration group

```bash
sudo groupadd webadmin
sudo usermod -aG webadmin azure
```

A new login session (or `newgrp webadmin`) is needed for the current shell to use the new supplementary group membership.

## 3. Prepare the web root

```bash
sudo mkdir -p /var/www/linux-capstone
sudo chown root:webadmin /var/www/linux-capstone
sudo chmod 2775 /var/www/linux-capstone
```

## 4. Configure SSH key authentication

Generate an Ed25519 key pair on the client, install only the `.pub` key in `~/.ssh/authorized_keys`, then test a new SSH session before disabling password authentication.

## 5. Configure UFW

Allow SSH before enabling UFW. Then set default incoming deny, outgoing allow, enable logging, allow SSH, and allow HTTP.

## 6. Install and configure Nginx

Install Nginx, create the site root and HTML file, create a server block, enable the site, test with `sudo nginx -t`, and reload Nginx.

## 7. Validate

Use `curl -I http://localhost` to confirm an HTTP response. External access also requires the Azure NSG to allow TCP/80.
