{ config, datasourceConfig, lib, ... }: let
  inherit (lib.options) mkOption mkEnableOption;
  inherit (lib.trivial) defaultTo;
  inherit (lib) types;
in {
  options = {
    enable = mkEnableOption "manual remote source" // {
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
        requireFile
      }: {
        extraArgs ? {}
      , hash
      , versionName ? null
      , fileName ? null
      , ...
      }@args: let
        inherit (config) url;
        fileName' = defaultTo datasourceConfig.fileName args.fileName or null;
        fileName = defaultTo (builtins.baseNameOf config.url) fileName';
      in {
        inherit url hash versionName fileName extraArgs;
        __toString = self: let
          message = ''
            ${self.fileName} must be downloaded manually.
            Please visit ${self.url} to download manually, and add to the store:
              nix-store --add-fixed sha256 ${self.fileName}
          '';
        in requireFile ({
          name = self.fileName;
          inherit (self) url hash;
          inherit message;
        } // self.extraArgs);
      };
      srcFetcherFor = {}: args: let
        fetcher = config.get.fetcherFor args;
      in fetcher.__toString fetcher;
    };
  };
}
