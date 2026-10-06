{ pkgs, ... }:
{
  programs.thunderbird = {
    enable = true;
    profiles.main = {
      isDefault = true;
      settings = {
        "extensions.autoDisableScopes" = 0;
      };
    };
  };
}
