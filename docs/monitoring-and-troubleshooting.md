# Monitoring and Troubleshooting

## Logs

```bash
sudo journalctl -u ssh --since "24 hours ago" --no-pager
sudo tail -n 20 /var/log/nginx/linux-capstone-access.log
sudo tail -n 20 /var/log/nginx/linux-capstone-error.log
sudo journalctl -p warning -n 30 --no-pager
```

SSH log events such as `Accepted publickey`, `Failed password` and `Invalid user` help identify authentication activity. Nginx access logs record requests and status codes; error logs help diagnose server-side problems.

## Resource monitoring

```bash
top
free -h
df -hT
uptime
sudo ss -tulpn
```

## Connectivity troubleshooting

If the website works with `curl http://localhost` but cannot be reached from the public internet, inspect both:
1. UFW inbound TCP/80 rule.
2. Azure NSG inbound TCP/80 rule.

A local HTTP 200 response verifies Nginx locally, not end-to-end public reachability.
