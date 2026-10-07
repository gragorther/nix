rec {
  accounts.calendar.accounts.gregtech = {
    remote = {
      type = "caldav";
      passwordCommand = [
        "cat"
        "/run/secrets/dav"
      ];
      url = "https://dav.gregtech.eu";
      userName = "gregor";
    };
    thunderbird.enable = true;
  };
  accounts.contact.accounts.gregtech = accounts.calendar.accounts.gregtech // {
    remote.type = "carddav";
  };
}
