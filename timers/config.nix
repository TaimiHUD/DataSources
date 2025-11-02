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
    sabetha-timers = {
      name = "Sabetha Timers";
      fileName = "Sabetha-Timers";
      description = "This edits the QuitarHero/Hero-Timers Sabetha timers to add the Commander's Markers details back into them, while retaining cardinal directions provided.";
      remote.github = {
        owner = "kittywitch";
        repo = "Sabetha-Timers";
        archive.enable = true;
      };
      versions."0.0.1".hash = null;
    };
  };
}
