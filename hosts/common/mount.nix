{pkgs, ...}: {
  # Mount NAS
  fileSystems."/mnt/citadel/backup" = {
    device = "citadel.local:/mnt/user/backup";
    fsType = "nfs";
  };
  fileSystems."/mnt/citadel/documents" = {
    device = "citadel.local:/mnt/user/documents";
    fsType = "nfs";
  };
  fileSystems."/mnt/citadel/movies" = {
    device = "citadel.local:/mnt/user/movies";
    fsType = "nfs";
  };
  fileSystems."/mnt/citadel/music" = {
    device = "citadel.local:/mnt/user/music";
    fsType = "nfs";
  };
  fileSystems."/mnt/citadel/pictures" = {
    device = "citadel.local:/mnt/user/pictures";
    fsType = "nfs";
  };
  fileSystems."/mnt/citadel/syncthing" = {
    device = "citadel.local:/mnt/user/syncthing";
    fsType = "nfs";
  };
  fileSystems."/mnt/citadel/tv" = {
    device = "citadel.local:/mnt/user/tv";
    fsType = "nfs";
  };
  fileSystems."/mnt/citadel/videos" = {
    device = "citadel.local:/mnt/user/videos";
    fsType = "nfs";
  };
}
