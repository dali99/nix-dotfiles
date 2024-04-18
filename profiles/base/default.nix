{ config, lib, pkgs, ... }:

let
  cfg = config.profiles.base;
in
{
  options.machine = {
    name = lib.mkOption {
      type = lib.types.str;
    };
    cores = lib.mkOption {
      type = lib.types.ints.positive;
      default = 1;
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

      openvpn

      ldns
      mtr
      nmap
      inetutils
      httpie

      lsof

      htop
      progress

      file
      bintools

      gh
      tmux

      timewarrior

      unzip
      p7zip

      yt-dlp

      parallel
      sshfs
      jq

      ncdu

      bat
      eza
      ripgrep
    ] ++ lib.optionals cfg.plus [
      ffmpeg-full
    ] ++ lib.optionals config.profiles.gui.enable [
      mpv
      sxiv
      gnome3.eog

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
    ] ++ lib.optionals (config.profiles.gui.enable && (config ? nixpkgs && config.nixpkgs.config.allowUnfree) ) [
      # geogebra
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
          extensions = with pkgs.nur.repos.rycee.firefox-addons; [ bitwarden cookies-txt metamask no-pdf-download sponsorblock ublock-origin ];
        };
      };
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
        ".devenv"
        ".vscode"
      ];
      extraConfig = {
        pull.rebase = true;
        sequence.editor = let 
          # girt = pkgs.unstable.git-interactive-rebase-tool.overrideAttrs (old: rec {
          #   src = pkgs.fetchFromGitHub {
          #     owner = "Dali99";
          #     repo = "git-interactive-rebase-tool";
          #     rev = "590f87d8ed16992373e214bca5994f89c69fa942";
          #     sha256 = "sha256-vUjqnt5ZSpzoohkzDXEqTMhMEkYzPMUZiaYWS0ZQcPQ=";
          #   };
          #   cargoDeps = old.cargoDeps.overrideAttrs (oldB: {
          #     name = "${oldB.name}";
          #     inherit src;
          #     outputHash = "sha256-/I465/PlOckvov9PgSCg7CN5hEKeeQCw8rPsvpKJons=";
          #   });
          # });
          girt = pkgs.git-interactive-rebase-tool;
        in "${girt}/bin/interactive-rebase-tool";
        branch.sort = "-committerdate";
      };
      delta.enable = true;
    };


    programs.ssh = {
      enable = true;
      matchBlocks = {
        "lilith" = {
          hostname = "lilith.daniel";
          user = "dandellion";
        };
        "desktop" = {
          hostname = "desktop.daniel";
          user = "dan";
        };
        "ubuntu-ai" = {
          hostname = "100.64.0.2";
          port = 2222;
          user = "daniel";
        };
        "laptop" = {
          hostname = "laptop.daniel";
          user = "daniel";
        };
        "pvv.ntnu.no" = {
          user = "danio";
        };
        "*.pvv.ntnu.no" = {
          user = "danio";
        };
        "pascal" = {
          hostname = "wiki.wackattack.eu";
          port = 1337;
          user = "dandellion";
        };
        "ireul" = {
          hostname = "62.92.111.85";
          port = 1337;
          user = "dandellion";
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
