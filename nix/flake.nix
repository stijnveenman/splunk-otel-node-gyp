{
  description = "Airport control";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    nixpkgs,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachSystem ["aarch64-darwin" "x86_64-linux"] (system: let
      pkgs = import nixpkgs {
        inherit system;
        config = {allowUnfree = true;};
      };

      devPackages = with pkgs;
        [
          nodejs-18_x
          python310
        ]
        ++ lib.optionals (stdenv.isDarwin) [
          # required for building native argon2 binary, used by identity-service
          darwin.cctools
        ];
    in {
      devShells.default = pkgs.mkShell {
        buildInputs = devPackages;
      };
    });
}
