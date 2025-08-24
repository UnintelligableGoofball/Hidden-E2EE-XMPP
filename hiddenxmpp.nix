{ config, lib, pkgs, ... }:

{

  services.tor = {
    enable = true;
    openFirewall = true;
    enableGeoIP = false;
    relayonionServices = {
      xmpp = {
        map = [ 5000 5222 5269 5280 5281 5347 5582 ];
      };
    };
  };

  ## replace "<YOURADDRESS>" everywhere with the generated tor address, should be in /var/lib/tor/onion/xmpp/hostname

  services.prosody = {
    enable = true;
    admins = [ "root@<YOURADDRESS>.onion" ];
    ssl.cert = "/var/lib/prosody/<YOURADDRESS>.onion.crt";
    ssl.key = "/var/lib/prosody/<YOURADDRESS>.onion.key";
    virtualHosts."<YOURADDRESS>.onion" = {
        enabled = true;
        domain = "<YOURADDRESS>.onion";
        ssl.cert = "/var/lib/prosody/<YOURADDRESS>.onion.crt";
        ssl.key = "/var/lib/prosody/<YOURADDRESS>.onion.key";
    };
    muc = [ {
        domain = "conference.<YOURADDRESS>.onion";
    } ];
    uploadHttp = {
        domain = "upload.<YOURADDRESS>.onion";
    };

    modules.motd = true;
    modules.watchregistrations = true;

    modules.register = true;

    extraConfig = ''
      log = "/var/lib/prosody/prosody.log"
      motd_text = [[haiiii, welcome!]]
      allow_registration = true
    '';
    
    extraModules = [ 
      "onions"
    ];
  };

  environment.systemPackages = [
    pkgs.openssl
  ];

}
