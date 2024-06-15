{ pkgs, misc, ... }: {
  home.username = "rastasheep";
  home.homeDirectory = "/Users/rastasheep";

  home.packages = [
    (pkgs.buildEnv {
      name = "scripts";
      paths = [ ./bin ];
      extraPrefix = "/bin";
    })
    pkgs.blender
    pkgs.arc
    pkgs.kicad
    pkgs.logseq
  ];

  home.shellAliases = {
    "apply-dot" = "cd ~/src/github.com/rastasheep/dotfiles && nix run --impure home-manager/master -- -b bak switch --flake .#rastasheep@aleksandars-mbp";
    "dev-vpn" = "sudo openvpn --config ~/Google\\ Drive/My\\ Drive/fhc-dev-vpn.ovpn";
    "dev" = "source dev";
    "git" = "function _git { [ $# -eq 0 ] && git st || git $* }; compdef _git=git; _git";
  };

  targets.darwin.defaults = {
    NSGlobalDomain = {
      _HIHideMenuBar = 1;
      # Set highlight color to green
      AppleAccentColor = 3;
      AppleHighlightColor = "0.752941 0.964706 0.678431 Green";
      # Finder: show all filename extensions
      AppleShowAllExtensions = true;
      # Set a really short delay until key repeat.
      InitialKeyRepeat = 25;
      # Set a really fast key repeat.
      KeyRepeat = 2;
      KeyRepeatDelay = "0.5";
      KeyRepeatEnabled = 1;
      KeyRepeatInterval = "0.083333333";
      AppleEnableMouseSwipeNavigateWithScrolls = 1;
      com.apple.mouse.scaling = 2;
      # Expand save panel by default
      NSNavPanelExpandedStateForSaveMode = true;
      NSNavPanelExpandedStateForSaveMode2 = true;
      # Menu bar: use dark menu bar and Dock
      AppleAquaColorVariant = 1;
      AppleInterfaceStyle = "Dark";
    };
    "com.apple.desktopservices" = {
      # Don't write .DS_Store files outside macOS
      DSDontWriteNetworkStores = true;
      DSDontWriteUSBStores = true;
    };
    "com.apple.menuextra.clock" = {
      # Set clock format to 24 hour
      Show24Hour = true;
    };
    "com.apple.dock" = {
      # Don't show recent applications in Dock
      show-recents = false;
      # Set the Dock orientation to left
      orientation = "left";
      # Set the icon size of Dock items to 28 pixels
      tilesize = 28;
      # Automatically hide and show the Dock
      autohide = true;
      # Minimize windows into their application’s icon
      minimize-to-application = true;
      # Show Dock instantly on hover
      autohide-delay = 0;
      # Empty the dock
      persistent-apps = [];
    };
    "com.apple.finder" = {
      # Always open everything in Finder's column view. This is important.
      FXPreferredViewStyle = "clmv";
      # Disable the warning when changing a file extension
      FXEnableExtensionChangeWarning = false;
      # Set the Finder prefs for not showing a volumes on the Desktop.
      ShowExternalHardDrivesOnDesktop = false;
      ShowRemovableMediaOnDesktop = false;
      # Automatically open a new Finder window when a volume is mounted
      OpenWindowForNewRemovableDisk = true;
      # Empty Trash securely by default
      EmptyTrashSecurely = true;
      # Set $HOME as the default location for new Finder windows
      # For other paths, use `PfLo` and `file:///full/path/here/`
      NewWindowTarget = "PfDe";
      NewWindowTargetPath = ''file://''${HOME}'';
    };
    "com.apple.TimeMachine" = {
      DoNotOfferNewDisksForBackup = true;
    };
    "com.apple.mouse" = {
      # Trackpad: enable tap to click
      tapBehavior = true;
    };
    "com.apple.AppleMultitouchMouse" = {
      MouseButtonMode = "TwoButton";
      MouseOneFingerDoubleTapGesture = 1;
      MouseTwoFingerHorizSwipeGesture = 1;
    };
    "com.apple.driver.AppleBluetoothMultitouch.trackpad" = {
      Clicking = true;
    };
  };

  programs.git = {
      enable = true;
      userName = "Aleksandar Diklic";
      userEmail = "rastasheep3@gmail.com";
      extraConfig = {
          feature.manyFiles = true;
          init.defaultBranch = "main";
          gpg.format = "ssh";
          push.autoSetupRemote = true;
      };

      signing = {
          key = "";
          signByDefault = builtins.stringLength "" > 0;
      };

      lfs.enable = true;
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
          credit = "!f() { git commit --amend --author \"$1 <$2>\" -C HEAD; }; f";
          unpushed = "!f() { git diff origin/\"$(git rev-parse --abbrev-ref HEAD)\"..HEAD; }; f";
          delete-local-merged = "!f() { git branch -d $(git branch --merged | grep -v '^*' | grep -v 'master' | tr -d '\n'); }; f";
          nuke = "!f() { git branch -D $1 && git push origin :$1; }; f";
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
      set -g status-style bg=default,fg=white

      # highlight active window
      set -g window-status-current-style fg=red,bg=default

      # pane border
      set -g pane-border-style fg=terminal,bg=default
      set -g pane-active-border-style fg=yellow,bg=default

      # message text
      set -g message-style fg=brightred,bg=black

      # pane number display
      set -g display-panes-active-colour blue #blue
      set -g display-panes-colour brightred #orange
      set default-terminal "screen-256color"
    '';
  };

  programs.zsh = {
    enable = true;
    defaultKeymap = "emacs";
    autosuggestion = {
      enable = true;
    };
    history = {
      share = true;
      extended = true;
    };
    sessionVariables = {
      LANG = "en_US.UTF-8";
    };
    initExtraFirst = ''
      if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
        . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
      fi
    '';
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

      eval "$(direnv hook zsh)"
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
        tree-sitter-nix
        tree-sitter-elixir
        tree-sitter-heex
      ]))
      nvim-lspconfig
      nvim-cmp
      vim-vsnip
      vim-vsnip
      cmp-buffer
      cmp-path
      cmp-nvim-lsp
      (pkgs.vimUtils.buildVimPlugin {
        pname = "flexoki-neovim";
        version = "2024-02-07";
        src = pkgs.fetchurl {
          url = "https://github.com/kepano/flexoki-neovim/archive/975654bce67514114db89373539621cff42befb5.tar.gz";
          sha256 = "1y52g0jhp4d1iilb96xm93yq13a7iyr631cxz695jxp9y84j2m9w";
        };
      })
    ];
  };

  programs.vscode = {
    enable = true;
  };
}
