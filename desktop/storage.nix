{pkgs-unstable, ...}: let
  dwarfs = "${pkgs-unstable.dwarfs}/bin/dwarfs#";
in {
  fileSystems."/hdd" = {
    device = "/dev/sda2";
    fsType = "ntfs3";
    options = ["nosuid" "nodev" "uid=1000" "gid=100" "iocharset=utf8" "uhelper=udisks2" "nofail"];
  };

  fileSystems."/home/arturo/.local/share/dolphin-emu/Load/Textures/Metroid Prime 1 HD" = {
    device = "/hdd/ROMS/Dolphin textures/Metroid_Prime_1.sfs";
    fsType = "squashfs";
    options = ["nofail"];
    depends = ["/hdd"];
  };

  fileSystems."/home/arturo/.local/share/dolphin-emu/Load/Textures/Metroid Prime 2 HD" = {
    device = "/hdd/ROMS/Dolphin textures/Metroid_Prime_2.sfs";
    fsType = "squashfs";
    options = ["nofail"];
    depends = ["/hdd"];
  };

  fileSystems."/home/arturo/.local/share/dolphin-emu/Load/Textures/Metroid Prime 3 HD" = {
    device = "/hdd/ROMS/Dolphin textures/Metroid_Prime_3.sfs";
    fsType = "squashfs";
    options = ["nofail"];
    depends = ["/hdd"];
  };

  fileSystems."/home/arturo/Escritorio/UDo3/backups_real_prod" = {
    device = "${dwarfs}/hdd/backups_real_prod.dwarfs";
    fsType = "fuse";
    options = ["nofail" "allow_other" "ro" "default_permissions" "uid=1000" "gid=100"];
    depends = ["/hdd"];
  };
}
