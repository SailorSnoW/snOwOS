{ pkgs, lib, config, ... }:

let
  nf_logo = pkgs.fetchurl {
    url = "https://i.ibb.co/yBXfC3V/55c1cb43593362af769ceb149def07eb12ab0bac-Photo-Room-png-Photo-Room.png";
    sha256 = "dd75f8596011a4b0c5f023045aed7b7005dcdfee8860a4906e8a684f8a7c91a1";
  };
in
{
  home.activation.copyImage = lib.hm.dag.entryAfter [ "writeBoundary" ] '' 
    mkdir -p $HOME/.config/neofetch
    cp -f ${nf_logo} $HOME/.config/neofetch/nf_logo.png
  '';   

  home.file.".config/neofetch/config.conf".text = ''
    print_info() {
        prin ""
        info title
        info "\e[34m  " distro
        info "\e[31m " kernel
        info "\e[33m " uptime
        info "\e[32m " shell
        info "\e[35m " wm
        prin "$(color 1)▂▂ $(color 2)▂▂ $(color 3)▂▂ $(color 4)▂▂ $(color 5)▂▂ $(color 6)▂▂ "
    }

    title_fqdn="off"
    kernel_shorthand="on"
    distro_shorthand="on"
    uptime_shorthand="tiny"
    memory_percent="off"
    memory_unit="mib"
    package_managers="off"
    shell_path="off"
    shell_version="on"
    speed_type="bios_limit"
    speed_shorthand="off"
    cpu_brand="on"
    cpu_cores="logical"
    refresh_rate="off"
    gtk_shorthand="off"
    gtk2="on"
    gtk3="on"
    de_version="on"
    bold="off"
    underline_enabled="on"
    underline_char="_"
    separator=" • "
    color_blocks="on"
    block_width=3
    block_height=1
    col_offset="auto"
    bar_char_elapsed="-"
    bar_char_total="="
    bar_border="on"
    bar_length=15
    bar_color_elapsed="distro"
    bar_color_total="distro"
    image_backend="kitty"
    image_source="$HOME/.config/neofetch/nf_logo.png"
    image_size="250px"
    image_loop="on"
    ascii_distro="nixos"
    ascii_colors=(distro)
    ascii_bold="on"
    #thumbnail_dir="${config.home.homeDirectory}/.cache/thumbnails/neofetch"
    crop_mode="fit"
    crop_offset="center"
    yoffset=0
    xoffset=0
    stdout="off"

  '';
}


