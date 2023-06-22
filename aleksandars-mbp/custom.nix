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

    programs.tmux = {
        enable = true;

         keyMode = "vi";
         prefix = "C-a";
         baseIndex = 1;
         customPaneNavigationAndResize = true; 
         resizeAmount = 10;
         aggressiveResize = true;
         disableConfirmationPrompt = false;
         escapeTime = 50;
         historyLimit = 10000;
         newSession = true;
         shortcut = "a";
         terminal = "screen-256color";
         sensibleOnTop = false;

         extraConfig = ''
             bind-key C-a last-window

             # scroll stuff
             set -g terminal-overrides 'xterm*:smcup@:rmcup@'
             
             
             # Highlight active window
             set -g window-status-current-style bg=green
             
             # open new window in same dir
             bind c new-window -c "#{pane_current_path}"
             
             # v and y like vi in copy-mode
             bind-key -T copy-mode-vi 'v' send -X begin-selection
             bind-key -T copy-mode-vi 'Y' send -X copy-pipe-and-cancel "reattach-to-user-namespace pbcopy"
             
             # p for paste
             unbind p
             bind p paste-buffer
             
             
             # enable wm window titles
             set -g set-titles on
             
             # wm window title string (uses statusbar variables)
             set -g set-titles-string "tmux.#I.#W"
             
             # disable  auto renaming
             setw -g automatic-rename off
             
             # statusbar
             set -g display-time 2000
             set -g status-left '''
             set -g status-right "#( date +' %H:%M ')"
             
             # split pane hotkeys
             bind-key \\ split-window -h
             bind-key - split-window -v
             
             #### Colours
             
             # default statusbar colors
             set -g status-bg black
             set -g status-fg yellow
             
             # active window title colors
             setw -g window-status-current-style bg=black,fg=brightred
             
             # pane border
             setw -g pane-border-style bg=black
             setw -g pane-active-border-style fg=yellow
             
             # message text
             setw -g message-style fg=brightred,bg=black
             
             # pane number display
             set-option -g display-panes-active-colour blue #blue
             set-option -g display-panes-colour brightred #orange
             set-option default-terminal "screen-256color"

         '';
    };
}
