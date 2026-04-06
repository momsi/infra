{ lib, ... }:

{
  disko.devices = {
    disk = {
      os = {
        device = "/dev/nvme1n1";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              label = "boot";
              size = "513MiB";
              type = "EF00";
              format = {
                format = "vfat";
                label = "boot";
              };
            };
            root = {
              size = "100%";
              label = "luks-root";
              content = {
                type = "luks";
                name = "root";
                settings = {
                  allowDiscards = true;
                };
                format = {
                  format = "btrfs";
                  label = "luks-root";
                  extraMountOptions = "compress=zstd,noatime";
                  subvolumes = {
                    "@" = {
                      mountpoint = "/";
                      mountOptions = "compress=zstd,noatime";
                    };
                    "@home" = {
                      mountpoint = "/home";
                      mountOptions = "compress=zstd,noatime";
                    };
                    "@log" = {
                      mountpoint = "/var/log";
                      mountOptions = "compress=zstd,noatime";
                    };
                    "@cache" = {
                      mountpoint = "/var/cache";
                      mountOptions = "compress=zstd,noatime";
                    };
                    "@tmp" = {
                      mountpoint = "/var/tmp";
                      mountOptions = "compress=zstd,noatime";
                    };
                    "@root" = {
                      mountpoint = "/root";
                      mountOptions = "compress=zstd,noatime";
                    };
                    "@srv" = {
                      mountpoint = "/srv";
                      mountOptions = "compress=zstd,noatime";
                    };
                  };
                };
              };
            };
          };
        };
      };
      data = {
        device = "/dev/nvme0n1";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            data = {
              size = "100%";
              label = "luks-data";
              content = {
                type = "luks";
                name = "data";
                settings = {
                  allowDiscards = true;
                };
                format = {
                  format = "btrfs";
                  label = "luks-data";
                  extraMountOptions = "compress=zstd,noatime";
                  subvolumes = {
                    "/nosys" = {
                      mountpoint = "/nosys";
                      mountOptions = "compress=zstd,noatime";
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
