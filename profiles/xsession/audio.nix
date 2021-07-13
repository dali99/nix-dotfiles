{pkgs, config, lib, ...}:
let
  audio-plugins = pkgs.symlinkJoin { name = "audio-plugins"; paths = [ pkgs.lsp-plugins pkgs.speech-denoiser ];};
in
{
  config = lib.mkIf config.profiles.xsession.enable {
    home.packages = [ ] ++ lib.optionals config.profiles.gui.enable [
      pkgs.pavucontrol
      pkgs.carla
    ];
    
    home.file."audio-plugins" = {
      source = "${audio-plugins}/lib";
      target = "audio-plugins";
    };
  };
}
