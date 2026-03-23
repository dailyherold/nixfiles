# nvme0n1 (front slot): nvme-Samsung_SSD_990_PRO_1TB_S7LANL0L311673X
# nvme1n1 (surviving rear slot): nvme-Samsung_SSD_990_PRO_1TB_S73VNJ0TA11848P
# Boot redundancy note:
# this creates ESPs on both drives, but firmware boot entries are not declarative. Add the rear-disk UEFI entry once with:
#   sudo nix shell nixpkgs#efibootmgr -c efibootmgr --create --disk /dev/disk/by-id/nvme-Samsung_SSD_990_PRO_1TB_S73VNJ0TA11848P --part 1 --label 'NixOS (rear ESP)' --loader '\EFI\systemd\systemd-bootx64.efi'
# validate with:
#   sudo nix shell nixpkgs#efibootmgr -c efibootmgr --verbose
{
  disko.devices = {
    disk = {
      rear = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-Samsung_SSD_990_PRO_1TB_S73VNJ0TA11848P";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              priority = 1;
              name = "ESP";
              start = "1M";
              end = "1025M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot2";
                mountOptions = ["umask=0077"];
              };
            };
            swap = {
              name = "swap";
              size = "32G";
              content = {
                type = "swap";
              };
            };
            zfs = {
              name = "zfs";
              size = "100%";
              content = {
                type = "zfs";
                pool = "zroot";
              };
            };
          };
        };
      };
      front = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-Samsung_SSD_990_PRO_1TB_S7LANL0L311673X";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              priority = 1;
              name = "ESP";
              start = "1M";
              end = "1025M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = ["umask=0077"];
              };
            };
            zfs = {
              name = "zfs";
              size = "100%";
              content = {
                type = "zfs";
                pool = "zroot";
              };
            };
          };
        };
      };
    };

    zpool = {
      zroot = {
        type = "zpool";
        mode = "mirror";
        options = {
          ashift = "12";
          autotrim = "on";
          cachefile = "none";
        };
        rootFsOptions = {
          acltype = "posixacl";
          atime = "off";
          compression = "zstd";
          dnodesize = "auto";
          normalization = "formD";
          xattr = "sa";
          mountpoint = "none";
        };
        datasets = {
          root = {
            type = "zfs_fs";
            options.mountpoint = "none";
          };
          "root/nixos" = {
            type = "zfs_fs";
            mountpoint = "/";
            options = {
              mountpoint = "legacy";
              canmount = "noauto";
            };
          };
          home = {
            type = "zfs_fs";
            options.mountpoint = "none";
          };
          "home/dailyherold" = {
            type = "zfs_fs";
            mountpoint = "/home/dailyherold";
            options.mountpoint = "legacy";
          };
          nix = {
            type = "zfs_fs";
            mountpoint = "/nix";
            options.mountpoint = "legacy";
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
