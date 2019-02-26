{pkgs, config, lib, ...}:
{
  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    enableAutosuggestions = true;
    enableCompletion = true;
    history = {
      expireDuplicatesFirst = true;
      ignoreDups = true;
    };
    oh-my-zsh = {
      enable = true;
      custom = "\$HOME/.config/nixpkgs/nix-dotfiles/config/xsession/zsh/oh-my-zsh-custom";
      plugins = [
        "git"
        "sudo"
      ];
      theme = "powerlevel9k/powerlevel9k";
    };
    initExtra = ''
POWERLEVEL9K_MODE='nerdfont-complete'

POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(os_icon context dir newline vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status time)

POWERLEVEL9K_OS_ICON_BACKGROUND="white"
POWERLEVEL9K_OS_ICON_FOREGROUND="blue"

POWERLEVEL9K_CONTEXT_DEFAULT_BACKGROUND="green"
POWERLEVEL9K_CONTEXT_DEFAULT_FOREGROUND="white"
POWERLEVEL9K_CONTEXT_SUDO_BACKGROUND="red"
POWERLEVEL9K_CONTEXT_SUDO_FOREGROUND="white"

POWERLEVEL9K_DIR_HOME_FOREGROUND="white"
POWERLEVEL9K_DIR_HOME_SUBFOLDER_FOREGROUND="white"
POWERLEVEL9K_DIR_DEFAULT_FOREGROUND="white"
POWERLEVEL9K_SHORTEN_DIR_LENGTH=2
POWERLEVEL9K_SHORTEN_DELIMITER=".."

POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX="↱"
POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="↳ "


MATRIXDEV_HOMESERVER="https://matrix.dodsorf.as"
***REMOVED***


eval "$(ntfy shell-integration)"
AUTO_NTFY_DONE_IGNORE="vim nano screen tmux man mpv"
    '';
  };

  home.file.ntfy = {
    source = ./ntfy.yml;
    target = ".config/ntfy/ntfy.yml";
  };

  programs.direnv = {
    enable = true;
  };

  home.packages = [
    pkgs.nerdfonts
    pkgs.ntfy
  ];

}
