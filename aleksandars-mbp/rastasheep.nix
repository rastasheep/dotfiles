{ pkgs, misc, ... }: {
  home.username = "rastasheep";
  home.homeDirectory = "/Users/rastasheep";

  home.packages = [
    (pkgs.buildEnv {
      name = "scripts";
      paths = [ ./bin ];
      extraPrefix = "/bin";
    })
    # pkgs.blender
    # pkgs.kicad
    pkgs.hammerspoon
    pkgs.claude-code
    pkgs._1password-cli
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
      # Show day of week in menu bar
      ShowDayOfWeek = true;
      # Show AM/PM indicator
      ShowAMPM = true;
      # Don't show seconds
      ShowSeconds = false;
      # Don't show date
      ShowDate = 0;
      # Don't flash date separators
      FlashDateSeparators = false;
      # Use digital clock (not analog)
      IsAnalog = false;
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
      # Show sidebar
      ShowSidebar = true;
      # Set sidebar width
      SidebarWidth = 176;
      # Show status bar
      ShowStatusBar = false;
      # Show path bar
      ShowPathbar = false;
      # Show tab view
      ShowTabView = false;
      # Show toolbar
      ShowToolbar = true;
      # Disable warning before removing from iCloud Drive
      FXICloudDriveRemovalWarning = false;
      # Keep folders on top when sorting by name
      _FXSortFoldersFirst = true;
    };
    "com.apple.TimeMachine" = {
      DoNotOfferNewDisksForBackup = true;
    };
    "com.apple.mouse" = {
      # Trackpad: enable tap to click
      tapBehavior = true;
    };
    "com.apple.AppleMultitouchMouse" = {
      # Set mouse to two-button mode
      MouseButtonMode = "TwoButton";
      # Enable one finger double tap gesture
      MouseOneFingerDoubleTapGesture = 1;
      # Enable two finger horizontal swipe gesture
      MouseTwoFingerHorizSwipeGesture = 1;
      # Enable two finger double tap gesture (smart zoom)
      MouseTwoFingerDoubleTapGesture = 3;
      # Enable horizontal scroll
      MouseHorizontalScroll = 1;
      # Enable momentum scroll
      MouseMomentumScroll = 1;
      # Enable vertical scroll
      MouseVerticalScroll = 1;
      # Set mouse button division
      MouseButtonDivision = 55;
      # Enable user preferences
      UserPreferences = 1;
      # Set version
      version = 1;
    };
    "com.apple.driver.AppleBluetoothMultitouch.trackpad" = {
      # Enable tap to click
      Clicking = true;
      # Disable drag lock
      DragLock = false;
      # Disable dragging
      Dragging = false;
      # Disable corner secondary click
      TrackpadCornerSecondaryClick = false;
      # Enable five finger pinch gesture
      TrackpadFiveFingerPinchGesture = 2;
      # Enable four finger horizontal swipe gesture
      TrackpadFourFingerHorizSwipeGesture = 2;
      # Enable four finger pinch gesture
      TrackpadFourFingerPinchGesture = 2;
      # Enable four finger vertical swipe gesture
      TrackpadFourFingerVertSwipeGesture = 2;
      # Enable hand resting
      TrackpadHandResting = true;
      # Enable horizontal scroll
      TrackpadHorizScroll = true;
      # Enable momentum scroll
      TrackpadMomentumScroll = true;
      # Enable pinch gesture
      TrackpadPinch = true;
      # Enable right click
      TrackpadRightClick = true;
      # Enable rotate gesture
      TrackpadRotate = true;
      # Enable scroll
      TrackpadScroll = true;
      # Disable three finger drag
      TrackpadThreeFingerDrag = false;
      # Enable three finger horizontal swipe gesture
      TrackpadThreeFingerHorizSwipeGesture = 2;
      # Disable three finger tap gesture
      TrackpadThreeFingerTapGesture = false;
      # Enable three finger vertical swipe gesture
      TrackpadThreeFingerVertSwipeGesture = 2;
      # Enable two finger double tap gesture
      TrackpadTwoFingerDoubleTapGesture = 1;
      # Enable two finger swipe from right edge
      TrackpadTwoFingerFromRightEdgeSwipeGesture = 3;
      # Don't stop trackpad when USB mouse is connected
      USBMouseStopsTrackpad = false;
      # Enable user preferences
      UserPreferences = true;
      # Set version
      version = 5;
    };
  };

  programs.git = {
      enable = true;

      lfs.enable = true;
      ignores = ["*~" "*.swp" ".DS_Store"];

      settings = {
          user = {
              name = "Aleksandar Diklic";
              email = "rastasheep3@gmail.com";
          };

          feature.manyFiles = true;
          init.defaultBranch = "main";
          push.autoSetupRemote = true;
          pull.rebase = true;
          fetch.prune = true;
          diff.algorithm = "histogram";
          merge.conflictstyle = "zdiff3";
          rerere.enabled = true;

          alias = {
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
              delete-local-merged = "!git branch --merged | grep -v '^*' | grep -v 'master' | grep -v 'main' | xargs -r git branch -d";
              nuke = "!f() { git branch -D $1 && git push origin :$1; }; f";
          };
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
    terminal = "xterm-256color";
    mouse = true;
    sensibleOnTop = false;

    extraConfig = ''
      set -ga terminal-overrides ",*256col*:Tc"
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
    initContent = pkgs.lib.mkMerge [
      (pkgs.lib.mkBefore ''
        if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
          . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
        fi
      '')
      ''
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

      eval "$(direnv hook zsh)"
      ''
    ];
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = false;
      format = "$directory$git_branch$git_status$character";

      git_branch = {
        format = " [$branch]($style)";
        symbol = "";
      };
    };
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
      fzf-lua # fuzzy find everything
      gitsigns-nvim # git signs
      # syntax
      (nvim-treesitter.withPlugins (p: with p; [
        tree-sitter-lua
        tree-sitter-javascript
        tree-sitter-typescript
        tree-sitter-html
        tree-sitter-nix
        tree-sitter-elixir
        tree-sitter-heex
      ]))
      # color scheme
      (pkgs.vimUtils.buildVimPlugin {
        pname = "flexoki-neovim";
        version = "2025-08-26";
        src = pkgs.fetchurl {
          url = "https://github.com/kepano/flexoki-neovim/archive/c3e2251e813d29d885a7cbbe9808a7af234d845d.tar.gz";
          sha256 = "sha256-ere25TqoPfyc2/6yQKZgAQhJXz1wxtI/VZj/0LGMwNw=";
        };
      })
    ];
  };

  home.file = {
    ".claude/commands".source = ./claude/commands;
    ".claude/settings.json".source = ./claude/settings.json;
    ".hammerspoon/init.lua".source = ./hammerspoon/init.lua;
    ".hammerspoon/leaderflow.lua".source = ./hammerspoon/leaderflow.lua;
  };
}
