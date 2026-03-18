{
  description = "TaimiHUD remote data";
  inputs = {
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
  };

  outputs = { self, flake-utils, nixpkgs, ... }@inputs: let
    nixlib = nixpkgs.lib;
    mkSystem = system: let
      legacyPackages = self.legacyPackages.${system};
      packages = self.packages.${system};
      inherit (legacyPackages) pkgs callPackage;
    in {
      packages = {
        /* TODO
        packs = callPackage ./pathing/taco/derivation.nix {
          datasources = self;
        };*/
        sourcesToml = callPackage self.lib.datasources.config.output.get.file {};
        stockSourcesToml = callPackage self.lib.datasources.config.stock.output.get.file {};

        default = packages.sourcesToml;
      };

      legacyPackages = {
        pkgs = nixpkgs.legacyPackages.${system} or (import nixpkgs {
          inherit system;
        });
        callPackage = pkgs.newScope {
          datasources = self;
          inherit (packages) packs sources;
        };
        datasourceSrcs = let
          inherit (nixlib) filterAttrs mapAttrs;
          inherit (self.lib.datasources.config) datasources;
          mkDatasources = _: datasources: let
            availDatasources = filterAttrs (_: ds: /*ds.enable or*/ true) datasources;
            mkVersionSrc = _: v: callPackage v.get.fetcher {} {};
            mkSrc = _: ds: let
              forVersion = mapAttrs mkVersionSrc ds.versions;
            in forVersion."${toString ds.latest.version}" or {} // {
              inherit forVersion;
            };
          in mapAttrs mkSrc availDatasources;
        in mapAttrs mkDatasources datasources;
        updateChecks = let
          inherit (nixlib) mapAttrsToList attrValues concatLists filter;
          inherit (self.lib.datasources.config) datasources;
          filterUpdateSources = filter (ds: ds.updates.check.enable or false);
          getUpdateSources = dss: filterUpdateSources (attrValues dss);
          updateSources = concatLists (mapAttrsToList (_: getUpdateSources) datasources);
          mkUpdateCheck = ds: callPackage ds.updates.check.get.mkCheck {};
        in map mkUpdateCheck updateSources;
        allUpdateChecks = let
          mkUpdateLink = up: {
            inherit (up) name;
            path = up;
          };
          allUpdateChecks = {
            updateChecks
          , linkFarm
          }: linkFarm "taimihud-update-checks" (map mkUpdateLink updateChecks);
        in callPackage allUpdateChecks {
          inherit (legacyPackages) updateChecks;
        };
      };
    };
    systems = flake-utils.lib.eachDefaultSystem mkSystem;
  in {
    inherit (systems) legacyPackages packages;
    datasourceModules = {
      datasource = {
        datasource = ./modules/datasource.nix;
        datasource'manual = ./modules/manual/datasource.nix;
        datasource'direct = ./modules/direct/datasource.nix;
        datasource'github = ./modules/github/datasource.nix;
        datasource'updates = ./modules/updates/datasource.nix;
        default = let
          inherit (self.datasourceModules) datasource;
        in _: {
          imports = [
            datasource.datasource
            datasource.datasource'manual
            datasource.datasource'direct
            datasource.datasource'github
            datasource.datasource'updates
          ];
        };
      };
      datasource'version = {
        version = ./modules/version.nix;
        default = let
          inherit (self.datasourceModules) datasource'version;
        in _: {
          imports = [
            datasource'version.version
          ];
        };
      };
      datasource'remote = {
        datasource'manual'remote = ./modules/manual/remotesource.nix;
        datasource'direct'remote = ./modules/direct/remotesource.nix;
        datasource'github'remote = ./modules/github/remotesource.nix;
      };
      sources = {
        datasources = ./modules/sources/datasources.nix;
        output-settings = ./modules/sources/output/settings.nix;
        stock = ./modules/sources/output/stock.nix;
        default = let
          inherit (self.datasourceModules) sources;
        in _: {
          imports = [
            sources.datasources
            sources.output-settings
            sources.stock
          ];
        };
      };
      generic = {
        specialargs = ./modules/specialargs.nix;
      };
      config = {
        config = ./config.nix;
        pathing = ./pathing/config.nix;
        timers = ./timers/config.nix;
        markers = ./markers/config.nix;
        default = let
          inherit (self.datasourceModules) config;
        in _: {
          imports = [
            config.config
            config.pathing
            config.timers
            config.markers
          ];
        };
      };
    };
    lib = {
      datasources = nixlib.evalModules {
        modules = [
          self.datasourceModules.sources.default
          self.datasourceModules.config.default
        ];
        specialArgs = {
          inherit (self) datasourceModules;
          inherit inputs;
        };
      };
    };
  };
}
