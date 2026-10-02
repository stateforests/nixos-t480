#!/bin/sh
set -eu

target=/etc/nixos/network-secrets.env

if [ "$(id -u)" -ne 0 ]; then
    echo "Run this script as root: sudo ./bootstrap-secrets.sh"
    exit 1
fi

if [ -e "$target" ]; then
    echo "$target already exists; refusing to overwrite it."
    exit 1
fi

umask 077
cat > "$target" <<'EOF'
EDUROAM_IDENTITY=
EDUROAM_PASSWORD=
PURE9522_PASSWORD=
EOF

chmod 600 "$target"

echo "Created $target."
echo "Edit it with:"
echo "  sudo nano $target"
