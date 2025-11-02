{
  config.datasources.pathing = {
    tehs-trails = {
      name = "Teh's Trails - Map Completion";
      fileName = "TehsTrails.taco";
      description = "A collection of xTeh.7146's marker packs.";
      stock.enable = true;
      remote.github = {
        owner = "xrandox";
        repo = "TehsTrails";
        releases.enable = true;
      };
      versions."v5.2.0".hash = "sha256-uY+lolPEnR7QbcexpU9wzpy5CfVXFeQaxzLsZBp+tSo=";
      output.sortPrio = 10;
    };
    tehs-trails-hp = {
      name = "Teh's Trails - Hero Points";
      description = "A collection of xTeh.7146's marker packs. This pack contains trails for speed-completing Hero Points either solo or in small groups.";
      fileName = "TehsTrails-HeroPoints.taco";
      remote.github = {
        owner = "xrandox";
        repo = "TehsTrails-HeroPoints";
        releases.enable = true;
      };
      versions."v1.0".hash = "sha256-hbdUuFNlr+5FFQG4wqQhm1/JMJ/CQP34mE9VR0Ztafg=";
      output.sortPrio = 10;
    };
    turtlepoint = {
      name = "TurtlePoint";
      fileName = "TurtlePoint.taco";
      remote.github = {
        owner = "AsherGlick";
        repo = "TurtlePoint";
        releases.enable = true;
      };
      versions = {
        "1.0".hash = "sha256-HmjH8BMbFtkidxpfwYA9rO6mA7hnv31qbMQXK9RywWY=";
        "2.0".hash = null;
      };
    };
    moar = {
      name = "MOAR Marker Pack [BETA]";
      url = "https://www.moarloot.com/markers";
      fileName = "moar.taco";
      remote.direct.url = "https://moar-loot.web.app/releases/moar.taco";
      versions."2022-09-27".hash = "sha256-cf2DpX6NxCBilKZpdWOK+UkU2k+ASknE4TcycgpZAsw=";
    };
    race-beetle-tracks = {
      name = "RACE-Beetle-Racing-Tracks";
      fileName = "RACE_BeetleTracks.taco";
      remote.github = {
        owner = "Garfried";
        repo = "RACE-Beetle-Racing-Tracks";
        releases.enable = true;
      };
      versions."v1.0".hash = "sha256-WIDIkAOc8cccUVgSLlT3He5hdJOawLN6O3Co2Pj4gis=";
    };
    czokalapik = {
      name = "Czokalapik's Guides for GW2Taco";
      fileName = "Czokalapik-s-Guides-for-GW2Taco.taco";
      remote.github = {
        owner = "czokalapik";
        repo = "Czokalapik-s-Guides-for-GW2Taco";
        releases.enable = true;
      };
      versions."v1.0.0".hash = "sha256-tTaHk97mbxgf2HWcxP+4hbk+VzvQDP4BI62HOJFKqLI=";
    };
    emysmarkers = {
      #name = "Emythiel's GW2 Markers";
      name = "Emythiel's HoT HP Marker Pack";
      fileName = "emysmarkers.zip";
      remote.github = {
        owner = "Emythiel";
        repo = "gw2-blish-markers";
        releases.enable = true;
      };
      versions."v1.0.6".hash = "sha256-tO2ONztLeFIbThkXyr1z1vKwhKioSJdVFaDp3gIB+VY=";
    };
    floochs-friendly = {
      name = "Flooch's Friendly Collection Routes";
      fileName = "ffcr.taco";
      remote.github = {
        owner = "placeholderwastakentwice";
        repo = "flooch-friendly-collection-routes";
        releases.enable = true;
      };
      versions."V3".hash = "sha256-/KINq3fur93I4g8TBu0SUDvJiiBrXGdgVwrYT/xjye0=";
    };
    heart-zones = {
      name = "Heart Zones";
      fileName = "HeartZones.taco";
      remote.github = {
        owner = "dlamkins";
        repo = "heart-zones";
        releases.enable = true;
      };
      versions."3.0.0".hash = "sha256-nFo0l8iRQp38yA1WKb+Ryl4nd2kC3AeNdcaqCvqYHko=";
    };
    heros-markers = {
      name = "Hero's Pack";
      fileName = "Hero.Blish.Pack.zip";
      remote.github = {
        owner = "QuitarHero";
        repo = "Heros-Marker-Pack";
        releases.enable = true;
      };
      versions = {
        "v2.7.6".hash = "sha256-AxkRx+YxMpb8/IFrGBQrYiFZHkRvokD3OimY1CzBx3c=";
        "v2.7.10.2".hash = null;
      };
      # TODO? some POIs may need mapid assigned, only mentioned in xml comments...
    };
    heroine-darks-guides = {
      name = "HeroineDark's Super Adventure Box Guide";
      fileName = "HeroineDark_SAB_Guides.taco";
      remote.github = {
        owner = "HeroineDark";
        repo = "HeroineDarks-Super-Adventure-Box-Guide";
        sourceFile.path = "HeroineDark SAB Guides.taco"; # the zip is committed directly to repo
        releases.enable = true; # but there's also a release so...
      };
      versions."v3.1.12.69".hash = "sha256-QalAd/Ct94DgeWaJHlHYqwB7GOjz+JFiCNpIDGXiKws=";
    };
    japyx-trails = {
      name = "JapyxTrails";
      fileName = "JapyxTrails.taco";
      remote.github = {
        owner = "OlivierCharton";
        repo = "JapyxTrails";
        releases.enable = true;
      };
      versions."1.5".hash = "sha256-AGtYxIepDVau3j8PLWnF2vzVvGBIwHZz8fqtyUoQIsg=";
    };
    lady-elyssa = {
      name = "Lady Elyssa's Guides";
      fileName = "LadyElyssa.taco";
      remote.github = {
        owner = "LadyElyssa";
        repo = "LadyElyssaTacoTrails";
        releases.enable = true;
      };
      versions = {
        "v20.5.1".hash = "sha256-kNqfXQxYECwdrFOcY6xZbPKhuMn/22Xnmf2P3nrMuIY=";
        "v21.6".hash = null;
      };
    };
    masmer-fractal-skips = {
      name = "Mesmer Fractal Skips";
      fileName = "MesmerFractalSkips.taco";
      remote.github = {
        owner = "Kaedalus";
        repo = "Mesmer-Fractal-Skips";
        releases.enable = true;
      };
      versions."v1.0.2".hash = "sha256-s4sye9rL8C28kRAJXClaahMPVU009s/1UDogjDQlQeA=";
    };
    metal-marker-myriad = {
      name = "Metal Marker Myriad";
      fileName = "Metal-Marker-Myriad.taco";
      remote.github = {
        owner = "Metallis";
        repo = "Metal-Marker-Myriad";
        releases.enable = true;
      };
      versions = {
        "v10.2.1".hash = "sha256-UtaHxBT5M7J8D4BxV/REfJhfKfv3A7j9ctd6vMWLGfE=";
        "v11.0".hash = null;
      };
      # TODO: fix inconsistent casing: <overlaydata></OverlayData>
    };
    nekres-hoard-lost-forgotten = {
      name = "Nekres' Hoard of Lost 'n Forgotten Markers";
      fileName = "Nekres.Markers.taco";
      remote.github = {
        owner = "agaertner";
        repo = "bhud-markers";
        releases.enable = true;
      };
      versions."v0.1.4".hash = "sha256-DWusttMHOYWycJ9glsz0QrbbNBoUCiwG1/bR44gwImE=";
    };
    nexploration = {
      name = "Nexploration";
      fileName = "Nexploration.taco";
      remote.github = {
        owner = "Nexrym";
        repo = "Nexploration";
        releases.enable = true;
      };
      versions."v0.9.0".hash = "sha256-SVh4fKJRsYBFTH/xKdwP94mkCiiG3vYQbF9R2UA6xq4=";
    };
    only-fish = {
      name = "Only Fish";
      fileName = "Only-Fish.taco";
      remote.github = {
        owner = "Metallis";
        repo = "Only-Fish-Marker-Pack";
        releases.enable = true;
      };
      versions."v1.13".hash = "sha256-Vhb+B3h46Yd+ZR/Hx1fT2sSBlaq3vNtKp/18hePiTk8=";
    };
    pewpews = {
      name = "Pewpew's Power Paths";
      fileName = "Pewpews_Power_Paths.taco";
      remote.github = {
        owner = "Girbilcannon";
        repo = "Pewpews-Power-Paths";
        releases.enable = true;
      };
      versions = {
        "v1.2.0".hash = "sha256-LczoEqIdHLZ+O+pp5XSX6VGdv9PicyFP2v8RSugkdSk=";
        "v2.0.1".hash = null;
      };
    };
    reactif-en = {
      name = "ReActif (EN)";
      fileName = "GW2 TacO ReActif EN External.taco";
      url = "https://web.archive.org/web/20241204004932/https://www.heinze.fr/taco/?lang=en";
      remote.manual.url = "https://reactif.games/taco/download.php?f=3";
      # TODO? unknown attrs: resetoffset, hascountdown
      versions = {
        /* corrupt :<
        "20220928" = {
          url = "https://web.archive.org/web/20220928161858/https://reactif.games/taco/download.php?f=3";
          hash = "";
        };*/
        "2024-12-22".hash = "sha256-KL+NaJ10cuTCwqzkxvzF0OwpLPEAxGv7nbh2VlCBt4g=";
      };
      output.sortPrio = 10;
    };
    reactif-fr = {
      name = "ReActif (FR)";
      fileName = "GW2 TacO ReActif FR Externe.taco";
      url = "https://web.archive.org/web/20250216050634/https://www.heinze.fr/taco/";
      remote.manual.url = "https://www.heinze.fr/taco/download.php?f=6";
      versions = {
        /* corrupt :<
        "20231204" = {
          url = "https://web.archive.org/web/20231204223135/https://reactif.games/taco/download.php?f=6";
          hash = "sha256-eqO8/NfSDAhMeGV/3BpKahxlhQsCOWRtREXzeI8uMPg=";
        };*/
        "2020-11-30".hash = "sha256-7/DYvBiEGNW36pGMm08PsI2uQo/bPKVVRD3FHdyfbak=";
      };
    };
    rediche-wvw = {
      name = "Reciche's WvW Siege Pack";
      fileName = "RedicheWvwPack.taco";
      remote.github = {
        owner = "rediche";
        repo = "rediche-wvw-pack";
        releases.enable = true;
      };
      versions."v1.0.8".hash = "sha256-pSkGGxorwzUd7rTSCaiQyH7JD5vU+t16jMOpyCZto0g=";
      # TODO: Attribute 'type' is redefined: `type="rsp.ebg.off.catapults" type="rsp.ebg.off.catapults"`
    };
    tekkits-aio = {
      name = "Tekkit's All-In-One";
      fileName = "tw_ALL_IN_ONE.taco";
      stock.enable = true;
      remote.direct = {
        #url = "https://www.tekkitsworkshop.net/download?download=1:tw-all-in-one";
        url = "https://www.tekkitsworkshop.net/downloads/tw_ALL_IN_ONE.taco";
      };
      versions."2025-08-27" = {
        #version = "7e11b1dbef7f616cba3957b766a16578"?
        hash = "sha256-bHpKeBBIr8F4BNO2sAaaCloQ5I5N7CFNZ0o059Iba2M=";
      };
      output.sortPrio = 10;
    };
    tryhard = {
      name = "The Tryhard Marker Pack";
      fileName = "Deroirs Tryhard Marker Pack.zip";
      remote.manual.url = "https://drive.google.com/file/d/15Eqex_HIO3B0Aga4qWL8kLc1vlVEIJ8e/view";
      versions."2018-11-19".hash = "sha256-XFD4zU4ZM6IcxWPPOx1C3u0o8T5n9aQZC2bTtWxV604";
    };
    tyria-drft = {
      name = "Tyria DRFT";
      fileName = "DRFT_Main.taco";
      remote.github = {
        owner = "n1nj44r91";
        repo = "Tyria-Drift-DRFT-GW2-TacO-Racetracks";
        releases.enable = true;
      };
      versions."v3.1".hash = "sha256-6fyn4smjQ9GukH4oKLu58QRVh1nCOQW8JIuCyww+lK8=";
    };
    twisted-castle = {
      name = "Twisted Castle";
      fileName = "TwistedCastle.taco";
      remote.github = {
        owner = "SZG5";
        repo = "gw2-twisted-castle";
        releases.enable = true;
      };
      versions."0.4".hash = "sha256-TPboDqTPtX2Rq77Yi6SR6NoTbHYEso0kd5MZOU4ljCs=";
    };
    zippy-ziplines = {
      name = "Zippy Ziplines";
      fileName = "Zippy.taco";
      remote.github = {
        owner = "Girbilcannon";
        repo = "zippy";
        releases.enable = true;
      };
      versions = {
        "Zippy1_8_0".hash = "sha256-Q2t3oCBE6/rRPx158//Ye5t62/i4XwuqEyVnBkktQsM=";
        "Zippy2_0_0".hash = null;
      };
    };
  };
}
