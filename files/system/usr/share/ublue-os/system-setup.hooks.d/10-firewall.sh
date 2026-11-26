#!/usr/bin/env bash
# Configure firewalld's public zone (the default zone) for Entrypoint.
# firewall-offline-cmd edits the permanent config without requiring firewalld to be running.
# Each change is skipped if already present, so the hook is safe to run on every boot.
set -euo pipefail

zone_file=/etc/firewalld/zones/public.xml

if ! grep -q '<service name="samba"/>' "$zone_file" 2>/dev/null; then
    firewall-offline-cmd --zone=public --add-service=samba
fi

if ! grep -q '<masquerade/>' "$zone_file" 2>/dev/null; then
    firewall-offline-cmd --zone=public --add-masquerade
fi
