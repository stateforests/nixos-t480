{
  description = "Minimal NixOS configuration for a Lenovo ThinkPad T480";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
  };

  outputs = { nixpkgs, ... }:
    {
      nixosConfigurations.t480 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [
          ./hosts/t480/configuration.nix
        ];
      };
    };
}
