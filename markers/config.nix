{
  config.datasources.markers = {
    blishhud-community = {
      name = "BlishHUD Community Markers";
      fileName = "Community.markers";
      description = "Markers provided by the community for Commander's Markers.";
      url = "https://github.com/manlaan/BlishHud-CommanderMarkers/tree/bhud-static/Manlaan.CommanderMarkers";
      output.settings = {
        author = "Blish HUD Community";
        display_name = "Community Markers";
      };
      remote.direct = {
        url = "https://bhm.blishhud.com/Manlaan.CommanderMarkers/Community/Markers.json";
        # TODO: https://github.com/manlaan/BlishHud-CommanderMarkers/raw/refs/heads/bhud-static/Manlaan.CommanderMarkers/Community/Markers.json
      };
      versions."latest".hash = null;
    };
    blishhud-cm = {
      name = "BlishHUD Commander's Markers Internal Markers";
      fileName = "Extracted.markers";
      description = "Markers that were embedded into the source code of Blish HUD Commander's Markers.";
      stock.enable = true;
      output.settings = {
        author = "Commander's Markers";
        display_name = "Stock Markers";
      };
      remote.github = {
        owner = "TaimiHUD";
        repo = "CommandersMarkersInternalMarkers";
        archive.enable = true;
      };
      versions."v0.0.1".hash = "sha256-7ZGXXa4tJZfFtQvcGMsX6fuBLZgu0bAkOK+TihnpFwM=";
    };
  };
}
