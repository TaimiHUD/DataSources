{ config, lib, ... }: let
  inherit (lib.options) mkOption mkEnableOption;
  inherit (lib.strings) nameFromURL;
  inherit (lib.trivial) defaultTo mapNullable;
  inherit (lib) types;
  getFileExt = getFileSuffix ".";
  getFileSuffix = sep: filename: let
    inherit (lib.lists) last length;
  inherit (lib.strings) splitString;
    components = splitString sep filename;
  in if length components <= 1 then "" else "${sep}${last components}";
in {
  options = {
    enable = mkEnableOption "URL remote source" // {
      default = true;
    };
    url = mkOption {
      type = types.str;
    };
    get = mkOption {
      type = types.lazyAttrsOf (types.unspecified);
    };
  };
  config = {
    get = {
      fetcherFor = {
        fetchurl
      }: {
        extraArgs ? {}
      , hash
      , versionName ? null
      , fileName ? null
      , ...
      }: let
        inherit (config) url;
      in {
        inherit url hash versionName fileName extraArgs;
        __toString = self: let
          fileName = defaultTo (builtins.baseNameOf self.url) self.fileName or null;
        in fetchurl ({
          ${mapNullable (_: "name") self.versionName} = "${nameFromURL fileName "."}-${self.versionName}${getFileExt fileName}";
          inherit (self) url hash;
        } // self.extraArgs);
      };
      srcFetcherFor = {}: args: let
        fetcher = config.get.fetcherFor args;
      in fetcher.__toString fetcher;
    };
  };
}
