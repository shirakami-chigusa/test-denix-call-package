# test-denix-call-package

### Cannot define a package inside the `modules` directory

I want to define a package in the `modules` directory and use `callPacage`.

```nix
# modules/app/hello/default.nix
{
  delib,
  pkgs,
  ...
}:
let
  # hello = pkgs.callPackage ../../../packages/hello { };
  hello = pkgs.callPackage ./pkgs/hello { };
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
```

This package simply copies the `hello` binary to `$out/bin` for testing purposes.

```nix
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
```

Packages defined outside the `modules` directory, for example in the `/packages/hello` directory, are fine.

However, if I define a package in a `/modules/app/hello/pkgs/hello` directory, I will get an error, even if I don't use that package.

## Test

```sh
nix flake init -t github:yunfachi/denix#minimal-no-rices
# create package difinition.
# ...
# test build
darwin-rebuild build .#desktop
# or
# nixos-rebuild build .#desktop
```

```text
darwin-rebuild build --flake .#desktop

building the system configuration...
error:
       … in the left operand of the update (//) operator
         at /nix/store/ywc40m3bqxx5xq7xjksm52y5kfrbc0m3-source/lib/configurations/default.nix:173:9:
          172|         lib.concatMapAttrs (mkHostAttrs null null) hosts
          173|         // lib.concatMapAttrs (riceName: rice: lib.concatMapAttrs (mkHostAttrs riceName rice) hosts) rices;
             |         ^
          174|     in

       … while calling the 'foldl'' builtin
         at /nix/store/khwrmv3vkmc60ig18h90rf0iadis95na-source/lib/attrsets.nix:378:26:
          377|   */
          378|   concatMapAttrs = f: v: foldl' mergeAttrs { } (attrValues (mapAttrs f v));
             |                          ^
          379|

       … while evaluating the module argument `pkgs' in "/nix/store/2g3fjmiknicizhbcg9gw1pl0bggpihq5-source/modules/app/pkgs/hello/default.nix":

       (stack trace truncated; use '--show-trace' to show the full, detailed trace)

       error: infinite recursion encountered
       at /nix/store/khwrmv3vkmc60ig18h90rf0iadis95na-source/lib/modules.nix:652:66:
          651|       extraArgs = mapAttrs (
          652|         name: _: addErrorContext (context name) (args.${name} or config._module.args.${name})
             |                                                                  ^
          653|       ) (functionArgs f);
```

Will files in the directory defined in the `path` be processed by `denix` even if they are not `delib.module`?

Can't define non-`denix` modules in a `modules` directory?

```nix
mkConfigurations =
  moduleSystem:
  denix.lib.configurations {
    inherit moduleSystem;
    homeManagerUser = "sjohn"; # !!! REPLACEME

    paths = [
      ./hosts
      ./modules # !!! Suspicious
    ];

    specialArgs = {
      inherit inputs;
    };
  };
```
