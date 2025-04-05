{ config, lib, pkgs, inputs, ... }:

{
  services.ollama = {
    enable = true;
    acceleration = "rocm";
    package = inputs.unstable.legacyPackages.x86_64-linux.ollama;
    rocmOverrideGfx = "10.3.0";
    environmentVariables = {
      ROCR_VISIBLE_DEVICES = "GPU-5ecd14c0d670740b";
    };
    host = "100.64.0.19";
    loadModels = [
      "gemma3:4b"
      "gemma3:12b"
      "gemma3:27b"
      "deepseek-r1:7b"
      "deepseek-r1:14b"
      "qwq:32b"
      "codestral:22b"
    ];
  };

  systemd.services.ollama = {
    serviceConfig = {
      SupplementaryGroups = [ "video" ];
    };
  };
}
