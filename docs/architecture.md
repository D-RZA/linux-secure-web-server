# Architecture

## Request path

```text
Browser / administrator
        |
        v
Azure Network Security Group
        |
        v
Ubuntu VM network interface
        |
        v
UFW host firewall
        |
        +---- TCP/22 ----> OpenSSH (key-based administration)
        |
        +---- TCP/80 ----> Nginx
                              |
                              v
                    /var/www/linux-capstone
```

Azure NSG and UFW enforce controls at different layers. The NSG filters traffic at the Azure network boundary; UFW filters traffic on the Ubuntu host.

## Captured environment

- Azure VM: `vm-1`
- OS: Ubuntu Server 24.04.5 LTS
- VM size shown in the Azure overview screenshot: Standard F1als v7 (1 vCPU, 2 GiB memory)
- Nginx: 1.24.0
- Web root: `/var/www/linux-capstone`

## Network rules evidenced

| Layer | Direction | Protocol/port | Captured source | Action |
|---|---|---|---|---|
| Azure NSG | Inbound | TCP/22 | `102.90.0.0/16` | Allow |
| Azure NSG | Inbound | TCP/80 | Any | Allow |
| UFW | Inbound | TCP/22 | Anywhere | Allow |
| UFW | Inbound | TCP/80 | Anywhere | Allow |

The source ranges shown are the captured project configuration, not a universal recommendation. Restrict SSH to trusted administrator source addresses. HTTP is public in this deployment.
