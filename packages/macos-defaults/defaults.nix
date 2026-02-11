{
  # macOS System Defaults Configuration
  # Organized by domain with type annotations and descriptions

  domains = {
    # Global system-wide defaults
    NSGlobalDomain = {
      _HIHideMenuBar = {
        value = 1;
        type = "int";
        description = "Hide menu bar automatically";
      };
      AppleAccentColor = {
        value = 3;
        type = "int";
        description = "Set accent color to green";
      };
      AppleHighlightColor = {
        value = "0.752941 0.964706 0.678431 Green";
        type = "string";
        description = "Set highlight color to green";
      };
      AppleShowAllExtensions = {
        value = true;
        type = "bool";
        description = "Show all filename extensions in Finder";
      };
      InitialKeyRepeat = {
        value = 25;
        type = "int";
        description = "Set initial delay before key repeat";
      };
      KeyRepeat = {
        value = 2;
        type = "int";
        description = "Set key repeat speed";
      };
      KeyRepeatDelay = {
        value = "0.5";
        type = "string";
        description = "Additional key repeat delay configuration";
      };
      KeyRepeatEnabled = {
        value = 1;
        type = "int";
        description = "Enable key repeat";
      };
      KeyRepeatInterval = {
        value = "0.083333333";
        type = "string";
        description = "Key repeat interval";
      };
      AppleEnableMouseSwipeNavigateWithScrolls = {
        value = 1;
        type = "int";
        description = "Enable swipe navigation with scrolling";
      };
      "com.apple.mouse.scaling" = {
        value = 2;
        type = "int";
        description = "Mouse tracking speed";
      };
      NSNavPanelExpandedStateForSaveMode = {
        value = true;
        type = "bool";
        description = "Expand save panel by default";
      };
      NSNavPanelExpandedStateForSaveMode2 = {
        value = true;
        type = "bool";
        description = "Expand save panel by default (alternative)";
      };
      AppleAquaColorVariant = {
        value = 1;
        type = "int";
        description = "Use dark aqua color variant";
      };
      AppleInterfaceStyle = {
        value = "Dark";
        type = "string";
        description = "Use dark interface style";
      };
    };

    # Desktop services (Finder-related)
    "com.apple.desktopservices" = {
      DSDontWriteNetworkStores = {
        value = true;
        type = "bool";
        description = "Don't write .DS_Store files on network volumes";
      };
      DSDontWriteUSBStores = {
        value = true;
        type = "bool";
        description = "Don't write .DS_Store files on USB drives";
      };
    };

    # Menu bar clock
    "com.apple.menuextra.clock" = {
      Show24Hour = {
        value = true;
        type = "bool";
        description = "Use 24-hour clock format";
      };
      ShowDayOfWeek = {
        value = true;
        type = "bool";
        description = "Show day of week in menu bar";
      };
      ShowAMPM = {
        value = true;
        type = "bool";
        description = "Show AM/PM indicator";
      };
      ShowSeconds = {
        value = false;
        type = "bool";
        description = "Don't show seconds in clock";
      };
      ShowDate = {
        value = 0;
        type = "int";
        description = "Don't show date in menu bar";
      };
      FlashDateSeparators = {
        value = false;
        type = "bool";
        description = "Don't flash date separators";
      };
      IsAnalog = {
        value = false;
        type = "bool";
        description = "Use digital clock (not analog)";
      };
    };

    # Dock configuration
    "com.apple.dock" = {
      show-recents = {
        value = false;
        type = "bool";
        description = "Don't show recent applications in Dock";
      };
      orientation = {
        value = "left";
        type = "string";
        description = "Position Dock on left side of screen";
      };
      tilesize = {
        value = 28;
        type = "int";
        description = "Set icon size of Dock items to 28 pixels";
      };
      autohide = {
        value = true;
        type = "bool";
        description = "Automatically hide and show the Dock";
      };
      minimize-to-application = {
        value = true;
        type = "bool";
        description = "Minimize windows into their application's icon";
      };
      autohide-delay = {
        value = 0;
        type = "int";
        description = "Show Dock instantly on hover (no delay)";
      };
      persistent-apps = {
        value = [];
        type = "array";
        description = "Empty the dock (no persistent applications)";
      };
    };

    # Finder configuration
    "com.apple.finder" = {
      FXPreferredViewStyle = {
        value = "clmv";
        type = "string";
        description = "Use column view in Finder";
      };
      FXEnableExtensionChangeWarning = {
        value = false;
        type = "bool";
        description = "Disable warning when changing file extension";
      };
      ShowExternalHardDrivesOnDesktop = {
        value = false;
        type = "bool";
        description = "Don't show external hard drives on desktop";
      };
      ShowRemovableMediaOnDesktop = {
        value = false;
        type = "bool";
        description = "Don't show removable media on desktop";
      };
      OpenWindowForNewRemovableDisk = {
        value = true;
        type = "bool";
        description = "Open Finder window when removable disk is mounted";
      };
      EmptyTrashSecurely = {
        value = true;
        type = "bool";
        description = "Empty Trash securely by default";
      };
      NewWindowTarget = {
        value = "PfDe";
        type = "string";
        description = "Set $HOME as default location for new Finder windows";
      };
      NewWindowTargetPath = {
        value = "file://$HOME";
        type = "string";
        description = "Path for new Finder windows (uses $HOME at runtime)";
      };
      ShowSidebar = {
        value = true;
        type = "bool";
        description = "Show sidebar in Finder";
      };
      SidebarWidth = {
        value = 176;
        type = "int";
        description = "Set sidebar width to 176 pixels";
      };
      ShowStatusBar = {
        value = false;
        type = "bool";
        description = "Don't show status bar in Finder";
      };
      ShowPathbar = {
        value = false;
        type = "bool";
        description = "Don't show path bar in Finder";
      };
      ShowTabView = {
        value = false;
        type = "bool";
        description = "Don't show tab view in Finder";
      };
      ShowToolbar = {
        value = true;
        type = "bool";
        description = "Show toolbar in Finder";
      };
      FXICloudDriveRemovalWarning = {
        value = false;
        type = "bool";
        description = "Disable warning before removing from iCloud Drive";
      };
      _FXSortFoldersFirst = {
        value = true;
        type = "bool";
        description = "Keep folders on top when sorting by name";
      };
    };

    # Time Machine
    "com.apple.TimeMachine" = {
      DoNotOfferNewDisksForBackup = {
        value = true;
        type = "bool";
        description = "Don't prompt to use new disks for Time Machine backup";
      };
    };

    # Mouse settings
    "com.apple.mouse" = {
      tapBehavior = {
        value = true;
        type = "bool";
        description = "Enable tap to click for mouse";
      };
    };

    # Apple Magic Mouse
    "com.apple.AppleMultitouchMouse" = {
      MouseButtonMode = {
        value = "TwoButton";
        type = "string";
        description = "Set mouse to two-button mode";
      };
      MouseOneFingerDoubleTapGesture = {
        value = 1;
        type = "int";
        description = "Enable one finger double tap gesture";
      };
      MouseTwoFingerHorizSwipeGesture = {
        value = 1;
        type = "int";
        description = "Enable two finger horizontal swipe gesture";
      };
      MouseTwoFingerDoubleTapGesture = {
        value = 3;
        type = "int";
        description = "Enable two finger double tap gesture (smart zoom)";
      };
      MouseHorizontalScroll = {
        value = 1;
        type = "int";
        description = "Enable horizontal scroll";
      };
      MouseMomentumScroll = {
        value = 1;
        type = "int";
        description = "Enable momentum scroll";
      };
      MouseVerticalScroll = {
        value = 1;
        type = "int";
        description = "Enable vertical scroll";
      };
      MouseButtonDivision = {
        value = 55;
        type = "int";
        description = "Set mouse button division";
      };
      UserPreferences = {
        value = 1;
        type = "int";
        description = "Enable user preferences";
      };
      version = {
        value = 1;
        type = "int";
        description = "Mouse settings version";
      };
    };

    # Trackpad settings
    "com.apple.driver.AppleBluetoothMultitouch.trackpad" = {
      Clicking = {
        value = true;
        type = "bool";
        description = "Enable tap to click";
      };
      DragLock = {
        value = false;
        type = "bool";
        description = "Disable drag lock";
      };
      Dragging = {
        value = false;
        type = "bool";
        description = "Disable dragging";
      };
      TrackpadCornerSecondaryClick = {
        value = false;
        type = "bool";
        description = "Disable corner secondary click";
      };
      TrackpadFiveFingerPinchGesture = {
        value = 2;
        type = "int";
        description = "Enable five finger pinch gesture";
      };
      TrackpadFourFingerHorizSwipeGesture = {
        value = 2;
        type = "int";
        description = "Enable four finger horizontal swipe gesture";
      };
      TrackpadFourFingerPinchGesture = {
        value = 2;
        type = "int";
        description = "Enable four finger pinch gesture";
      };
      TrackpadFourFingerVertSwipeGesture = {
        value = 2;
        type = "int";
        description = "Enable four finger vertical swipe gesture";
      };
      TrackpadHandResting = {
        value = true;
        type = "bool";
        description = "Enable hand resting on trackpad";
      };
      TrackpadHorizScroll = {
        value = true;
        type = "bool";
        description = "Enable horizontal scroll";
      };
      TrackpadMomentumScroll = {
        value = true;
        type = "bool";
        description = "Enable momentum scroll";
      };
      TrackpadPinch = {
        value = true;
        type = "bool";
        description = "Enable pinch gesture";
      };
      TrackpadRightClick = {
        value = true;
        type = "bool";
        description = "Enable right click";
      };
      TrackpadRotate = {
        value = true;
        type = "bool";
        description = "Enable rotate gesture";
      };
      TrackpadScroll = {
        value = true;
        type = "bool";
        description = "Enable scroll";
      };
      TrackpadThreeFingerDrag = {
        value = false;
        type = "bool";
        description = "Disable three finger drag";
      };
      TrackpadThreeFingerHorizSwipeGesture = {
        value = 2;
        type = "int";
        description = "Enable three finger horizontal swipe gesture";
      };
      TrackpadThreeFingerTapGesture = {
        value = false;
        type = "bool";
        description = "Disable three finger tap gesture";
      };
      TrackpadThreeFingerVertSwipeGesture = {
        value = 2;
        type = "int";
        description = "Enable three finger vertical swipe gesture";
      };
      TrackpadTwoFingerDoubleTapGesture = {
        value = 1;
        type = "int";
        description = "Enable two finger double tap gesture";
      };
      TrackpadTwoFingerFromRightEdgeSwipeGesture = {
        value = 3;
        type = "int";
        description = "Enable two finger swipe from right edge";
      };
      USBMouseStopsTrackpad = {
        value = false;
        type = "bool";
        description = "Don't stop trackpad when USB mouse is connected";
      };
      UserPreferences = {
        value = true;
        type = "bool";
        description = "Enable user preferences";
      };
      version = {
        value = 5;
        type = "int";
        description = "Trackpad settings version";
      };
    };
  };
}
