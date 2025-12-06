{ config, lib, ... }: let
  inherit (lib.attrsets) mapAttrs genAttrs;
  inherit (lib.modules) mkDefault mkMerge;
  inherit (config.datasources.pathing) mirrored;
  mirroredTag = "mirrored";
  mirroredRef = "refs/tags/${mirroredTag}";
  mirroredRefTaco = {
    rev = "ddb623fdcd8d50b936637d0e625a5021ab55e8d7";
    hash = "sha256-lo9vChrRNkueB8cFVs8kwzk8xXd5VSrEWB1JYvBOdWw=";
  };
  mkArchiveUrl = fileName: let
    fetcherFor = mirrored.remote.github.get.releaseFetcherFor {
      fetchurl = throw "fetchurl";
    };
    fetcher = fetcherFor {
      #versionName = mirroredTag;
      ref = mirroredRef;
      inherit fileName;
      hash = throw "hash";
    };
  in fetcher.url;
  archivedLatestRelease =
  {
    fileName
  }: let
    settings = {
      direct = {
        type = "Direct";
        url = mkArchiveUrl fileName;
      };
      release = {
        type = "GitHub";
        inherit (mirrored.remote.github) owner;
        repository = mirrored.remote.github.repo;
        # TODO: support this in our fetcher .-.
        ref = mirroredTag;
        releaseFileName = fileName;
      };
    };
  in {
    output = {
      enable = mkDefault true;
      settings = mapAttrs (_: mkDefault) (settings.direct);
    };
  };
  mirrorForSrc =
  { fileName
  , versions
  , sourceDir
  }: let
    mkVersion = versionName: { datasourceConfig, config, ... }: {
      get = mapAttrs (_: mkDefault) {
        fetcherFor = {
          fetchurl
        , fetchFromGitHub
        , runCommand
        , mirrored'fileFetcherFor ? mirrored.remote.github.get.fileFetcherFor { inherit fetchurl fetchFromGitHub runCommand; }
        , ...
        }: _: mirrored'fileFetcherFor {
          name = "${datasourceConfig.name}-${versionName}-${datasourceConfig.fileName}";
          sourceDir = "${sourceDir}/${versionName}";
          inherit fileName;
          inherit (config) hash;
        };
      };
    };
  in {
    versions = genAttrs mkVersion versions;
  };
in {
  config.datasources.pathing = {
    mirrored = {
      name = "DataSources-mirrored";
      url = "https://github.com/TaimiHUD/DataSources-mirrored";
      remote.github = { config, ... }: {
        enable = true;
        owner = "TaimiHUD";
        repo = "DataSources-mirrored";
        releases.enable = true;
        get = {
          fileFetcherFor = {
            fetchFromGitHub
          , fetchurl
          , runCommand
          , datasource'github'srcFetcherFor ? config.get.srcFetcherFor { inherit fetchFromGitHub; }
          , mirrored'fileFetcherFor ? config.get.mirroredFileFetcherFor { inherit runCommand; }
          }: {
            sourceDir
          , fileName
          , name
          , hash
          }: let
            source = datasource'github'srcFetcherFor {
              ref = mirroredRefTaco.rev;
              inherit (mirroredRefTaco) hash;
            };
          in mirrored'fileFetcherFor {
            inherit source name hash;
            sourcePath = "${sourceDir}/${fileName}";
          };
          mirroredFileFetcherFor = {
            runCommand
          }: { name, source, sourcePath, hash }: runCommand name {
            inherit source sourcePath;
            outputHashAlgo = null;
            outputHash = hash;
          } ''
            cp "$source/$sourcePath" "$out"
          '';
        };
      };
      output.enable = false;
    };
    reactif-en = mkMerge [
      (archivedLatestRelease {
        fileName = "reactif-en.taco";
      })
      (mirrorForSrc {
        versions = [ "2024-12-22" "2025-03-01" ];
        fileName = "reactif.en.taco";
        sourceDir = "taco/reactif";
      })
    ];
    reactif-fr = mkMerge [
      (archivedLatestRelease {
        fileName = "reactif-fr.taco";
      })
      (mirrorForSrc {
        versions = [ "2020-11-30" ];
        fileName = "GW2 TacO ReActif FR Externe.taco";
        sourceDir = "taco/reactif";
      })
      (mirrorForSrc {
        versions = [ "2025-03-01" ];
        fileName = "reactif.fr.taco";
        sourceDir = "taco/reactif";
      })
    ];
    tryhard = mkMerge [
      (archivedLatestRelease {
        fileName = "tryhard.taco";
      })
      (mirrorForSrc {
        versions = [ "2018-11-19" ];
        fileName = "Deroirs Tryhard Marker Pack.zip";
        sourceDir = "taco/tryhard";
      })
    ];
    gw2taco = archivedLatestRelease {
      fileName = "TacOMarkers.taco";
    };
  };
}
