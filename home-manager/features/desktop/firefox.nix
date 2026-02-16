{pkgs, ...}: {
  programs.firefox = {
    enable = true;
    package = pkgs.firefox;
    policies = {
      AppAutoUpdate = false;
      AutofillAddressEnabled = false;
      AutofillCreditCardEnabled = false;
      CaptivePortal = false;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableTelemetry = true;
      DisableFirefoxAccounts = false;
      FirefoxHome = {
        Search = true;
        Pocket = false;
        SponsoredPocket = false;
        Snippets = false;
        TopSites = false;
        SponsoredTopSites = false;
        Highlights = false;
      };
      FirefoxSuggest = {
        WebSuggestions = false;
        SponsoredSuggestions = false;
        ImproveSuggest = false;
        Locked = false;
      };
      NoDefaultBookmarks = true;
      OfferToSaveLogins = false;
      OfferToSaveLoginsDefault = false;
      PasswordManagerEnabled = false;
      UserMessaging = {
        ExtensionRecommendations = false;
        SkipOnboarding = true;
        WhatsNew = false;
        FeatureRecomendations = false;
        UrlbarInterventions = false;
        MoreFromMozilla = false;
        FirefoxLabs = true;
      };
      GenerativeAI = {
        Enabled = true;
        Chatbot = true;
        LinkPreviews = false;
        TabGroups = false;
        Locked = false;
      };
    };
    profiles.default = {
      id = 0;
      isDefault = true;
      name = "default";
      search = {
        force = true;
        default = "ddg";
        engines = {
          "Nix Packages" = {
            urls = [
              {
                template = "https://search.nixos.org/packages";
                params = [
                  {
                    name = "type";
                    value = "packages";
                  }
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = ["@np"];
          };
          "Nix Options" = {
            urls = [
              {
                template = "https://search.nixos.org/options";
                params = [
                  {
                    name = "type";
                    value = "packages";
                  }
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = ["@no"];
          };
          "NixOS Wiki" = {
            urls = [{template = "https://nixos.wiki/index.php?search={searchTerms}";}];
            icon = "https://nixos.wiki/favicon.png";
            updateInterval = 24 * 60 * 60 * 1000;
            definedAliases = ["@nw"];
          };
          "Nix Reference Manual" = {
            urls = [{template = "https://nixos.org/manual/nix/unstable/?search={searchTerms}";}];
            icon = "https://nixos.wiki/favicon.png";
            updateInterval = 24 * 60 * 60 * 1000;
            definedAliases = ["@nm"];
          };
          "Home Manager Options" = {
            urls = [
              {
                template = "https://home-manager-options.extranix.com";
                params = [
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                  {
                    name = "release";
                    value = "master";
                  }
                ];
              }
            ];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = ["@hm"];
          };
        };
      };
      settings = {
        "browser.aboutConfig.showWarning" = false;
        "browser.contentblocking.category" = "strict";
        "browser.shell.checkDefaultBrowser" = false;
        "browser.shell.defaultBrowserCheckCount" = 1;
        "browser.startup.homepage" = "https://start.duckduckgo.com";
        "browser.toolbars.bookmarks.visibility" = "always";
        "browser.uiCustomization.state" = ''{"placements":{"widget-overflow-fixed-list":[],"unified-extensions-area":["jid1-mnnxcxisbpnsxq_jetpack-browser-action","_bf855ead-d7c3-4c7b-9f88-9a7e75c0efdf_-browser-action","jid1-bofifl9vbdl2zq_jetpack-browser-action","ublock0_raymondhill_net-browser-action","_c2c003ee-bd69-42a2-b0e9-6f34222cb046_-browser-action","_d7742d87-e61d-4b78-b8a1-b469842139fa_-browser-action","https-everywhere_eff_org-browser-action","chrome-gnome-shell_gnome_org-browser-action","cookieautodelete_kennydo_com-browser-action","pinboard-plus_lsproc_com-browser-action","_74145f27-f039-47ce-a470-a662b129930a_-browser-action"],"nav-bar":["back-button","forward-button","stop-reload-button","_testpilot-containers-browser-action","urlbar-container","downloads-button","fxa-toolbar-menu-button","addon_darkreader_org-browser-action","support_lastpass_com-browser-action","_a6c4a591-f1b2-4f03-b3ff-767e5bedf4e7_-browser-action","_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action","zotero_chnm_gmu_edu-browser-action","_d3e01ff2-9a3a-4007-8f6e-7acd9a5de263_-browser-action","unified-extensions-button","reset-pbm-toolbar-button","aws-extend-switch-roles_toshi_tilfin_com-browser-action"],"toolbar-menubar":["menubar-items"],"TabsToolbar":["firefox-view-button","tabbrowser-tabs","new-tab-button","alltabs-button"],"PersonalToolbar":["managed-bookmarks","personal-bookmarks"]},"seen":["developer-button","jid1-mnnxcxisbpnsxq_jetpack-browser-action","_testpilot-containers-browser-action","addon_darkreader_org-browser-action","support_lastpass_com-browser-action","_bf855ead-d7c3-4c7b-9f88-9a7e75c0efdf_-browser-action","jid1-bofifl9vbdl2zq_jetpack-browser-action","ublock0_raymondhill_net-browser-action","_c2c003ee-bd69-42a2-b0e9-6f34222cb046_-browser-action","_d7742d87-e61d-4b78-b8a1-b469842139fa_-browser-action","https-everywhere_eff_org-browser-action","chrome-gnome-shell_gnome_org-browser-action","cookieautodelete_kennydo_com-browser-action","pinboard-plus_lsproc_com-browser-action","_74145f27-f039-47ce-a470-a662b129930a_-browser-action","_a6c4a591-f1b2-4f03-b3ff-767e5bedf4e7_-browser-action","save-to-pocket-button","_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action","zotero_chnm_gmu_edu-browser-action","_d3e01ff2-9a3a-4007-8f6e-7acd9a5de263_-browser-action","aws-extend-switch-roles_toshi_tilfin_com-browser-action"],"dirtyAreaCache":["nav-bar","widget-overflow-fixed-list","toolbar-menubar","TabsToolbar","PersonalToolbar","unified-extensions-area"],"currentVersion":20,"newElementCount":6}'';
        "sidebar.revamp" = true;
        "sidebar.main.tools" = "aichat";
      };
    };
  };

  xdg.mimeApps.defaultApplications = {
    "text/html" = ["firefox.desktop"];
    "text/xml" = ["firefox.desktop"];
    "x-scheme-handler/http" = ["firefox.desktop"];
    "x-scheme-handler/https" = ["firefox.desktop"];
  };
}
