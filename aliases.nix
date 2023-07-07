{ pkgs, misc, ... }: {
    # DO NOT EDIT: This file is managed by fleek. Manual changes will be overwritten.
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
}
