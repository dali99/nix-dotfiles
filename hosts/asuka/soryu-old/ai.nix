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
        "/mnt/human/llama:/llama:idmap"
        "/mnt/human/sd:/sd:idmap"
      ];
    };
  };

  systemd.services."systemd-nspawn@ubuntu-ai" = {
    environment = {
      SYSTEMD_NSPAWN_TMPFS_TMP = "0";
    };
    serviceConfig = {
      CPUQuota = "1400%";
      MemoryHigh = "90G";
      MemoryMax = "94G";
      MemorySwapMax = "40G";
      ExecStart = "systemd-nspawn --quiet --keep-unit --boot --link-journal=try-guest --network-veth -U --settings=override --machine=%i -D /mnt/human/machines/ubuntu-ai";
    };
  #  overrideStrategy = "asDropin";
  };

  

}
