{ config, lib, pkgs, ... }:

{

    services.tor = {
      enable = true;
      openFirewall = true;
      enableGeoIP =false;
      relayonionServices = {
        xmpp = {
          map = [
            {
              port = 5000;
              #target = {
              #  addr = "localhost";
              #    
              #};
            }

            {
              port = 5222;
            }

            {
              port = 5269;
            }

            {
              port = 5280;
            }

            {
              port = 5281;
            }

            {
              port = 5347;
            }

            {
              port = 5582;
            }

          ];
        };
      };
    };

  services.prosody = {
    enable = true;
    admins = [ "root@<YOURDOMAIN>.onion" ];
    ssl.cert = "/var/lib/prosody/<YOURDOMAIN>.onion.crt";
    ssl.key = "/var/lib/prosody/<YOURDOMAIN>.onion.key";
    virtualHosts."<YOURDOMAIN>.onion" = {
        enabled = true;
        domain = "<YOURDOMAIN>.onion";
        ssl.cert = "/var/lib/prosody/<YOURDOMAIN>.onion.crt";
        ssl.key = "/var/lib/prosody/<YOURDOMAIN>.onion.key";
    };
    muc = [ {
        domain = "conference.<YOURDOMAIN>.onion";
    } ];
    uploadHttp = {
        domain = "upload.<YOURDOMAIN>.onion";
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
