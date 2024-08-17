{ config, lib, pkgs, ... }:

{
  systemd.nspawn.ubuntu-ai = {
    execConfig = {
      Boot = true;
    };
    networkConfig = {
      Private = false;
    };
    filesConfig = {
      BindReadOnly = [
        "/etc/resolv.conf:/etc/resolv.conf"
      ];
      Bind = [
        "/dev/dri:/dev/dri"
        "/dev/kfd:/dev/kfd"
        "/mnt/human/llama:/llama"
        "/mnt/human/sd:/sd"
      ];
    };
  };

  systemd.services."systemd-nspawn@ubuntu-ai" = {
    environment = {
      SYSTEMD_NSPAWN_TMPFS_TMP = "0";
    };
    serviceConfig = {
      CPUQuota = "300%";
      MemoryHigh = "14G";
      MemoryMax = "15G";
      MemorySwapMax = "25G";
      ExecStart = "systemd-nspawn --quiet --keep-unit --boot --link-journal=try-guest --network-veth -U --settings=override --machine=%i -D /mnt/human/machines/ubuntu-ai";
    };
  #  overrideStrategy = "asDropin";
  };

  

}
