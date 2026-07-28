{ pkgs }:

# Helpers for turning a declarative keyboard remap config into the payload
# hidutil expects and a LaunchAgent plist that re-applies it at login.

{
  # Builds the hidutil UserKeyMapping JSON payload from a list of
  # { src, dst, ... } mappings.
  buildUserKeyMappingJson = mappings:
    builtins.toJSON {
      UserKeyMapping = map (m: {
        HIDKeyboardModifierMappingSrc = m.src;
        HIDKeyboardModifierMappingDst = m.dst;
      }) mappings;
    };

  # Builds a per-user LaunchAgent plist that runs
  # `hidutil property --set <userKeyMappingJson>` with RunAtLoad.
  buildLaunchAgentPlist = { label, userKeyMappingJson }:
    ''
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>${label}</string>
        <key>ProgramArguments</key>
        <array>
          <string>/usr/bin/hidutil</string>
          <string>property</string>
          <string>--set</string>
          <string>${userKeyMappingJson}</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
      </dict>
      </plist>
    '';
}
