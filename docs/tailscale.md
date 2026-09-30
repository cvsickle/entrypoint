# Tailscale

Tailscale is installed in the image. Its system service, `tailscaled`, is enabled at boot. The service runs as root because routing requires system network privileges; the `--operator` option lets your regular user manage it.

## First Boot

Create an administrator account from the root console if your installation did not create one already. Replace `corey` with your chosen username:

```bash
useradd --create-home --groups wheel --shell /bin/bash corey
passwd corey
```

Log in as that user. The image defaults the hostname to `entrypoint` and the timezone to `America/New_York`. Override either value if needed:

```bash
sudo hostnamectl set-hostname entrypoint
sudo timedatectl set-timezone America/New_York
```

The image enables IPv4 and IPv6 forwarding at boot for subnet routing and exit-node use.

## Connect and Advertise Routes

Find the LAN subnet connected to the device (for example, `192.168.1.0/24`) and replace the example route below. Run this as your regular user; `sudo` starts the initial connection and `--operator` grants that user permission to manage Tailscale afterward:

```bash
sudo tailscale up \
 --operator="$USER" \
 --advertise-routes=192.168.1.0/24 \
 --advertise-exit-node
```

Open the login URL printed by the command and authenticate to your tailnet. The route and exit-node settings are saved by Tailscale and restored when `tailscaled` starts after a reboot.

## Approve in Tailscale

In the [Tailscale admin console](https://login.tailscale.com/admin/machines), open this device's route settings. Approve the advertised LAN subnet and enable **Use as exit node**. These are separate features: the subnet route provides access to devices on your LAN, while the exit node routes internet traffic through your home connection. Your tailnet access policy must also permit the intended traffic.

Linux clients that should use the advertised LAN route must accept routes:

```bash
sudo tailscale set --accept-routes
```

Select this device as the exit node in the Tailscale client on any device whose internet traffic should go through home.

## Check Status

As the configured operator, check the connection without `sudo`:

```bash
tailscale status
systemctl is-enabled tailscaled
```

`tailscaled` is enabled in the image, so no separate service setup is needed after reboot.

## Disconnect

```bash
tailscale down
```
