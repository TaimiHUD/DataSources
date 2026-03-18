{
  config.datasources.timers = {
    hero-timers = {
      name = "Hero's Timers";
      fileName = "Hero.Timer.Pack.zip";
      description = "These are timers by QuitarHero created for Charr's Timer Module.";
      stock.enable = true;
      remote.github = {
        owner = "QuitarHero";
        repo = "Hero-Timers";
        releases.enable = true;
      };
      versions = {
        "v1.8.4".hash = null;
        "v1.8.6".hash = "sha256-u/3FAB1IXkTOCb7aVtioA3Oy6/byq3lUiQ85au7ReOA=";
      };
    };
    kittywitch-hero-timers = {
      name = "Kat's fork of Hero's Timers";
      fileName = "Heros-Timer-Pack.zip";
      description = "DEPRECATED. No longer recommended, please switch to QuitarHero's Timers.";
      remote.github = {
        owner = "kittywitch";
        repo = "Hero-Timers";
        releases.enable = true;
      };
      versions."v1.0.1".hash = "sha256-SG2MeYw27Rpcnwecr0tbzqmEPfmIucQhWgucvw+aCf8=";
      output = {
        settings = {
          # this could mean something to someone someday
          deprecated = true;
          author = "Kat";
        };
        # bury it
        sortPrio = 9000;
      };
    };
    sabetha-timers = {
      name = "Sabetha Timers";
      fileName = "Sabetha-Timers";
      description = "This edits the Hero's Timers Sabetha timers to add the Commander's Markers details back into them, while retaining cardinal directions provided.";
      output.settings.author = "QuitarHero, kittywitch, ???";
      remote.github = {
        owner = "kittywitch";
        repo = "Sabetha-Timers";
        #archive.enable = true;
        releases.enable = true;
      };
      versions = let
        versionFileName = { lib, config, datasourceConfig, ... }: {
          config.fileName = lib.mkIf datasourceConfig.remote.github.releases.enable "Sabetha-Timers-${config.versionId}.tar.gz";
        };
      in {
        "0.0.1" = _: {
          imports = [ versionFileName ];
          config.hash = null;
        };
        "0.0.2" = _: {
          imports = [ versionFileName ];
          config.hash = "sha256-uxkVXk2571l70XCqEBU1cjT/cOPEONGP1FAP96SdXLk=";
        };
      };
    };
  };
}
