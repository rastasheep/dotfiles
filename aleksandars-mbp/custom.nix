{ pkgs, misc, ... }: {
  # FEEL FREE TO EDIT: This file is NOT managed by fleek. 
    programs.git = {
        enable = true;
        ignores = ["*~" "*.swp" ".DS_Store"];
        aliases = {
            a = "add";
            all = "add -A";
            st = "status -sb";
            ci = "commit";
            ca = "commit --amend";
            br = "branch";
            co = "checkout";
            df = "diff";
            dfc = "diff --cached";
            lg = "log --pretty=format:'%C(yellow)%h%Creset %Cgreen(%><(12)%cr%><|(12))%Creset - %s %C(blue)<%an>%Creset'";
            pl = "pull";
            ps = "push";
            undo =  "reset --soft HEAD^";
            count = "!git shortlog -sne";
            pr = "!f() { git fetch origin pull/$1/head:pr-$1 && git checkout pr-$1; }; f";
            up = "!f() { git pull --rebase --prune && git log --pretty=format:\"%Cred%ae %Creset- %C(yellow)%s %Creset(%ar)\" HEAD@{1}.. }; f";
        };
    };

    programs.zsh = {
        shellAliases = {
            g = "git";
        };
    };
}
