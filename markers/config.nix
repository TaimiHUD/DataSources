{
  config.datasources.markers = {
    blishhud-community = {
      name = "BlishHUD Community Markers";
      fileName = "Community.markers";
      description = "Markers provided by the community for BlishHUD's Commander's Markers.";
      remote.direct = {
        url = "https://bhm.blishhud.com/Manlaan.CommanderMarkers/Community/Markers.json";
      };
      versions."latest".hash = null;
    };
    blishhud-cm = {
      name = "BlishHUD Commander's Markers Internal Markers";
      fileName = "Extracted.markers";
      description = "Markers that were embedded into the source code of BlishHUD's Commander's Markers.";
      remote.github = {
        owner = "TaimiHUD";
        repo = "CommandersMarkersInternalMarkers";
        archive.enable = true;
      };
      versions."0.0.1".hash = null;
    };
  };
}
