# nvme0n1 (nvme-Samsung_SSD_990_PRO_1TB_S73VNJ0X117437N) 1TB PCIe 4.0 x4
# nvme1n1 (nvme-Samsung_SSD_990_PRO_1TB_S73VNJ0TA11848P) 1TB PCIe 3.0 x4
{
  disko.devices = {
    # note: disko only supports single-drive BTRFS arrays,
    # so add second drive with `sudo btrfs device add -f /dev/disk/by-id/nvme-Samsung_SSD_990_PRO_1TB_S73VNJ0TA11848P /`,
    # then run `sudo btrfs balance start -v -dconvert=raid1,soft -mconvert=raid1 /`
    # optionally with `--background`
    # view filesystem with `btrfs filesystem usage /`
    disk = {
      root = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-Samsung_SSD_990_PRO_1TB_S73VNJ0X117437N";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              priority = 1;
              name = "ESP";
              start = "1M";
              end = "1024M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            root = {
              name = "root";
              size = "100%";
              content = {
                type = "btrfs";
                # Overwirte the existing filesystem
                extraArgs = ["-f"];
                # Subvolumes must set a mountpoint in order to be mounted,
                # unless their parent is mounted
                subvolumes = {
                  "/root" = {
                    mountpoint = "/";
                    mountOptions = ["defaults" "compress=zstd" "noatime"];
                  };
                  "/nix" = {
                    mountpoint = "/nix";
                    mountOptions = ["defaults" "compress=zstd" "noatime"];
                  };
                  "/home" = {
                    mountpoint = "/home";
                    mountOptions = ["defaults" "compress=zstd" "noatime"];
                  };
                  # Swap subvolume setup
                  "/swap" = {
                    mountpoint = "/.swapvol";
                    swap.swapfile.size = "2G";
                  };
                };
              };
            };
          };
        };
      };
    };
    nodev = {
      "/tmp" = {
        fsType = "tmpfs";
        mountOptions = [
          "defaults"
          "size=4G"
          "mode=755"
        ];
      };
    };
  };
}
