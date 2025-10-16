{ config, lib, ... }: let
  inherit (lib.options) mkOption mkEnableOption;
  inherit (lib.strings) nameFromURL removePrefix;
  inherit (lib) types;
  getFileExt = getFileSuffix ".";
  getFileSuffix = sep: filename: let
    inherit (lib.lists) last length;
  inherit (lib.strings) splitString;
    components = splitString sep filename;
  in if length components <= 1 then "" else "${sep}${last components}";
in {
  options = {
    enable = mkEnableOption "github remote source" // {
      default = true;
    };
    owner = mkOption {
      type = types.str;
    };
    repo = mkOption {
      type = types.str;
    };
    releases = {
      enable = mkEnableOption "github release downloads";
    };
    archive = {
      enable = mkEnableOption "archive download";
      format = mkOption {
        type = types.enum [ "tar.gz" "zip" ];
        default = "tar.gz";
      };
    };
    sourceFile = {
      path = mkOption {
        type = types.nullOr types.str;
        default = null;
      };
    };
    get = mkOption {
      type = types.lazyAttrsOf (types.unspecified);
    };
  };
  config = {
    get = {
      fetcherFor = {
        fetchurl
      , fetchFromGitHub
      , datasource'github'releaseFetcherFor ? config.get.releaseFetcherFor { inherit fetchurl; }
      , datasource'github'archiveFetcherFor ? config.get.archiveFetcherFor { inherit fetchurl; }
      , datasource'github'fileFetcherFor ? config.get.fileFetcherFor { inherit fetchurl; }
      , datasource'github'srcFetcherFor ? config.get.srcFetcherFor { inherit fetchFromGitHub; }
      }: {
        versionName ? null
      , fileName ? null
      , ref ? if versionName != null then "refs/tags/${versionName}" else throw "ref or versionName required"
      , hash ? lib.fakeHash
      , ...
      }@args: let
        args' = {
          inherit hash ref;
        } // args;
      in 
        if config.releases.enable then datasource'github'releaseFetcherFor args'
        else if config.archive.enable then datasource'github'archiveFetcherFor args'
        else if config.sourceFile.path != null then datasource'github'fileFetcherFor args'
        else datasource'github'srcFetcherFor args';
      releaseFetcherFor = {
        fetchurl
      }: {
        extraArgs ? {}
      , hash
      , ref
      , fileName
      , versionName ? removePrefix "refs/tags/" ref
      }: let
        url = "https://github.com/${config.owner}/${config.repo}/releases/download/${versionName}/${fileName}";
      in {
        inherit url hash ref versionName extraArgs fileName;
        __toString = self: fetchurl ({
          name = "${nameFromURL self.url "."}-${self.versionName}${getFileExt self.url}";
          inherit (self) url hash;
        } // self.extraArgs);
      };
      fileFetcherFor = {
        fetchurl
      }: _: throw "TODO: github.get.fileFetcherFor";
      archiveFetcherFor = {
        fetchurl
      }: {
        extraArgs ? {}
      , hash
      , ref
      , ...
      }: let
        url = "https://github.com/${config.owner}/${config.repo}/archive/${ref}.${config.archive.format}";
      in {
        inherit url hash ref extraArgs;
        __toString = self: fetchurl ({
          inherit (self) url hash;
        } // self.extraArgs);
      };
      srcFetcherFor = {
        fetchFromGitHub
      }: {
        extraArgs ? {}
      , hash
      , ref
      , ...
      }: let
        fetchArgs = ({
          inherit (config) owner repo;
          inherit hash;
          rev = ref;
        } // extraArgs);
      in fetchFromGitHub fetchArgs;
    };
  };
}
