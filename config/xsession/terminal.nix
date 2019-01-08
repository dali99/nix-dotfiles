{ pkgs, config, lib, ...}:
{

  imports = [ ./zsh/zsh.nix ];


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
