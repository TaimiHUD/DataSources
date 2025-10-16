{
  config.datasources.markers = {
    blishhud-community = {
      name = "BlishHUD Community Markers";
      fileName = "Community.markers";
      description = "These are timers by QuitarHero created for Charr's Timer Module.";
      remote.direct = {
        url = "https://bhm.blishhud.com/Manlaan.CommanderMarkers/Community/Markers.json";
      };
      versions."latest".hash = null;
    };
    blishhud-cm = {
      name = "BlishHUD Commander's Markers Internal Markers";
      fileName = "Extracted.markers";
      description = "This edits the QuitarHero/H";
      remote.direct = {
        url = "https://raw.githubusercontent.com/TaimiHUD/DataSources/refs/heads/main/markers/Extracted.markers";
        archive.enable = true;
      };
      versions."latest".hash = null;
    };
  };
}
