{ config, lib, pkgs, inputs, ... }:

{
  services.ollama = {
    enable = true;
    package = inputs.unstable.legacyPackages.x86_64-linux.ollama-rocm;
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
}
