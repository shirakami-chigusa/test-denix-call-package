# modules/app/hello/pkgs/hello/default.nix
#
# This package simply copies the hello binary to bin for testing purposes.
#
# Even if you don't use it, it will always be evaluated as a module.
#
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
