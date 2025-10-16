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
      remote.direct = {
        url = "https://raw.githubusercontent.com/TaimiHUD/DataSources/refs/heads/main/markers/Extracted.markers";
        archive.enable = true;
      };
      versions."latest".hash = null;
    };
  };
}
