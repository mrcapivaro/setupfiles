# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ ];

  boot.initrd.availableKernelModules = [ "virtio_pci" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/mnt/wsl" =
    {
      device = "none";
      fsType = "tmpfs";
    };

  fileSystems."/usr/lib/wsl/drivers" =
    {
      device = "none";
      fsType = "9p";
    };

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/dcb85d90-8714-406c-8c1b-7e8ce3f047dc";
      fsType = "ext4";
    };

  fileSystems."/mnt/wslg" =
    {
      device = "none";
      fsType = "tmpfs";
    };

  fileSystems."/mnt/wslg/distro" =
    {
      device = "none";
      fsType = "none";
      options = [ "bind" ];
    };

  fileSystems."/usr/lib/wsl/lib" =
    {
      device = "none";
      fsType = "overlay";
    };

  fileSystems."/mnt/wslg/doc" =
    {
      device = "none";
      fsType = "overlay";
    };

  fileSystems."/mnt/wslg/.X11-unix" =
    {
      device = "/mnt/wslg/.X11-unix";
      fsType = "none";
      options = [ "bind" ];
    };

  fileSystems."/mnt/c" =
    {
      device = "C:\134";
      fsType = "9p";
    };

  fileSystems."/mnt/d" =
    {
      device = "D:\134";
      fsType = "9p";
    };

  fileSystems."/mnt/g" =
    {
      device = "G:\134";
      fsType = "9p";
    };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/aa9b168f-23c4-4e66-96d1-4a86a325eb45"; }];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.bonding_masters.useDHCP = lib.mkDefault true;
  # networking.interfaces.eth0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
