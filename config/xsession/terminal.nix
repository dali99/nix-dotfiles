{ pkgs, config, lib, ...}:
{

  imports = [ ./zsh/zsh.nix ];


  programs.kitty = {
    enable = true;
    settings = ''
      #term			xterm-256color
      font_family		monospace
      font_size		12.0
      background_opacity	0.7

      clear_all_shortcuts yes

      map ctrl+shift+c copy_to_clipboard
      map ctrl+shift+v paste_from_clipboard



      map ctrl+plus change_font_size all +2.0
      map ctrl+shift+plus change_font_size all -2.0
    '';
  };

  home.packages = with pkgs; [
    gnome3.gnome-terminal
    kitty
    pkgs.ncurses.dev
  ];
}
