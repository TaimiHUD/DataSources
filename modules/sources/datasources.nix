{ datasourceModules, config, lib, ... }: let
  inherit (lib.modules) mkOptionDefault;
  inherit (lib.options) mkOption;
  inherit (lib) types;
in {
  imports = [
    datasourceModules.generic.specialargs
  ];
  options = {
    datasources = {
      markers = mkOption {
        type = types.attrsOf (config.special.submoduleType [
          datasourceModules.datasource.default
        ]);
        default = {};
      };
      pathing = mkOption {
        type = types.attrsOf (config.special.submoduleType [
          datasourceModules.datasource.default
        ]);
        default = {};
      };
      timers = mkOption {
        type = types.attrsOf (config.special.submoduleType [
          datasourceModules.datasource.default
        ]);
        default = {};
      };
    };
  };
  config.special.args = {
    sourcesConfig = mkOptionDefault config;
  };
}
