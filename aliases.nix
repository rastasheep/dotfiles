{ pkgs, misc, ... }: {
  # DO NOT EDIT: This file is managed by fleek. Manual changes will be overwritten.
   home.shellAliases = {
    ".." = "cd ..";
    
    "ack" = "ag";
    
    "apply-mbp" = "nix run github:ublue-os/fleek -- apply -l src/github.com/rastasheep/dotfiles";
    
    "dc" = "docker compose";
    
    "df" = "df -hT";
    
    "e" = "vim";
    
    "f" = "fg";
    
    "fleeks" = "cd ~/src/github.com/rastasheep/dotfiles";
    
    "g" = "git";
    
    "history" = "fc -El 1";
    
    "j" = "jobs";
    
    "ll" = "ls -lah";
    };
}
