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
      };
      shellAliases = {
        mpvav1 = "mpv --vd-queue-enable=yes --ad-queue-enable=yes --vd-queue-max-bytes=4000MiB --vd-queue-max-samples=2000000 --vd-queue-max-secs=50";
      };
      initExtra = ''
        source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme 
        source ${./p10k.zsh}

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
