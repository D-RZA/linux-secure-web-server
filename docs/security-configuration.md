# Security Configuration

## Linux users and groups

A `webadmin` group was created and the `azure` account was added as a supplementary member.

The web root was configured with:
- Owner/group: `root:webadmin`
- Mode: `2775`
- SetGID: enabled, so new content inherits the directory's group.

The health-check script was configured as:
- Owner/group: `root:webadmin`
- Mode: `750`

## SSH hardening

An Ed25519 key pair was generated on the Windows administration client. The public key was installed in the VM account's `~/.ssh/authorized_keys`; the private key remained on the client.

Effective SSH settings verified with `sshd -T`:

```text
permitrootlogin no
pubkeyauthentication yes
passwordauthentication no
kbdinteractiveauthentication no
allowtcpforwarding no
```

The configuration was syntax-checked with `sshd -t`, the SSH service remained active, and a new key-authenticated connection was tested.

## UFW

Captured policy:
- Default incoming: deny
- Default outgoing: allow
- TCP/22: allow
- TCP/80: allow
- Logging: low

## Azure NSG

The captured inbound rules permit TCP/22 from `102.90.0.0/16` and TCP/80 from Any. Review these rules before reproducing the deployment; least-privilege source restrictions are preferred for administration.
