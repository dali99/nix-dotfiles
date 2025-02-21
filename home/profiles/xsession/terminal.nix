{ pkgs, config, lib, ...}:
{

  config = lib.mkIf config.profiles.xsession.enable {

    programs.kitty = {
      enable = true;
      font.name = "MesloLGS NF";
      font.size = 12;
      keybindings = {
        "ctrl+shift+c" = "copy_to_clipboard";
        "ctrl+shift+v" = "paste_from_clipboard";

        "ctrl+plus" = "change_font_size all +2.0";
        "ctrl+shift+plus" = "change_font_size all -2.0";
      };
      settings = {
        "background_opacity" = 0.7;
      };
    };

   home.packages = [
      pkgs.ncurses.dev
    ];
  };
}
