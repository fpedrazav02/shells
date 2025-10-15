{
  description = "DevShell for Ada";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
  };

  outputs = { self, nixpkgs }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };

    adaLanguageServer = pkgs.stdenv.mkDerivation rec {
      pname = "ada-language-server";
      version = "2026.0.202510141";

      src = pkgs.fetchurl {
        url = "https://github.com/AdaCore/ada_language_server/releases/download/${version}/als-${version}-linux-x64.tar.gz";
        sha256 = "sha256:c5ae56618e4264bf276abe0c8687e3ff427efc5070fa3a86c2084c90a1f45817";
      };

      unpackPhase = "true";
      installPhase = ''
        mkdir -p $out/bin
        tar -xzf $src
        cp integration/vscode/ada/x64/linux/ada_language_server $out/bin/
      '';
    };
  in {
    devShells.${system}.default = pkgs.mkShell {
      name = "ada-devshell";

      packages = [
        adaLanguageServer
        pkgs.gnat15
      ];

      shellHook = ''
        echo "✅ Ada Language Server in \$PATH"
        ada_language_server --version || true
      '';
    };
  };
}
