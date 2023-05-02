{ pkgs, config, lib, ... }:

let
  cfg = config.profiles.zsh;
in
{
  options.profiles.zsh = {
    enable = lib.mkEnableOption "Manage zsh from hm";
  };

  config = lib.mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      dotDir = ".config/zsh";
      enableAutosuggestions = true;
      enableCompletion = true;
      history = {
        expireDuplicatesFirst = true;
        ignoreDups = true;
        share = false;
      };
      shellAliases = {
        cat = "bat";
        ls = "exa";
        tree = "exa -T";
        df = "df -h";

        sysu = "systemctl --user";
        jnlu = "journalctl --user";

        mpvav1 = "mpv --vd-queue-enable=yes --ad-queue-enable=yes --vd-queue-max-bytes=4000MiB --vd-queue-max-samples=2000000 --vd-queue-max-secs=50";

        gst = "git status -sb";
        gcm = "git commit -m";
        gca = "git commit --amend --no-edit";
        grc = "git rc";
        gne = "git n";
        gds = "git diff --staged";
        glg = "git log --oneline";
        
        nano = "hx"; # Behavioral training
      };
      initExtra = ''
        source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme 
        source ${./p10k.zsh}

        autoload -U down-line-or-beginning-search
        autoload -U up-line-or-beginning-search

        zle -N down-line-or-beginning-search
        zle -N up-line-or-beginning-search

        bindkey '^[OA' up-line-or-beginning-search
        bindkey '^[OB' down-line-or-beginning-search

        bindkey '^[[1;5D' backward-word
        bindkey '^[[1;5C' forward-word
        bindkey '^H' backward-kill-word

        bindkey '^[OH'  beginning-of-line
        bindkey '^[OF'  end-of-line
        bindkey '^[[3~' delete-char

        ZLE_RPROMPT_INDENT=0
      '';
    };

    programs.direnv = {
      enable = true;
    };
    
    programs.atuin = {
      enable = true;
      enableZshIntegration = true;
    };

    home.packages = [
       pkgs.dan.mesloNFp10k
    ];
  };
}
