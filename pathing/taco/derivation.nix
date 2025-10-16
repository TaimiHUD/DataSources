# TODO
{ lib, unzip, fetchurl, mkDerivationNoCC }: let
  inherit (lib.attrsets) attrValues mapAttrsToList;
  inherit (lib.strings) concatStringsSep escapeShellArg;
  sources = import ./taco.nix;
  mkInstall = name: src: ''
    install -d ${escapeShellArg src.name} $out/share/gw2taco/${escapeShellArg name}
  '';
in mkDerivationNoCC {
  name = "gw2-taco-packs";
  srcs = attrValues sources;

  #nativeBuildInputs = [ unzip ];

  buildPhase = ''
    runHook preBuild;
    true
    runHook postBuild;
  '';

  installPhase = ''
    runHook preInstall;

    ${concatStringsSep "\n" (mapAttrsToList mkInstall sources)}

    runHook postInstall;
  '';

  passthru = {
    inherit sources;
  };
}
