# Samba

[Samba](https://www.samba.org/) is installed in the image. This guide sets up a standalone SMB share on an Entrypoint device.

> Examples use `corey` as the username. Replace `corey` with your own user everywhere it appears, including the share path and config.

## Requirements

- An administrator account that can use `sudo`.
- A client that supports SMB2 or newer (Windows 10+, macOS, Linux).

## 1. Create the Linux user

Samba authenticates against a real Linux user. If your account was created during Fedora IoT provisioning, skip this step and use that username.

```bash
sudo useradd -m corey
```

The home directory is created under `/var/home/corey`. `/var` is persistent across image updates, so the account and its files survive reboots and upgrades.

## 2. Set the Samba password

Samba keeps its own password database, separate from the Linux password. Set it with `smbpasswd`:

```bash
sudo smbpasswd -a corey
```

Enter and confirm the password when prompted. The password database is stored in `/var/lib/samba/private/`, which persists across image updates.

To change the password later, run the same command again. To remove the user from Samba:

```bash
sudo smbpasswd -x corey
```

> Note: the Samba user must also exist as a Linux user (step 1).

## 3. Create the share directory

Create a directory in the user's home directory to share. This example uses `podman`, but any directory works.

```bash
sudo -u corey mkdir -p /home/corey/podman
```

> Note: `podman` is just an example directory. Use any directory you like.

## 4. Configure `/etc/samba/smb.conf`

Fedora's `samba-common` package ships a default `/etc/samba/smb.conf`. Replace its contents with the following:

```ini
[global]
   workgroup = WORKGROUP
   server string = Entrypoint
   server role = standalone server
   security = user
   map to guest = never

   # Only accept modern SMB protocol versions
   server min protocol = SMB2

   # Disable printing support (not needed on this device)
   load printers = no
   printing = bsd
   printcap name = /dev/null
   disable spoolss = yes

   log file = /var/log/samba/log.%m
   max log size = 50

[podman]
   comment = Podman share
   path = /home/corey/podman
   valid users = corey
   read only = no
   browseable = yes
   create mask = 0660
   directory mask = 0770
```

> Add more `[sharename]` sections for additional shares.

Validate the configuration before starting the service:

```bash
testparm -s
```

`testparm` reports any syntax errors and prints the effective configuration.

## 5. Allow SELinux access to the share

Fedora uses SELinux in enforcing mode. Samba can only serve directories labeled with the `samba_share_t` type. Label the share directory and apply the label:

```bash
sudo semanage fcontext -a -t samba_share_t "/var/home/corey/podman(/.*)?"
sudo restorecon -Rv /var/home/corey/podman
```

Verify the label:

```bash
ls -Zd /home/corey/podman
```

The output should include `samba_share_t`.

## 6. Open the firewall

Fedora uses `firewalld`. The image's `system-setup` hook (`files/system/usr/share/ublue-os/system-setup.hooks.d/10-firewall.sh`) already adds the `samba` service to the public zone. Confirm it:

```bash
sudo firewall-cmd --list-services
```

If `samba` is missing, add it manually:

```bash
sudo firewall-cmd --permanent --add-service=samba
sudo firewall-cmd --reload
```

## 7. Start and enable Samba

```bash
sudo systemctl enable --now smb.service nmb.service
```

- `smb.service` provides file sharing (required).
- `nmb.service` provides NetBIOS name resolution (optional, used by older Windows clients for discovery).

Check the status:

```bash
sudo systemctl status smb.service
```

## 8. Connect from a client

Use the device's hostname or IP address (or its Tailscale name/IP):

- **Windows:** `\\<host>\podman`
- **macOS:** Finder > Go > Connect to Server > `smb://<host>/podman`
- **Linux:** `smb://<host>/podman` in a file manager, or `sudo mount -t cifs //<host>/podman /mnt/podman -o username=corey`

Use the Samba password from step 2 when prompted.

## Troubleshooting

- **Authentication fails:** confirm the user exists in Linux (`id corey`) and in Samba (`sudo pdbedit -L`).
- **Permission denied on files:** check ownership with `ls -la /home/corey/podman` and confirm the SELinux label with `ls -Zd /home/corey/podman`.
- **Logs:** `sudo journalctl -u smb.service` and `/var/log/samba/`.
- **Share not visible from a client:** confirm the firewall rule (`sudo firewall-cmd --list-services`) and that `smb.service` is running.

## Disable

Stop Samba and prevent it from starting at boot:

```bash
sudo systemctl disable --now smb.service nmb.service
```
