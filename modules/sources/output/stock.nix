{ datasourceModules, config, lib, ... }: let
  inherit (lib.attrsets) mapAttrs filterAttrs;
  inherit (lib.modules) mkOptionDefault;
  inherit (lib.options) mkOption mkEnableOption;
  inherit (lib) types;
  filterStockSources = _: sources: let
    sources' = filterAttrs (_: source: source.stock.enable or false) sources;
  in sources';
  datasourcesProxy = { sourcesConfig, ... }: {
    imports = [
      datasourceModules.generic.specialargs
    ];
    options = {
      datasources = mkOption {
        type = types.attrs;
      };
    };
    config = {
      datasources = mkOptionDefault (mapAttrs filterStockSources {
        inherit (sourcesConfig.datasources) markers pathing timers;
      });
    };
  };
  datasourceModule = { ... }: {
    options.stock = {
      enable = mkEnableOption "stock datasource";
    };
  };
in {
  options = {
    stock = mkOption {
      type = config.special.submoduleType [
        datasourcesProxy
        datasourceModules.sources.output-settings
      ];
      default = {};
    };
    datasources = {
      markers = mkOption {
        type = types.attrsOf (types.submodule [
          datasourceModule
        ]);
      };
      pathing = mkOption {
        type = types.attrsOf (types.submodule [
          datasourceModule
        ]);
      };
      timers = mkOption {
        type = types.attrsOf (types.submodule [
          datasourceModule
        ]);
      };
    };
  };
}
