{ datasourceConfig, config, lib, ... }: let
  mkAlmostOptionDefault = lib.mkOverride 1400;
  inherit (lib.attrsets) mapAttrs;
  inherit (lib.modules) mkDefault mkOptionDefault mkIf;
  inherit (lib.strings) hasPrefix removePrefix;
  inherit (lib.trivial) defaultTo;
  cfg = defaultTo {
    enable = false;
  } datasourceConfig.remote.github or null;
  get = mapAttrs (_: mkDefault) {
    inherit (cfg.get) fetcherFor srcFetcherFor;
  };
in {
  config = {
    fetcher.args = let
      hasRef = cfg.releases.enable || cfg.archive.enable;
    in mkIf cfg.enable {
      versionName = mkIf (hasRef && (hasPrefix "v" config.versionName || hasPrefix "V" config.versionName || builtins.match "[0-9.]*" config.versionName != null)) (mkAlmostOptionDefault (
        removePrefix "V" (
          removePrefix "v" config.versionName
        )
      ));
      ref = mkIf hasRef (mkOptionDefault "refs/tags/${config.versionName}");
    };
    get = mkIf cfg.enable get;
  };
}
