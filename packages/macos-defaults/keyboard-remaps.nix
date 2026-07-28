{
  # Keyboard remapping configuration, applied via hidutil.
  #
  # hidutil only sets an in-memory HID property, so it doesn't survive
  # reboot/login on its own. A per-user LaunchAgent re-applies it with
  # RunAtLoad so it's active again on every login.
  #
  # HID usage codes are from the USB HID Usage Tables, page 0x07
  # (Keyboard/Keypad), e.g. Caps Lock = 0x39, F12 = 0x45.

  label = "com.rastasheep.dotfiles.keyboard-remap";

  mappings = [
    {
      src = 30064771129; # 0x700000039 - Keyboard Caps Lock
      dst = 30064771141; # 0x700000045 - Keyboard F12
      description = "Remap Caps Lock to F12";
    }
  ];
}
