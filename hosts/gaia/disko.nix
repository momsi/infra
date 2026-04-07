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
              size = "513M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
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
                content = {
                  type = "btrfs";
                  extraArgs = [ "-f" ];
                  subvolumes = {
                    "@" = {
                      mountpoint = "/";
                      mountOptions = [ "compress=zstd" "noatime" ];
                    };
                    "@home" = {
                      mountpoint = "/home";
                      mountOptions = [ "compress=zstd" "noatime" ];
                    };
                    "@log" = {
                      mountpoint = "/var/log";
                      mountOptions = [ "compress=zstd" "noatime" ];
                    };
                    "@cache" = {
                      mountpoint = "/var/cache";
                      mountOptions = [ "compress=zstd" "noatime" ];
                    };
                    "@tmp" = {
                      mountpoint = "/var/tmp";
                      mountOptions = [ "compress=zstd" "noatime" ];
                    };
                    "@root" = {
                      mountpoint = "/root";
                      mountOptions = [ "compress=zstd" "noatime" ];
                    };
                    "@srv" = {
                      mountpoint = "/srv";
                      mountOptions = [ "compress=zstd" "noatime" ];
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
                content = {
                  type = "btrfs";
                  extraArgs = [ "-f" ];
                  subvolumes = {
                    "/nosys" = {
                      mountpoint = "/nosys";
                      mountOptions = [ "compress=zstd" "noatime" ];
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
