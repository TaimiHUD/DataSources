{ config, lib, ... }: let
  inherit (lib.options) mkOption mkEnableOption;
  inherit (lib.modules) mkIf mkOptionDefault;
  inherit (lib) types;
  cfg = config.updates.check;
  mkCheckNop = { runCommand }: runCommand "update-check-nop" "touch $out";
in {
  options = {
    updates.check = {
      enable = mkEnableOption "check for updates" // {
        default = true;
      };
      get = mkOption {
        type = types.lazyAttrsOf types.unspecified;
      };
    };
    versions = mkOption {
      type = types.attrsOf (types.submodule [
        ./version.nix
      ]);
    };
  };
  config = {
    updates.check = {
      get = mkIf (!cfg.enable) {
        mkCheck = mkOptionDefault mkCheckNop;
      };
    };
  };
}
