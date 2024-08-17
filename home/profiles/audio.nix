{pkgs, config, lib, ...}:
let
  cfg = config.profiles.audio;
  audio-plugins = pkgs.symlinkJoin { name = "audio-plugins"; paths = [ pkgs.lsp-plugins pkgs.speech-denoiser ];};
in
{
  options.profiles.audio = {
    enable = lib.mkOption {
      default = config.profiles.xsession.enable;
      defaultText = "xsession.enable";
    };
    fancy = lib.mkOption {
      default = cfg.enable;
      defaultText = "audio.enable";
    };
  };


  config = lib.mkIf config.profiles.audio.enable {
    home.packages = with pkgs; [

    ] ++ lib.optionals config.profiles.gui.enable (with pkgs; [
      pavucontrol
    ]) ++ lib.optionals (config.nixpkgs.config.allowUnfree && config.profiles.gui.enable) (with pkgs; [
      spotify
    ]) ++ lib.optionals cfg.fancy (with pkgs; [
      carla
    ]);
    
    home.file."audio-plugins" = lib.mkIf cfg.fancy {
      source = "${audio-plugins}/lib";
      target = "audio-plugins";
    };
  };
}
