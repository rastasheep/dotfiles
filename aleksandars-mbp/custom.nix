{ pkgs, misc, ... }: {
  # FEEL FREE TO EDIT: This file is NOT managed by fleek.
    home.packages = [
        (pkgs.buildEnv {
            name = "scripts";
            paths = [ ./bin ];
            extraPrefix = "/bin";
        })
    ];

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
    programs.zsh = {
        defaultKeymap = "emacs";
        enableAutosuggestions = true;
        history = {
            share = true;
            extended = true;
        };
        sessionVariables = {
            LANG = "en_US.UTF-8";
        };
        initExtra = ''
            # matches case insensitive for lowercase
            zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

            # pasting with tabs doesn't perform completion
            zstyle ':completion:*' insert-tab pending

            setopt NO_BG_NICE # don't nice background tasks
            setopt NO_HUP
            setopt NO_LIST_BEEP
            setopt LOCAL_OPTIONS # allow functions to have local options
            setopt LOCAL_TRAPS # allow functions to have local traps
            setopt HIST_VERIFY
            setopt PROMPT_SUBST
            setopt CORRECT
            setopt COMPLETE_IN_WORD
            setopt IGNORE_EOF
            setopt AUTO_CD

            setopt APPEND_HISTORY # adds history
            setopt INC_APPEND_HISTORY SHARE_HISTORY  # adds history incrementally and share it across sessions
            setopt HIST_IGNORE_ALL_DUPS  # don't record dupes in history
            setopt HIST_REDUCE_BLANKS

            # don't expand aliases _before_ completion has finished
            #   like: git comm-[tab]
            setopt complete_aliases

            unsetopt correct_all # Stop correcting me!

            # foreground the last backgrounded job using ctrl+z
            # http://sheerun.net/2014/03/21/how-to-boost-your-vim-productivity/.
            #

            fancy-ctrl-z () {
              if [[ $#BUFFER -eq 0 ]]; then
                BUFFER="fg"
                zle accept-line
              else
                zle push-input
                zle clear-screen
              fi
            }

            zle -N fancy-ctrl-z
            bindkey '^Z' fancy-ctrl-z

            # Prompt
            autoload colors && colors

            # get the name of the branch we are on
            function git_prompt_info() {
              local ZSH_THEME_GIT_PROMPT_PREFIX="git:(%{$fg[red]%}"
              local ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"

              if [[ "$(command git config --get oh-my-zsh.hide-status 2>/dev/null)" != "1" ]]; then
                ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
                ref=$(command git rev-parse --short HEAD 2> /dev/null) || return 0
                echo "$ZSH_THEME_GIT_PROMPT_PREFIX''${ref#refs/heads/}$(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_SUFFIX"
              fi
            }


            # Checks if working tree is dirty
            parse_git_dirty() {
              local STATUS
              local FLAGS
              FLAGS=('--porcelain')
              if [[ "$(command git config --get oh-my-zsh.hide-dirty)" != "1" ]]; then
                if [[ $POST_1_7_2_GIT -gt 0 ]]; then
                  FLAGS+='--ignore-submodules=dirty'
                fi
                if [[ "$DISABLE_UNTRACKED_FILES_DIRTY" == "true" ]]; then
                  FLAGS+='--untracked-files=no'
                fi
                STATUS=$(command git status ''${FLAGS} 2> /dev/null | tail -n1)
              fi
              if [[ -n $STATUS ]]; then
                echo "%{$fg[blue]%}) %{$fg[yellow]%}✗%{$reset_color%}"
              else
                echo "%{$fg[blue]%})"
              fi
            }

            suspended_jobs() {
              local sj
              sj=$(jobs 2>/dev/null | tail -n 1)
              if [[ $sj == "" ]]; then
                echo ""
              else
                echo "%{$fg[red]%}✱%{$reset_color%}"
              fi
            }

            local ret_status="%(?:%{$fg[green]%}➜:%{$fg[red]%}➜%s)"
            PROMPT='`suspended_jobs` ''${ret_status}%{$fg_bold[green]%}%p %{$fg[cyan]%}%c %{$fg_bold[blue]%}$(git_prompt_info)%{$fg_bold[blue]%} % %{$reset_color%}'
         '';
    };
    programs.fzf = {
        enable = true;
        enableZshIntegration = true;
    };
    programs.neovim = {
        enable = true;
        withRuby = false;
        withPython3 = false;
        withNodeJs = false;
        defaultEditor = true;
        vimAlias = true;
        extraLuaConfig = builtins.readFile (./vim.lua);
        plugins = with pkgs.vimPlugins; [
            editorconfig-nvim
            fzf-lua
            gitsigns-nvim
            (nvim-treesitter.withPlugins (p: with p; [
              tree-sitter-lua
              tree-sitter-javascript
              tree-sitter-typescript
              tree-sitter-html
            ]))
            nvim-lspconfig
            nvim-cmp
            vim-vsnip
            vim-vsnip
            cmp-buffer
            cmp-path
            cmp-nvim-lsp
        ];
    };
}
