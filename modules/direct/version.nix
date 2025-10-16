{ datasourceConfig, lib, ... }: let
  inherit (lib.attrsets) mapAttrs;
  inherit (lib.modules) mkDefault mkIf;
  inherit (lib.trivial) defaultTo;
  cfg = defaultTo {
    enable = false;
  } datasourceConfig.remote.direct or null;
  get = mapAttrs (_: mkDefault) {
    inherit (cfg.get) fetcherFor srcFetcherFor;
  };
in {
  config = {
    get = mkIf cfg.enable get;
  };
}
