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

See the [installation guide](./docs/installation.md) for Raspberry Pi and AMD64 setup, switching to Entrypoint, and verification.

## Repository Mirrors

- GitHub - [https://github.com/cvsickle/entrypoint](https://github.com/cvsickle/entrypoint)
- Codeberg - [https://codeberg.org/cvsickle/entrypoint](https://codeberg.org/cvsickle/entrypoint)
- Forgejo (Mirror) - [https://git.cvsickle.com/cvsickle/entrypoint](https://git.cvsickle.com/cvsickle/entrypoint)

## Other custom OS images

- [Bazzite DX](https://github.com/cvsickle/bazzite-dx)
- [Bluefin DX](https://github.com/cvsickle/bluefin-dx)
- [Zirconium](https://github.com/cvsickle/zirconium)
