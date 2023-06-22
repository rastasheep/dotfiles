{ pkgs, misc, ... }: {
  # DO NOT EDIT: This file is managed by fleek. Manual changes will be overwritten.
   home.shellAliases = {
    "apply-mbp" = "nix run github:ublue-os/fleek -- apply -l src/github.com/rastasheep/dotfiles";
    
    "dc" = "docker compose";
    
    "fleeks" = "cd ~/src/github.com/rastasheep/dotfiles";
    };
}
