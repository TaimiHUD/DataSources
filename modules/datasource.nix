{ datasourceModules, name, lib, config, ... }: let
  inherit (lib.attrsets) attrNames;
  inherit (lib.lists) sort head;
  inherit (lib.modules) mkIf mkOptionDefault;
  inherit (lib.options) mkOption mkEnableOption;
  inherit (lib.strings) versionAtLeast;
  inherit (lib) types;
in {
  options = {
    name = mkOption {
      type = types.str;
      default = name;
    };
    url = mkOption {
      type = types.nullOr types.str;
      default = null;
    };
    description = mkOption {
      type = types.nullOr types.str;
      default = null;
    };
    fileName = mkOption {
      type = types.nullOr types.str;
      default = null;
    };
    remote = {
    };
    versions = mkOption {
      type = types.attrsOf (config.special.submoduleType datasourceModules.datasource'version.default);
      default = {};
    };
    latest = {
      version = mkOption {
        type = types.nullOr types.str;
      };
      url = mkOption {
        type = types.nullOr types.str;
      };
    };
    output = {
      enable = mkEnableOption "sources.toml output" // {
        default = true;
      };
      sortPrio = mkOption {
        type = types.int;
        default = 100;
      };
      settings = mkOption {
        type = types.attrsOf types.unspecified;
      };
    };
  };
  config = {
    latest = {
      version = let
        # TODO: map to/from versionName since it can be customized to mismatch the attr...
        versions = sort versionAtLeast (attrNames config.versions);
      in mkOptionDefault (
        if config.versions == {} then null else head versions
      );
      url = let
        hasUrl = config.latest.version != null && url != null;
        version = config.versions.${config.latest.version};
        url = version.get.urlFor {} {};
      in mkOptionDefault (if hasUrl then url else null);
    };
    output.settings = {
      name = mkOptionDefault config.name;
      description = mkIf (config.description != null) (mkOptionDefault config.description);
    };
    special.args = {
      datasourceConfig = mkOptionDefault config;
    };
  };
}
