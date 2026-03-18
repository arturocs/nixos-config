{...}: {
  fileSystems."/hdd" = {
    device = "/dev/sda2";
    fsType = "ntfs3";
    options = ["nosuid" "nodev" "uid=1000" "gid=100" "iocharset=utf8" "uhelper=udisks2" "nofail"];
  };

  fileSystems."/home/arturo/.local/share/dolphin-emu/Load/Textures/Metroid Prime 1 HD" = {
    device = "/hdd/ROMS/Dolphin textures/Metroid_Prime_1.dwarfs";
    fsType = "fuse.dwarfs";
    options = ["nofail"];
  };

  fileSystems."/home/arturo/.local/share/dolphin-emu/Load/Textures/Metroid Prime 2 HD" = {
    device = "/hdd/ROMS/Dolphin textures/Metroid_Prime_2.dwarfs";
    fsType = "fuse.dwarfs";
    options = ["nofail"];
  };

  fileSystems."/home/arturo/.local/share/dolphin-emu/Load/Textures/Metroid Prime 3 HD" = {
    device = "/hdd/ROMS/Dolphin textures/Metroid_Prime_3.dwarfs";
    fsType = "fuse.dwarfs";
    options = ["nofail"];
  };

  fileSystems."/home/arturo/Escritorio/UDo2/backups_real_prod" = {
    device = "/hdd/backups_real_prod.dwarfs";
    fsType = "fuse.dwarfs";
    options = ["nofail"];
  };

  fileSystems."/home/arturo/Escritorio/UDo2/udo-dev/venv" = {
    device = "/hdd/venv.dwarfs";
    fsType = "fuse.dwarfs";
    options = ["nofail"];
  };
}
