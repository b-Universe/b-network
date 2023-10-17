player_profiles:
  type: procedure
  definitions: uuid|type|time
  script:
    - define time <util.time_now> if:!<[time].format[MM-dd].is_truthy>
    - define time <[time].format[MM-dd]>

    - choose <[type]>:
      - case armor/body:
        - determine https://crafatar.com/renders/body/<[uuid].replace_text[-]>?overlay=true&scale=3&date=<[time]>
      - case armor/bust:
        - determine https://minotar.net/armor/bust/<[uuid].replace_text[-]>/100.png?date=<[time]>

# # Attribution
# > Attribution is not required, but it is encouraged.
# > If you want to show some support for this (free!) service, place a notice like this somewhere:
# > Thank you to <a href="https://crafatar.com">Crafatar</a> for providing avatars.
