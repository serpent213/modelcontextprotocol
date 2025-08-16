{
  description = "Perplexity Ask MCP Server - Model Context Protocol server for Perplexity API integration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
        nodejs = pkgs.nodejs_22;

        perplexity-ask = pkgs.buildNpmPackage rec {
          pname = "mcp-server-perplexity-ask";
          version = "0.1.0";
          src = ./perplexity-ask;
          npmDepsHash = "sha256-4FfpqOZLiVhc4/0ZpYQnpuISDlzmTWiHxmZjmwuH0ZI=";

          nativeBuildInputs = [pkgs.makeWrapper];

          installPhase = ''
            runHook preInstall

            mkdir -p $out/bin $out/lib/node_modules/${pname}

            cp -r node_modules $out/lib/
            cp -r dist package.json package-lock.json $out/lib/node_modules/${pname}/

            makeWrapper ${nodejs}/bin/node $out/bin/mcp-server-perplexity-ask \
              --add-flags "$out/lib/node_modules/${pname}/dist/index.js"

            runHook postInstall
          '';

          meta = with pkgs.lib; {
            description = "MCP server for Perplexity API integration";
            homepage = "https://github.com/perplexityai/modelcontextprotocol";
            license = licenses.mit;
            maintainers = [];
            platforms = platforms.all;
          };
        };
      in {
        packages = {
          default = perplexity-ask;
          inherit perplexity-ask;
        };

        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            nodejs
            npm-check-updates
          ];
        };
      }
    );
}
