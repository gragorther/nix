{ lib, ... }:
let
  urlListToAttrSet =
    fn: urls:
    lib.mergeAttrsList (
      map (
        x:
        let
          meaningfulName = lib.lists.last (lib.splitString "/" x);
        in
        {
          ${meaningfulName} = fn x;
        }
      ) urls
    );

  davUrlListToCalendarAttrSet =
    readonly: list:
    (urlListToAttrSet (url: {

      remote = {
        type = "http";

        url = url;

      };
      thunderbird.enable = true;
      thunderbuird.readOnly = readonly;
    }) list)
    // lib.optionalAttrs (!readonly) {
      userName = "gregor";
      passwordCommand = [
        "cat"
        "/run/secrets/dav"
      ];
      type = "caldav";
    };
  attrSetToList = lib.attrsets.mapAttrsToList (
    name: value: [
      name
      value
    ]
  );

  addRequiredFieldsToCalendar =
    cal:
    lib.recursiveUpdate {
      remote = {
        type = "caldav";
      };
      thunderbird.enable = true;
    } cal;

  addAuthFieldsToCalendar =
    cal:
    lib.recursiveUpdate {
      remote = {
        userName = "gregor";
        passwordCommand = [
          "cat"
          "/run/secrets/dav"
        ];
      };
    } cal;
  addAllFieldsToCalendar = x: addAuthFieldsToCalendar (addRequiredFieldsToCalendar x);

in
{
  accounts.calendar.accounts =
    builtins.mapAttrs (name: value: addAllFieldsToCalendar value) (
      builtins.mapAttrs (name: value: value // { remote.url = "https://dav.gregtech.eu/gregor/${name}"; })
        {
          personal = {
            thunderbird.color = "#990909";
          };
          exams = {
            thunderbird.color = "#000000";
          };
          school = {
            thunderbird.color = "#23a307";
          };
          skupni = {
            thunderbird.color = "#c29913";
          };
        }
    )
    //
      builtins.mapAttrs
        (name: value: addRequiredFieldsToCalendar (lib.recursiveUpdate { remote.type = "http"; } value))
        {
          urnik = {
            remote = {
              url = "https://urnik.gimvic.org/api/calendar/timetable/1B";
            };
            thunderbird.color = "#b5149d";
          };
          nadomescanja.remote.url = "https://urnik.gimvic.org/api/calendar/substitutions/1B";
          nadomescanja.thunderbird.color = "#1417b5";
          kosilo.remote.url = "https://urnik.gimvic.org/api/calendar/schedules/1B";
          kosilo.thunderbird.color = "#803e00";
        };
  accounts.contact.accounts.addressbook = addAllFieldsToCalendar {
    remote = {
      type = "carddav";
      url = "https://dav.gregtech.eu/gregor/addressbook/";
    };
  };
}
