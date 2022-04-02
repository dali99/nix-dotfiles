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
        gds = "git diff --staged";
        glg = "git log --oneline";
      };
      initExtra = ''
        source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme 
        source ${./p10k.zsh}

        autoload -U history-search-end
        zle -N history-beginning-search-backward-end history-search-end
        zle -N history-beginning-search-forward-end history-search-end

        bindkey '^[OA' history-beginning-search-backward-end
        bindkey '^[OB' history-beginning-search-forward-end

        bindkey '^[[1;5D' backward-word
        bindkey '^[[1;5C' forward-word
        bindkey '^H' backward-kill-word

        bindkey '^[OH'  beginning-of-line
        bindkey '^[OF'  end-of-line
        bindkey '^[[3~' delete-char

        ZLE_RPROMPT_INDENT=0

        export MATRIXDEV_HOMESERVER="https://matrix.dodsorf.as"
        export ***REMOVED***

        export FV_KUBECONFIG="$HOME/.kube/config-fv"
        export FV_KUBECONFIG="$HOME/.kube/config-fv-prod"

        export FV_ARM_SUBSCRIPTION_ID="***REMOVED***"
        export FV_ARM_CLIENT_ID="***REMOVED***"
        export FV_ARM_CLIENT_SECRET="***REMOVED***"
        export FV_ARM_TENANT_ID="***REMOVED***"
        export FV_ARM_ENVIRONMENT="public"
      '';
    };

    programs.direnv = {
      enable = true;
    };

    home.packages = [
       pkgs.dan.mesloNFp10k
    ];
  };
}
