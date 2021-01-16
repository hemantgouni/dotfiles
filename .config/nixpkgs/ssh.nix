{ config, lib, pkgs, ... }:

{ 
    programs.ssh = {
        enable = true;
        controlMaster = "auto";
        controlPersist = "600";
        serverAliveInterval = 60;

        extraOptionOverrides = {
            IdentitiesOnly = "yes";
        };

        matchBlocks = {
            "acm.*" = {
                identityFile = "~/.ssh/acm";
            };

            "acm.argo" = lib.hm.dag.entryAfter [ "acm.*" ] {
                hostname = "argo.acm.umn.edu";
            };

            "acm.cerberus" = lib.hm.dag.entryAfter [ "acm.*" ] {
                hostname = "cerberus.acm.umn.edu";
            };

            "acm.garlic" = lib.hm.dag.entryAfter [ "acm.*" ] {
                hostname = "garlic.acm.umn.edu";
            };

            "acm.jotunn" = lib.hm.dag.entryAfter [ "acm.*" ] {
                hostname = "jotunn.acm.umn.edu";
            };

            "acm.wopr" = lib.hm.dag.entryAfter [ "acm.*" ] {
                hostname = "160.94.179.147";
            };

            "github" = {
                hostname = "github.com";
                user = "git";
                identityFile = "~/.ssh/github";
            };

            "umn.git" = {
                hostname = "github.umn.edu";
                user = "git";
                identityFile = "~/.ssh/gitumn";
            };

            "unipassau" = {
                hostname = "gitlab.infosun.fim.uni-passau.de";
                user = "git";
                identityFile = "~/.ssh/unipassau";
            };

            "desktop" = {
                # use mdns here?
                hostname = "0.0.0.0";
                user = "lawabidingcactus";
                identityFile = "~/.ssh/desktop";
            };

            "couch" = {
                hostname = "192.168.1.60";
                user = "couch";
                identityFile = "~/.ssh/couch";
            };
        };
    };

    home.packages = with pkgs; [ x11_ssh_askpass ]; 
}
