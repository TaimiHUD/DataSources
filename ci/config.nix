{ config, pkgs, lib, ... }: with pkgs; with lib; let
  datasources = import ../.;
  legacyPackages = datasources.legacyPackages.${pkgs.system};
  packages = datasources.packages.${pkgs.system};
  artifactRoot = ".ci/artifacts";
  artifacts = "${artifactRoot}/${sourcesTomlPath}";
  release = "${artifactRoot}/${sourcesTomlPath}";
  sourcesTomlPath = "share/taimihud/sources.toml";
  sourcesToml = linkFarm "taimihud-sources.toml" [
    { name = sourcesTomlPath; path = packages.sourcesToml; }
  ];
in
{
  config = {
    name = "taimihud-datasources";
    ci.version = "v0.7";
    ci.gh-actions = {
      enable = true;
      export = true;
    };
    cache.cachix.taimihud = {
      enable = true;
      publicKey = "taimihud.cachix.org-1:2LByDgq5eUVU2FoeIlMd5NMgUeCDXuuVarS+XbNsIkY=";
      signingKey = "nya";
    };
    #channels.nixpkgs.version = "25.05";
    jobs = {
      main = {
        tasks = {
          build.inputs = [ sourcesToml ];
        };
        artifactPackages = {
          sources = sourcesToml;
        };
      };
      updates = {
        tasks = {
          build.inputs = legacyPackages.updateChecks;
        };
      };
    };

    # XXX: symlinks are not followed, see https://github.com/softprops/action-gh-release/issues/182
    artifactPackage = mkIf (config.artifactPackages != {}) (runCommand "taimihud-datasource-artifacts" { } (''
      mkdir -p $out/share
    '' + concatStringsSep "\n" (mapAttrsToList (key: taimi: ''
        cp -Lr --no-preserve=mode -t $out ${taimi}/share
    '') config.artifactPackages)));

    gh-actions = {
      jobs = mkIf (config.id != "ci" && config.artifactPackage != null) {
        ${config.id} = {
          permissions = {
            contents = "write";
          };
          step = {
            artifact-build = {
              order = 1100;
              name = "artifact build";
              uses = {
                # XXX: a very hacky way of getting the runner
                inherit (config.gh-actions.jobs.${config.id}.step.ci-setup.uses) owner repo version;
                path = "actions/nix/build";
              };
              "with" = {
                file = "<ci>";
                attrs = "config.jobs.${config.jobId}.artifactPackage";
                out-link = artifactRoot;
              };
            };
            artifact-upload = {
              order = 1110;
              name = "artifact upload";
              uses.path = "actions/upload-artifact@v4";
              "with" = {
                name = "TaimiHUD-DataSources";
                path = artifacts;
              };
            };
            release-upload = {
              order = 1111;
              name = "release";
              "if" = "startsWith(github.ref, 'refs/tags/')";
              uses.path = "softprops/action-gh-release@v1";
              "with".files = release;
            };
          };
        };
      };
    };
  };
  options = {
    artifactPackage = mkOption {
      type = types.nullOr types.package;
      default = null;
    };
    artifactPackages = mkOption {
      type = with types; attrsOf package;
      default = {};
    };
  };
}
