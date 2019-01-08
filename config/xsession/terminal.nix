{ pkgs, config, lib, ...}:
{

  imports = [ ./zsh/zsh.nix ];

#  programs.urxvt = {
#    enable = true;
#    fonts = [ "xft:DejaVu Sans Mono Nerd Font:size=12" ];
#    scroll.bar.enable = false;
#    shading = 20;
#    extraConfig = {
#      "foreground" = "#cccccc";
#      "tintColor" = "white";
#      "depth" = 32;
#      "background" = "rgba:0000/0000/0200/c800";
#      "color0" = "#000000";
#      "color1" = "#9e1828";
#      "color2" = "#aece92";
#      "color3" = "#968a38";
#      "color4" = "#414171";
#      "color5" = "#963c59";
#      "color6" = "#418179";
#      "color7" = "#bebebe";
#      "color8" = "#666666";
#      "color9" = "#cf6171";
#      "color10" = "#c5f779";
#      "color11" = "#fff796";
#      "color12" = "#4186be";
#      "color13" = "#cf9ebe";
#      "color14" = "#71bebe";
#      "color15" = "#ffffff";
#      "buffered" = "false";
#    };
#  };


  home.file.kitty = {
    target = ".config/kitty/kitty.conf";
    text = ''
font_family		monospace
font_size		12.0
background_opacity	0.7
map ctrl+shift+question change_font_size all +2.0
    '';
  };


 home.packages = [
    pkgs.gnome3.gnome-terminal
    pkgs.kitty
  ];

}
