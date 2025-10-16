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
        github-release-check = callPackage self.lib.github-release-check {};
        updateChecks = let
          inherit (nixlib) mapAttrsToList attrValues concatLists filter makeOverridable removePrefix;
          inherit (self.lib.datasources.config) datasources;
          filterGithubSources = filter (ds: ds.remote.github.enable or false);
          getGithubSources = dss: filterGithubSources (attrValues dss);
          githubSources = concatLists (mapAttrsToList (_: getGithubSources) datasources);
          mkGithubUpdate = ds: makeOverridable legacyPackages.github-release-check {
            pname = ds.name;
            ref = removePrefix "refs/tags/" ds.versions.${toString ds.latest.version}.fetcher.args.ref or "unknown";
            inherit (ds.remote.github) owner repo;
          };
        in map mkGithubUpdate githubSources;
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
        default = let
          inherit (self.datasourceModules) datasource;
        in _: {
          imports = [
            datasource.datasource
            datasource.datasource'manual
            datasource.datasource'direct
            datasource.datasource'github
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
        default = let
          inherit (self.datasourceModules) sources;
        in _: {
          imports = [
            sources.datasources
            sources.output-settings
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
      github-release-check = {
        runCommand
      , curl, jq
      }: {
        pname
      , ref
      , owner
      , repo
      , impure ? toString builtins.currentTime or self.sourceInfo.lastModified
      , outputHashAlgo ? "sha256"
      }: runCommand "${pname}-check-${ref}" {
        inherit pname outputHashAlgo impure ref owner repo;
        outputHash = builtins.hashString outputHashAlgo "${pname}!${ref}!${impure}\n";
        outputHashMode = "flat";
        preferLocalBuild = true;
        allowSubstitutes = false;
        impureEnvVars = nixlib.fetchers.proxyImpureEnvVars ++ [ "NIX_CURL_FLAGS" ];
        nativeBuildInputs = [ curl jq ];
        #queryRelease = "sort_by(.tag_name) | [.[]|select(.prerelease==false and .draft==false)] | .[-1].tag_name";
        queryTag = "sort_by(.name) | .[-1].name";
        queryReleaseLatest = ".tag_name";
        meta.displayName = "${pname} ${ref} outdated";
      } ''
        #RELEASE_URL="https://api.github.com/repos/$owner/$repo/releases"
        RELEASE_URL="https://api.github.com/repos/$owner/$repo/releases/latest"
        TAGS_URL="https://api.github.com/repos/$owner/$repo/tags"
        if REPO_RELEASES=$(curl \
          --insecure \
          -fSsL \
          -H "X-GitHub-Api-Version: 2022-11-28" \
          $NIX_CURL_FLAGS \
          "$RELEASE_URL"
        ); then
          REPO_LATEST=$(jq -r "$queryReleaseLatest" - <<< "$REPO_RELEASES")
        elif REPO_TAGS=$(curl \
          --insecure \
          -fSsL \
          -H "X-GitHub-Api-Version: 2022-11-28" \
          $NIX_CURL_FLAGS \
          "$TAGS_URL"
        ); then
          REPO_LATEST=$(jq -r "$queryTag" - <<< "$REPO_TAGS")
        else
          echo failed to query latest release >&2
          return 1
        fi
        if [[ $REPO_LATEST = $ref ]]; then
          echo "$pname-$ref up-to-date" >&2
        else
          echo "$pname-$ref out of date, found version $REPO_LATEST" >&2
        fi
        printf '%s!%s!%s\n' "$pname" "$REPO_LATEST" "$impure" > $out
      '';
    };
  };
}
