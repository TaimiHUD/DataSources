{ config, datasourceConfig, name, lib, ... }: let
  inherit (lib.attrsets) filterAttrs mapAttrs;
  inherit (lib.customisation) callPackageWith;
  inherit (lib.modules) mkOptionDefault;
  inherit (lib.options) mkOption;
  inherit (lib.trivial) defaultTo functionArgs id;
  inherit (lib) types;
in {
  options = {
    versionName = mkOption {
      type = types.str;
      default = name;
    };
    hash = mkOption {
      type = types.nullOr types.str;
      default = null;
    };
    fileName = mkOption {
      type = types.nullOr types.str;
      default = null;
    };
    fetcher = {
      args = mkOption {
        type = types.attrsOf (types.unspecified);
        default = {};
      };
    };
    get = mkOption {
      type = types.lazyAttrsOf (types.unspecified);
      default = {};
    };
  };
  config = {
    fetcher.args = mapAttrs (_: mkOptionDefault) {
      inherit (config) versionName;
      fileName = defaultTo datasourceConfig.fileName config.fileName;
      hash = defaultTo lib.fakeHash config.hash;
    };
    get = {
      urlFetcherFor = args: let
        fetcherFor = config.get.fetcherFor or null;
        hasFetcher = fetcherFor != null;
        mkFakeArg = _: _: id;
        scope = mapAttrs mkFakeArg (filterAttrs (_: default: !default) (functionArgs fetcherFor)) // {
          fetchurl = builtins.fetchurl;
        } // args;
        callPackage = callPackageWith scope;
        fetcher = callPackage fetcherFor {};
        fetcherArgs' = functionArgs fetcher;
        fetcherArgs = filterAttrs (name: _: fetcherArgs' ? ${name}) config.fetcher.args;
      in args: if hasFetcher then fetcher (fetcherArgs // args) else throw "remote fetcher missing for ${config.versionName}";
      urlFor = {}: args: let
        url = config.get.urlFetcherFor {} args;
      in url.url;
    };
  };
}
