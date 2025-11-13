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
      versions."v1.8.4".hash = null;
    };
    kittywitch-hero-timers = {
      name = "Kat's fork of Hero's Timers";
      description = "DEPRECATED. No longer recommended, please switch to QuitarHero's Timers.";
      remote.github = {
        owner = "kittywitch";
        repo = "Hero-Timers";
        releases.enable = true;
      };
      versions."v1.0.1".hash = null;
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
        archive.enable = true;
      };
      versions."0.0.1".hash = null;
    };
  };
}
