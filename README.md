# Buf cli binary
https://github.com/bufbuild/buf

# Example usage:

flake.nix
``` nix
{
  inputs =
    {
      nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
      flake-utils.url = "github:numtide/flake-utils";
      buf.url = "github:DGollings/nix-buf";
    };

  outputs = { self, nixpkgs, flake-utils, buf }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          nativeBuildInputs = [ pkgs.bashInteractive ];
          buildInputs = [
            buf.packages.${system}.buf
          ];
        };
      });
}
```
