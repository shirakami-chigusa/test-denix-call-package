{ pkgs, ... }:
pkgs.stdenvNoCC.mkDerivation {
  name = "hello";
  src = ./.;

  buildInputs = [ pkgs.hello ];

  installPhase = ''
    mkdir -p $out/bin
    cp ${pkgs.hello}/bin/* $out/bin/
  '';
}
