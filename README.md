# Entrypoint

[![bluebuild build badge](https://github.com/cvsickle/entrypoint/actions/workflows/build.yml/badge.svg)](https://github.com/cvsickle/entrypoint/actions/workflows/build.yml) &nbsp; [![Dependabot Updates](https://github.com/cvsickle/entrypoint/actions/workflows/dependabot/dependabot-updates/badge.svg)](https://github.com/cvsickle/entrypoint/actions/workflows/dependabot/dependabot-updates) &nbsp; [![renovate](https://github.com/cvsickle/entrypoint/actions/workflows/renovate.yml/badge.svg)](https://github.com/cvsickle/entrypoint/actions/workflows/renovate.yml) &nbsp; [![Repo sync (GitHub -> Codeberg)](https://github.com/cvsickle/entrypoint/actions/workflows/sync_codeberg.yaml/badge.svg)](https://github.com/cvsickle/entrypoint/actions/workflows/sync_codeberg.yaml)

---

Ever need a quick, self-updating OS to use a lower-power edge device as a safe(ish) **entrypoint** to your home network? That's what I'm working on here.

This repository is a custom [bootc](https://github.com/bootc-dev/bootc) image built on [fedora-bootc](https://gitlab.com/fedora/bootc).

It was created using the [BlueBuild Workshop](https://workshop.blue-build.org/).

## Changes made

### System packages added

- [Podman](https://github.com/podman-container-tools/podman)
- [Docker CLI](https://github.com/docker/cli)
- [Podman Compose](https://github.com/containers/podman-compose)
- [Tailscale](https://tailscale.com/)
  - See [docs/tailscale](./docs/tailscale.md) for setup info.

## Installation

> [!TIP]
> This process should work from any Fedora-based bootc image.

- Once in the system, switch to this image.

```bash
sudo bootc switch ghcr.io/cvsickle/entrypoint:latest

# Reboot when done.
systemctl reboot
```

- Once booted into this image, enable signing verification.

```bash
sudo bootc switch --enforce-container-sigpolicy ghcr.io/cvsickle/entrypoint:latest
```

- If the boot loader menu entries are still showing the upstream image name, force them to update.

```bash
sudo rpm-ostree kargs --append=bls.refresh=1
systemctl reboot

sudo rpm-ostree kargs --delete=bls.refresh=1
systemctl reboot
```

## Verification

These images are signed with [Sigstore](https://www.sigstore.dev/)'s [cosign](https://github.com/sigstore/cosign). You can verify the signature by downloading the `cosign.pub` file from this repo and running the following command:

```bash
cosign verify --key cosign.pub ghcr.io/cvsickle/entrypoint
```

## Repository Mirrors

- GitHub - [https://github.com/cvsickle/entrypoint](https://github.com/cvsickle/entrypoint)

## Other custom OS images

- [Bazzite DX](https://github.com/cvsickle/bazzite-dx)
- [Bluefin DX](https://github.com/cvsickle/bluefin-dx)
- [Zirconium](https://github.com/cvsickle/zirconium)
