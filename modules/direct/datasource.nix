{ config, lib, ... }: let
  mkAlmostOptionDefault = lib.mkOverride 1400;
  inherit (lib.attrsets) mapAttrs;
  inherit (lib.options) mkOption;
  inherit (lib.modules) mkIf;
  inherit (lib) types;
  cfg = config.remote.direct;
in {
  options = {
    remote.direct = mkOption {
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
    output.settings = mapAttrs (_: mkAlmostOptionDefault) {
      type = "Direct";
      inherit (cfg) url;
    };
    url = mkAlmostOptionDefault cfg.url;
  };
}
