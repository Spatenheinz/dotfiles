{
  minimal = {
    path = ./minimal;
    description = "A grossly incandescent and minimal nixos config";
  };

  # Hosts
  host-desktop = {
    path = ./hosts/desktop;
    description = "A starter hosts/* config for someone's daily driver";
  };
}
