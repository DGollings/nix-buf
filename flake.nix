{
  description = "Buf CLI binary";

  # Nixpkgs / NixOS version to use.
  inputs.nixpkgs.url = "nixpkgs/nixos-22.11";

  outputs = { self, nixpkgs }:
    let

      # to work with older version of flakes
      lastModifiedDate = self.lastModifiedDate or self.lastModified or "19700101";

      # Generate a user-friendly version number.
      version = "1.10.0";

      # System types to support.
      supportedSystems = [ "x86_64-linux" ];

      # Helper function to generate an attrset '{ x86_64-linux = f "x86_64-linux"; ... }'.
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      # Nixpkgs instantiated for supported system types.
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });

    in
    {

      packages = forAllSystems (system:
        with import nixpkgs { system = "x86_64-linux"; };
        let
          pkgs = nixpkgsFor.${system};
        in
        {
          buf = stdenv.mkDerivation {
            pname = "buf";
            version = version;

            src = fetchurl {
              url = "https://github.com/bufbuild/buf/releases/download/v${version}/buf-Linux-x86_64";
              sha256 = "15fqrr3r8bh1nj9p01b09fbwi4sg36n3bb41cgha8rg6wsdz637y";
            };

            nativeBuildInputs = [
              autoPatchelfHook
            ];

            unpackPhase = "true";

            installPhase = ''
              mkdir -p $out/bin
              cp $src $out/bin/buf
              chmod 755 $out/bin/buf
            '';

            meta = with nixpkgs.lib; {
              homepage = "https://github.com/bufbuild/buf";
              # description = description;
              platforms = platforms.linux;
            };
          };
        });

      # The default package for 'nix build'. This makes sense if the
      # flake provides only one package or there is a clear "main"
      # package.
      defaultPackage = forAllSystems (system: self.packages.${system}.buf);
    };
}
