{
    description = "Bus daemon for apathyos desktop environment";

    inputs.self.submodules = true;

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    };

    outputs =
        {
            self,
            nixpkgs,
        }:
        let
            system = "x86_64-linux";
            pkgs = import nixpkgs { inherit system; };
        in
        {
            packages.${system}.default = pkgs.rustPlatform.buildRustPackage {
                pname = "apathyos-daemon";
                version = "1.0.0";
                src = ./.;

                cargoLock = {
                    lockFile = ./Cargo.lock;
                };

                meta.mainProgram = "apthyd";
            };

            apps.${system}.default = {
                type = "app";
                program = "${self.packages.${system}.default}/bin/apthyd";
            };

            devShells.${system}.default = pkgs.mkShell {
                packages = with pkgs; [
                    rustc
                    cargo
                    clippy
                    rustfmt
                    pkg-config
                ];
            };

            checks.${system}.default = self.packages.${system}.default;
        };
}
