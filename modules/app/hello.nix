{
  delib,
  pkgs,
  ...
}:
let
  # hello = pkgs.callPackage ../../packages/hello { };
  # hello = pkgs.callPackage ./pkgs/hello { };
in
delib.module {
  name = "app.hello";

  options = delib.singleEnableOption true;

  nixos.ifEnabled =
    {
      myconfig,
      cfg,
      ...
    }:
    {
      environment.systemPackages = [
        # hello
      ];
    };

  darwin.ifEnabled =
    {
      myconfig,
      cfg,
      ...
    }:
    {
      environment.systemPackages = [
        # hello
      ];
    };

}
