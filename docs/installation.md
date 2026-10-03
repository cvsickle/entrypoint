# Installing Entrypoint

Entrypoint is a bootc image. Install Fedora IoT for your device first, then switch to the Entrypoint image.

## Raspberry Pi

1. Download the Fedora IoT aarch64 raw image (`.raw.xz`) from [fedoraproject.org/iot/download](https://fedoraproject.org/iot/download/).
2. Open Raspberry Pi Imager, select **Choose OS > Use Custom**, and select the downloaded raw image. You could also use the `arm-image-installer`, which is my preferred method. See [this guide](https://www.redhat.com/en/blog/fedora-iot-raspberry-pi).
3. Select the MicroSD card, write the image, then insert it into the Raspberry Pi and boot.
4. Configure Fedora IoT's first-boot provisioning to set up network access and an administrator account that can use `sudo`. See the [Fedora IoT documentation](https://docs.fedoraproject.org/en-US/iot/) for provisioning details.

## AMD64

1. On [fedoraproject.org/iot/download](https://fedoraproject.org/iot/download/), download the x86_64 ISO labeled **Simplified Provisioner**.
2. Open Fedora Media Writer, choose the downloaded ISO as a custom image, and write it to a USB drive.
3. Boot the computer from the USB drive and follow the provisioner to install Fedora IoT.
4. Ensure the system has network access and an administrator account that can use `sudo`.

## Switch to Entrypoint

On the installed Fedora IoT system, run:

```bash
sudo bootc switch ghcr.io/cvsickle/entrypoint:latest
sudo systemctl reboot
```

After the system boots into Entrypoint, enable signature enforcement:

```bash
sudo bootc switch --enforce-container-sigpolicy ghcr.io/cvsickle/entrypoint:latest
sudo systemctl reboot
```

If the boot menu still shows the upstream image name, refresh its entries:

```bash
sudo rpm-ostree kargs --append=bls.refresh=1
sudo systemctl reboot

sudo rpm-ostree kargs --delete=bls.refresh=1
sudo systemctl reboot
```

## Verify the Image Signature

Download `cosign.pub` from this repository, then verify the image with [cosign](https://github.com/sigstore/cosign):

```bash
cosign verify --key cosign.pub ghcr.io/cvsickle/entrypoint:latest
```
