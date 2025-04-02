{ config, lib, pkgs, ... }:

{
  users.users.nixbuilder = {
    isSystemUser = true;
    useDefaultShell = true;
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDpGSDczzDOhTETCj+uB5e3/9QbOCaVW1knM+n1ey0n6LXH7uiPPmzuZiqfzmfbB1z4bjM2zpn3D6Et6zRCrBUjhTZqf/5GoNlvhVA6QYmBmBp98b8oY7juj5cmu55voxD0S5rC1mQMnWAAf8e8OPbkhs9Lt0XlOYdotLNIZQubzWqE2DK45g/h17ELJs+jkNXoalFjLvLXWzE/C+3pYoeNJVGHfVMTIwt7o64E6JXhxuYTYdSIuzd+BjntkSCXzcAzBFMRwkdlFVoBtLUMMcMQl39kcXv7lAQ8pv+8b1j1N9WuQVf1qEAcZguaimI1ifbXP5d841pZPApCj5KXectIEldfTrcwg8rZpd2UfYS/3XCcOuidBGprY7XsU/jz8wHbH68UjUrsLyaOMnG2ChYztnf63vm3gRs3Fc6FqTycpgYOPDeZBVTcMyPGgtiZvhnTeY20xFS5lK6M+dmgaDqH24kPLiwYSpUF2NK+Rg/2bZxvt/GaSr4U6fJGi3FCJOM= root@DanixLaptop"
    ];
  };

  nix.settings.trusted-users = [ "nixbuilder" ];

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
}
