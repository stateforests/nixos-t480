# NixOS T480

Minimal, X11/bspwm-focused NixOS configuration for a Lenovo ThinkPad T480.

## Design

- NixOS 26.05
- UEFI + systemd-boot
- LUKS2
- ext4
- X11
- bspwm + sxhkd
- Polybar
- rofi
- dunst
- greetd + tuigreet
- PipeWire
- NetworkManager
- TLP + thermald
- Steam
- Firefox
- Thunar
- mpv
- imv
- zathura
- Sublime Text
- nano

Application configuration lives in `config/` as normal files.

There is intentionally no Home Manager: this is a single-host configuration and
the system configuration is small enough to remain straightforward.

## Configuration files

Application configs are installed under `/etc/xdg` or `/etc/Xresources`; the
session startup script is installed under `/etc/X11/xinit/xinitrc`.

## Network secrets


Create `/etc/nixos/network-secrets.env` on the installed machine using
`network-secrets.env.example`.

Never commit the real secrets file.

## Important

`hosts/t480/hardware-configuration.nix` is generated from the actual machine.
Do not fill it with guessed UUIDs.
