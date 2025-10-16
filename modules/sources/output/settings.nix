{ inputs, config, lib, ... }: let
  inherit (lib.attrsets) mapAttrs attrValues;
  inherit (lib.lists) sort;
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkOption;
  inherit (lib) types;
  cfg = config.output;
  formats = import (inputs.nixpkgs + "/pkgs/pkgs-lib/formats.nix") {
    inherit lib;
    pkgs = {
    };
  };
  format = formats.toml {};
  outputModule = { ... }: {
    freeformType = format.type;
    options = {
      type = mkOption {
        type = types.enum [ "GitHub" "Direct" ];
      };
      #description = mkOption {};
    };
  };
  mkDatasourceOutputs = datasources: let
    datasources'ordered = sort (a: b: a.output.sortPrio < b.output.sortPrio) (attrValues datasources);
  in map mkDatasourceOutput datasources'ordered;
  mkDatasourceOutput = ds: mkIf ds.output.enable ds.output.settings;
  settings = {
    Markers = cfg.settings.markers;
    Pathing = cfg.settings.pathing;
    Timers = cfg.settings.timers;
  } // removeAttrs cfg.settings [ "markers" "pathing" "timers" ];
in {
  options.output = {
    settings = {
      markers = mkOption {
        type = types.listOf (types.submodule [
          outputModule
        ]);
        default = {};
      };
      pathing = mkOption {
        type = types.listOf (types.submodule [
          outputModule
        ]);
        default = {};
      };
      timers = mkOption {
        type = types.listOf (types.submodule [
          outputModule
        ]);
        default = {};
      };
    };
    get.file = mkOption {
      type = types.unspecified;
    };
  };
  config.output = {
    settings = mapAttrs (_: mkDatasourceOutputs) {
      inherit (config.datasources) markers pathing timers;
    };
    get.file = { formats }: (formats.toml {}).generate "sources.toml" settings;
  };
}
