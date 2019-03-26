# Sets reasonable OS X defaults.
#
# Or, in other words, set shit how I like in OS X.
#
# The original idea (and a couple settings) were grabbed from:
#   https://github.com/mathiasbynens/dotfiles/blob/master/.macos
#
# Run ./defaults.sh and you'll be good to go.

# Enable transparency in the menu bar and elsewhere
defaults write com.apple.universalaccess reduceTransparency -bool false

# Always open everything in Finder's column view. This is important.
defaults write com.apple.Finder FXPreferredViewStyle clmv

# Set a really fast key repeat.
defaults write NSGlobalDomain KeyRepeat -int 1

# Set a really short delay until key repeat.
defaults write NSGlobalDomain InitialKeyRepeat -int 10

# Set the Finder prefs for not showing a volumes on the Desktop.
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false

# Finder: show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Automatically open a new Finder window when a volume is mounted
defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true

# Empty Trash securely by default
defaults write com.apple.finder EmptyTrashSecurely -bool true

# Set $HOME as the default location for new Finder windows
# For other paths, use `PfLo` and `file:///full/path/here/`
defaults write com.apple.finder NewWindowTarget -string "PfDe"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}"

# Set sidebar icon size to small
defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 1

# Set highlight color to green
defaults write NSGlobalDomain AppleHighlightColor -string "0.764700 0.976500 0.568600"

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Menu bar: use dark menu bar and Dock
defaults write .GlobalPreferences AppleInterfaceStyle -string "Dark"

# Menu bar: hide the Time Machine, Volume and User icons
defaults write ~/Library/Preferences/ByHost/com.apple.systemuiserver dontAutoLoad -array \
    "/System/Library/CoreServices/Menu Extras/TimeMachine.menu" \
    "/System/Library/CoreServices/Menu Extras/Volume.menu" \
    "/System/Library/CoreServices/Menu Extras/VPN.menu" \
    "/System/Library/CoreServices/Menu Extras/User.menu"

# Menu bar: show VPN, Keychain, Volume, AirPort, Battery, TextInput and Clock icons
defaults write com.apple.systemuiserver menuExtras -array \
    "/System/Library/CoreServices/Menu Extras/Volume.menu" \
    "/System/Library/CoreServices/Menu Extras/AirPort.menu" \
    "/System/Library/CoreServices/Menu Extras/Battery.menu" \
    "/System/Library/CoreServices/Menu Extras/TextInput.menu" \
    "/System/Library/CoreServices/Menu Extras/Clock.menu"

# Menu bar: set clock format to 24 hour
defaults write com.apple.menuextra.clock "DateFormat" 'EEE HH:mm'

# Trackpad: enable tap to click for this user and for the login screen
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Disable the “Are you sure you want to open this application?” dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Stop iTunes from responding to the keyboard media keys
launchctl unload -w /System/Library/LaunchAgents/com.apple.rcd.plist 2> /dev/null

# Require password immediately after sleep or screen saver begins
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Check for software updates daily, not just once per week
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

# Set the Dock orientation to left
defaults write com.apple.dock orientation -string "left"

# Set the icon size of Dock items to 28 pixels
defaults write com.apple.dock tilesize -int 28

# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true

# Minimize windows into their application’s icon
defaults write com.apple.dock minimize-to-application -bool true

# Don’t show recent applications in Dock
defaults write com.apple.dock show-recents -bool false

# Enable time announcement
defaults write com.apple.speech.synthesis.general.prefs TimeAnnouncementPrefs -dict-add "TimeAnnouncementsEnabled" -bool true

## Announce the time => On the hour
defaults write com.apple.speech.synthesis.general.prefs TimeAnnouncementPrefs -dict-add "TimeAnnouncementsIntervalIdentifier" -string "EveryHourInterval"

permament_dock() {
  defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>$1</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"
}

# Empty the dock
defaults write com.apple.dock persistent-apps -array ''

permament_dock "/Applications/Google Chrome.app/"
permament_dock "/Applications/Google Chrome Canary.app/"
permament_dock "/Applications/Spotify.app/"
permament_dock "/Applications/Alacritty.app/"
permament_dock "/Applications/Slack.app/"

# Disable Dashboard
defaults write com.apple.dashboard mcx-disabled -bool true

# Don’t show Dashboard as a Space
defaults write com.apple.dock dashboard-in-overlay -bool true

# Hide Safari's bookmark bar.
defaults write com.apple.Safari ShowFavoritesBar -bool false

# Set up Safari for development.
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" -bool true
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true
