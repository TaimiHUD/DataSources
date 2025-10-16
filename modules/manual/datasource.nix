{ config, lib, ... }: let
  mkAlmostOptionDefault = lib.mkOverride 1400;
  inherit (lib.options) mkOption;
  inherit (lib.modules) mkIf;
  inherit (lib) types;
  cfg = config.remote.manual;
in {
  options = {
    remote.manual = mkOption {
      type = types.nullOr (config.special.submoduleType [
        ./remotesource.nix
      ]);
      default = null;
    };
    versions = mkOption {
      type = types.attrsOf (types.submodule [
        ./version.nix
      ]);
    };
  };
  config = mkIf cfg.enable or false {
    output.enable = mkAlmostOptionDefault false;
    url = mkAlmostOptionDefault cfg.url;
  };
}
