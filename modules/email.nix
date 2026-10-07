{
  accounts.email.accounts.gregtech = {
    primary = true;
    address = "gregor@gregtech.eu";
    realName = "Gregor Podjed";
    userName = "gregor@gregtech.eu";
    imap = {
      authentication = "login";
      host = "imap.purelymail.com";
      port = 993;
      tls.enable = true;
    };
    smtp = {
      authentication = "login";
      host = "smtp.purelymail.com";
      port = 465;
      tls.enable = true;
    };
    thunderbird.enable = true;
    passwordCommand = ["cat" "/run/secrets/email"];
  };
}
