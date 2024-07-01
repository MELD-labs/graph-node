{
  description = "graph-node";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-23.11-darwin";
    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs = { self, nixpkgs, flake-utils, rust-overlay, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ (import rust-overlay) ];
        };
      in with pkgs; let
        RUST_VERSION = "1.78.0";

        rustToolchain = rust-bin.stable.${RUST_VERSION}.default.override {
          extensions = [
            "rls"
            "rust-analyzer"
            "rust-src"
            "rust-std"
          ];
        };

        systemEnv = if (stdenv.isDarwin) then [darwin.apple_sdk.frameworks.Security] else [];
      in {
        devShell = with pkgs; mkShell {
          buildInputs = [
            rustToolchain
            protobuf
          ] ++ systemEnv;
       };
      }
    );
}
