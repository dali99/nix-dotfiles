{ config, lib, pkgs, ... }:

let
  cfg = config.profiles.base;

  helixDesktop = pkgs.makeDesktopItem {
    name = "Helix";
    type = "Application";
    desktopName = "Helix";
    genericName = "Text Editor";
    comment = "Edit text files";
    tryExec = "hx";
    exec = "kitty hx %F";
    terminal = false; # Until you can globally set a prefered terminal we hardcoding this
    mimeTypes = [ "ext/english" "text/plain" "text/x-makefile" "text/x-c++hdr" "text/x-c++src" "text/x-chdr" "text/x-csrc" "text/x-java" "text/x-moc" "text/x-pascal" "text/x-tcl" "text/x-tex" "application/x-shellscript" "text/x-c" "text/x-c++" ];
    categories = [ "Utility" "TextEditor" ];
    keywords = [ "Text" "editor" ];
    startupNotify = false;
  };
in
{
  options.machine = {
    name = lib.mkOption {
      type = lib.types.str;
    };
    systemd = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
    eth = lib.mkOption { };
    wlan = lib.mkOption { };
    secondary-fs = lib.mkOption {
      type = lib.types.nullOr lib.types.nonEmptyStr;
      default = null;
      example = "''${env:HOME}";
    };
  };

  options.profiles.base = {
    enable = lib.mkEnableOption "The base profile, should be always enabled";
    plus = lib.mkEnableOption "Useful things you arguably don't NEED";
  };

  config = lib.mkIf cfg.enable {
    home.language = {
      base = "nb_NO.utf8";
      messages = "en_US.utf8";
    };


    home.packages = with pkgs; [
      unstable.nix-output-monitor
      nix-top
      nix-index
      nix-tree
      unstable.comma

      rnix-lsp
      helixDesktop

      ldns
      mtr

      lsof

      htop

      file
      tmux

      unzip
      p7zip

      parallel
      sshfs
      jq

      ncdu

      bat
      exa
      ripgrep
    ] ++ lib.optionals cfg.plus [
      ffmpeg-full
    ] ++ lib.optionals config.profiles.gui.enable [
      mpv
      sxiv

      dolphin
      plasma5Packages.dolphin-plugins
      ffmpegthumbs
      plasma5Packages.kdegraphics-thumbnailers
      plasma5Packages.kio
      plasma5Packages.kio-extras
      krename
      konsole # https://bugs.kde.org/show_bug.cgi?id=407990 reeee

      gnome3.gedit

      gimp
    ] ++ lib.optionals (config.profiles.gui.enable && cfg.plus) [
      mumble

      #      texlive.combined.scheme-full
      #      kile
      libreoffice
      thunderbird

      kdenlive
      frei0r
      audacity
      inkscape
      blender

      mkvtoolnix
    ] ++ lib.optionals (config.nixpkgs.config.allowUnfree && config.profiles.gui.enable) [
      geogebra
    ];

    programs.firefox = {
      enable = config.profiles.gui.enable;
      profiles = {
        daniel = {
          settings = {
            "browser.startup.homepage" = "https://nixos.org";
          };
          bookmarks = {
            "NixOS Options" = {
              keyword = "no";
              url = "https://search.nixos.org/options?query=%s";
            };
            "NixOS Packages" = {
              keyword = "np";
              url = "https://search.nixos.org/packages?query=%s";
            };
            "Home-Manager Options" = {
              keyword = "hm";
              url = "https://rycee.gitlab.io/home-manager/options.html#opt-%s";
            };
          };
        };
      };
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [ bitwarden cookies-txt metamask no-pdf-download sponsorblock ublock-origin ];
    };


    programs.obs-studio.enable = (config.profiles.gui.enable && cfg.plus);


    programs.tealdeer.enable = true;

    programs.helix = {
      enable = true;
      package = pkgs.helix;
      settings = let
        b = command: ":insert-output " + command;
        c = chars: b "printf " + chars;
      in {
        editor.line-number = "relative";
        editor.mouse = false;
        keys.normal = {
          # Empty keys: Ø, æ, Æ, å, Å, *, [ ] 
          "ø" = "collapse_selection"; # For ;
          "minus" = "search"; # For /
          "_" = "rsearch"; # for =
          "+" = "trim_selections"; # for _
          "å" = {
            "d" = "goto_prev_diag"; # for [d
            "D" = "goto_first_diag";
            "f" = "goto_prev_function";
            "c" = "goto_prev_class";
            "a" = "goto_prev_parameter";
            "o" = "goto_prev_comment";
            "p" = "goto_prev_paragraph";
            "space" = "add_newline_above";
          };
          "¨" = {
            "d" = "goto_next_diag";
            "D" = "goto_last_diag";
            "f" = "goto_next_function";
            "c" = "goto_next_class";
            "a" = "goto_next_parameter";
            "o" = "goto_next_comment";
            "p" = "goto_next_paragraph";
            "space" = "add_newline_below";
          };
        };
        keys.insert = {
          "S-tab" = "unindent";
          # Poor man's US-Keyboard
          "Å" = [(c "{}") "move_char_right"];
          "º" = c "Å";
          "^" = c "}";
          "¤" = c "^";
        };
      };
    };

    programs.vscode = {
      enable = config.profiles.gui.enable;
      package = pkgs.vscodium;
      extensions = with pkgs.vscode-extensions; [
        bbenoist.nix
        
        matklad.rust-analyzer
        vadimcn.vscode-lldb
      ] ++ lib.optionals config.nixpkgs.config.allowUnfree [
        ms-vsliveshare.vsliveshare
      ];
      userSettings = {
        "editor.insertSpaces" = false;
        "terminal.integrated.fontFamily" = "MesloLGS NF";
      };
    };

    programs.git = {
      enable = true;
      userEmail = "daniel.olsen99@gmail.com";
      userName = "Daniel Olsen";
      aliases = {
        absorb = "!${pkgs.git-absorb}/bin/git-absorb";
        revise = "!${pkgs.git-revise}/bin/git-revise";
        rc = "rebase --continue";
        n = "!git commit --all --amend --no-edit && git rc";
      };
      ignores = [
        ".envrc"
        ".direnv"
        ".vscode"
      ];
      extraConfig = {
        pull.rebase = true;
        # sequence.editor = let 
        #   girt = pkgs.unstable.git-interactive-rebase-tool.overrideAttrs (old: rec {
        #     src = pkgs.fetchFromGitHub {
        #       owner = "Dali99";
        #       repo = "git-interactive-rebase-tool";
        #       rev = "590f87d8ed16992373e214bca5994f89c69fa942";
        #       sha256 = "sha256-vUjqnt5ZSpzoohkzDXEqTMhMEkYzPMUZiaYWS0ZQcPQ=";
        #     };
        #     cargoDeps = old.cargoDeps.overrideAttrs (oldB: {
        #       name = "${oldB.name}";
        #       inherit src;
        #       outputHash = "sha256-/I465/PlOckvov9PgSCg7CN5hEKeeQCw8rPsvpKJons=";
        #     });
        #   });
        # in "${girt}/bin/interactive-rebase-tool";
      };
      delta.enable = true;
    };


    programs.ssh = {
      enable = true;
      matchBlocks = {
        "lilith" = {
          hostname = "lilith.dods";
          user = "dandellion";
        };
        "desktop" = {
          hostname = "nixos-fhjypz8j.dods";
          user = "dan";
        };
        "laptop" = {
          hostname = "danixlaptop.dods";
          user = "daniel";
        };
        "pvv.ntnu.no" = {
          user = "danio";
        };
        "*.pvv.ntnu.no" = {
          user = "danio";
        };
        "gitlab.stud.idi.ntnu.no" = {
          proxyJump = "login.pvv.ntnu.no";
        };
      };
    };

    services.gpg-agent = {
      enable = true;
      defaultCacheTtl = 1800;
      enableSshSupport = true;
    };

    home.sessionVariables = {
      EDITOR = "hx";
    };

    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "image/png" = [ "sxiv.desktop" "gimp.desktop" ];
        "image/jpeg" = [ "sxiv.desktop" ];
        "text/plain" = [ "Helix.desktop" "gedit.desktop" "code.desktop" ];
        "video/x-matroska" = [ "mpv.desktop" ];
      };
      associations.removed = {
        "text/plain" = [ "writer.desktop" ];
      };
    };

    fonts.fontconfig.enable = config.profiles.gui.enable;
  };
}
