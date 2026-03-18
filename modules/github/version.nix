{ datasourceConfig, config, lib, ... }: let
  mkAlmostOptionDefault = lib.mkOverride 1400;
  inherit (lib.attrsets) mapAttrs;
  inherit (lib.modules) mkDefault mkOptionDefault mkIf;
  inherit (lib.strings) hasPrefix removePrefix;
  inherit (lib.trivial) setFunctionArgs functionArgs defaultTo;
  cfg = defaultTo {
    enable = false;
  } datasourceConfig.remote.github or null;
  get = mapAttrs (_: mkDefault) {
    inherit (cfg.get) fetcherFor srcFetcherFor updateCheckFor;
    updateCheck = let
      f = args: config.get.updateCheckFor args {
        ${if config.fetcher.args.versionName or null != null then "versionName" else null} = config.fetcher.args.versionName;
        ${if config.fetcher.args.ref != null then "ref" else null} = config.fetcher.args.ref;
      };
    in setFunctionArgs f (functionArgs cfg.get.updateCheckFor);
  };
  hasRef = cfg.releases.enable || cfg.archive.enable;
in {
  config = {
    versionName = mkIf (cfg.enable && hasRef && (hasPrefix "v" config.versionId || hasPrefix "V" config.versionId || builtins.match "[0-9.]*" config.versionId != null)) (mkAlmostOptionDefault (
      removePrefix "V" (
        removePrefix "v" config.versionId
      )
    ));
    fetcher.args = mkIf cfg.enable {
      ref = mkIf hasRef (mkOptionDefault "refs/tags/${config.fetcher.args.versionName}");
    };
    get = mkIf cfg.enable get;
  };
}
