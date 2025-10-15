{
  description = "Panela java development shell";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        jdk = pkgs.jdk21;
        graal = pkgs.graalvm-ce;
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            graal
            jdk
            gradle
            jdt-language-server
            git
            sqlite
            clang
            libclang
          ];

          JAVA_HOME = "${jdk}";
          GRAALVM_HOME = "${graal}";
          MACOSX_DEPLOYMENT_TARGET = "14.0";
          DEVELOPER_DIR = "/Library/Developer/CommandLineTools";

          shellHook = ''
            echo "Panela shell"
            echo "Java:  $(java -version 2>&1 | head -n1)"
          '';
        };
      }
    );
}
