{ config, pkgs, misc, ... }: {
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowBroken = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = (_: true);
    };
  };

  home.packages = [
    pkgs.silver-searcher
    pkgs.coreutils
    pkgs.openssl
    pkgs.tree
    pkgs.docker
    pkgs.slack
    pkgs.wget
    pkgs.raycast
    pkgs.openvpn
    pkgs.git
    pkgs.direnv
    # pkgs.zoom-us
    # pkgs.ollama
    ];
  home.shellAliases = {
    ".." = "cd ..";
    "ack" = "ag";
    "dc" = "docker compose";
    "df" = "df -hT";
    "e" = "vim";
    "f" = "fg";
    "g" = "git";
    "history" = "fc -El 1";
    "j" = "jobs";
    "ll" = "ls -lah";
  };
  home.sessionPath = [
    "$HOME/bin"
    "$HOME/.local/bin"
  ];
  fonts.fontconfig.enable = true;
  home.stateVersion = "22.11"; # To figure this out (in-case it changes) you can comment out the line and see what version it expected.

  programs.home-manager.enable = true;

  programs.dircolors.enable = true;

  programs.zsh.profileExtra = "[ -r ~/.nix-profile/etc/profile.d/nix.sh ] && source  ~/.nix-profile/etc/profile.d/nix.sh";
  programs.zsh.enableCompletion = true;
  programs.zsh.enable = true;
}
