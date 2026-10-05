# Glances

[Glances](https://nicolargo.github.io/glances/) is installed and runs in web server mode by default via `glances-web.service`.

The UI is available at `http://<host>:61208`.

> Note: it listens on all interfaces with no authentication by default. Restrict access with a firewall or Tailscale, and/or [enable password auth](#enable-password-authentication).

## Enable password authentication

1. Set and save a password as root (the service runs as root). Run Glances once interactively:

   ```bash
   sudo systemctl stop glances-web.service
   sudo glances -w --password
   ```

   Enter and confirm the password, answer `Yes` when asked to save it, then press `Ctrl+C`.
   The hashed password is stored in `/root/.config/glances/` (persisted under `/var/roothome`, so it survives image updates).

2. Add a systemd drop-in so the service always uses the password:

   ```bash
   sudo systemctl edit glances-web.service
   ```

   Add the following and save:

   ```ini
   [Service]
   ExecStart=
   ExecStart=/usr/bin/glances -w --password
   ```

3. Restart the service:

   ```bash
   sudo systemctl restart glances-web.service
   ```

The web UI will now prompt for credentials. The username is `glances` (the default; use `--username` when setting the password to change it, and add the same flag to `ExecStart`).

To change the password, repeat step 1. To remove password auth:

```bash
sudo systemctl revert glances-web.service
sudo systemctl restart glances-web.service
```

## Disable

Stop it and prevent it from starting at boot:

```bash
sudo systemctl disable --now glances-web.service
```

Re-enable:

```bash
sudo systemctl enable --now glances-web.service
```
