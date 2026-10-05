# Installing Entrypoint

Entrypoint is a bootc image. Install Fedora IoT for your device first, then switch to the Entrypoint image.

## Raspberry Pi

1. Download the Fedora IoT aarch64 raw image (`.raw.xz`) from [fedoraproject.org/iot/download](https://fedoraproject.org/iot/download/).
2. Flash the image to an SD card. Here are a couple options:
  a. Use [Raspberry Pi Imager](https://www.raspberrypi.com/software/). Select **Choose OS > Use Custom**, and select the downloaded raw image.
  b. Use [arm-image-installer](https://github.com/fedora-arm/arm-image-installer/), which is my preferred method. See [this guide](https://www.redhat.com/en/blog/fedora-iot-raspberry-pi).
3. Insert the flashed SD card into the Raspberry Pi and boot.
4. Configure Fedora IoT's first-boot provisioning to set up network access and an administrator account that can use `sudo`. See the [Fedora IoT documentation](https://docs.fedoraproject.org/en-US/iot/) for provisioning details.

## AMD64

1. On [fedoraproject.org/iot/download](https://fedoraproject.org/iot/download/), download the x86_64 ISO labeled **Simplified Provisioner**.
2. Open Fedora Media Writer, choose the downloaded ISO as a custom image, and write it to a USB drive.
3. Boot the computer from the USB drive and follow the provisioner to install Fedora IoT.
4. Ensure the system has network access and an administrator account that can use `sudo`.

## Switch to Entrypoint

On the installed Fedora IoT system, run the following commands. Leave off `sudo` if you're still using the `root` user.

```bash
sudo bootc switch ghcr.io/cvsickle/entrypoint:latest
sudo systemctl reboot
```

After the system boots into Entrypoint, enable signature enforcement:

```bash
sudo bootc switch --enforce-container-sigpolicy ghcr.io/cvsickle/entrypoint:latest
sudo systemctl reboot
```

If the boot loader menu entries are still showing the upstream image name, force them to update. Unfortunately, this is only a one-time fix. I'm still researching why this happens sometimes.

```bash
sudo rpm-ostree kargs --append=bls.refresh=1
sudo systemctl reboot
```

## Verify the Image Signature

Download `cosign.pub` from this repository, then verify the image with [cosign](https://github.com/sigstore/cosign):

```bash
cosign verify --key cosign.pub ghcr.io/cvsickle/entrypoint:latest
```

## Updates

To minimize potential interruptions, the default Fedora Bootc timers have been overridden so that system updates are applied automatically overnight between 2-3am. When the system is updated, it will be automatically rebooted into the new image.

To adjust this behavior, simply add another override on top of the one that ships with this image. For example, to move the updates to between 2-2:30pm, create a `/etc/systemd/system/bootc-fetch-apply-updates.timer.d/20-custom-override.conf` file with:

```bash
[Timer]
OnCalendar=
OnCalendar=*-*-* 14:00:00
RandomizedDelaySec=30m
```

See [systemd.timer](https://www.freedesktop.org/software/systemd/man/latest/systemd.timer.html) for more formatting and configuration information.
