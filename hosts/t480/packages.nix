{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Window manager / session
    bspwm
    sxhkd
    polybar
    rofi
    dunst
    xterm
    dejavu_fonts

    # Desktop applications
    firefox
    thunar
    mpv
    imv
    zathura
    sublime4
    steam

    # Terminal / CLI
    git
    ripgrep
    fd
    fzf
    btop
    yazi
    nano

    # Small utilities
    playerctl
    brightnessctl
    xclip
    scrot
    i3lock
    xss-lock
    unzip
    xorg.xsetroot
  ];

  programs.steam.enable = true;
}
