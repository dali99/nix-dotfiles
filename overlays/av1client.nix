self: super:
{
  av1client = super.stdenv.mkDerivation rec {
    name = "av1client-${version}";
    version = "0.5.0";

    src = ~/Documents/av1master/src/static;

    installPhase = ''
      mkdir -p $out/bin
      cp client.sh $out/bin/av1client

      sed -i 's,sleep,${super.coreutils}/bin/sleep,' $out/bin/av1client
      sed -i 's,rm,${super.coreutils}/bin/rm,' $out/bin/av1client
      sed -i 's,curl,${super.curl}/bin/curl --cacert ${super.cacert}/etc/ssl/certs/ca-bundle.crt,' $out/bin/av1client
      sed -i 's,jq,${super.jq}/bin/jq,' $out/bin/av1client
      sed -i 's,ffmpeg ,${self.myffmpeg}/bin/ffmpeg ,' $out/bin/av1client
      sed -i 's,aomenc ,${self.mylibaom}/bin/aomenc ,' $out/bin/av1client

      chmod +x $out/bin/av1client
    '';

  };
}
