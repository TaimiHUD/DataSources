{ config, lib, ... }: let
  mkAlmostOptionDefault = lib.mkOverride 1400;
  inherit (lib.attrsets) mapAttrs;
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkOption;
  inherit (lib.strings) replaceStrings;
  inherit (lib) types;
  cfg = config.remote.github;
in {
  options = {
    remote.github = mkOption {
      type = types.nullOr (config.special.submoduleType [
        ./remotesource.nix
      ]);
      default = null;
    };
    versions = mkOption {
      type = types.attrsOf (types.submodule [
        ./version.nix
      ]);
    };
  };
  config = mkIf cfg.enable or false {
    latest.url = let
      urlFor = cfg.get.fetcherFor {
        fetchurl = lib.id;
        fetchFromGitHub = lib.id;
      } {
        ref = "latest";
        versionName = "latest";
        inherit (config) fileName;
      };
      hasGithubUrl = cfg.releases.enable or false;
      url = replaceStrings [ "/releases/download/latest/" ] [ "/releases/latest/download/" ] urlFor.url;
    in mkIf hasGithubUrl (mkAlmostOptionDefault url);
    output.settings = mapAttrs (_: mkAlmostOptionDefault) {
      type = "GitHub";
      inherit (cfg) owner;
      repository = cfg.repo;
    };
    url = mkAlmostOptionDefault "https://github.com/${cfg.owner}/${cfg.repo}";
  };
}
