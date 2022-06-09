weather_command:
  type: command
  name: weather
  debug: false
  description: Adjusts the weather to sunny, clear, stormy, or thundery
  usage: /weather <&lt>weather<&gt>
  permission: behr.essentials.weather
  tab completions:
    1: sunny|storm|thunder|clear
  script:
    - if <context.args.is_empty>:
      - if <player.world.has_storm>:
        - if <player.world.thundering>:
          - define weather thunder
        - else:
          - define weather storm
      - else:
        - define weather sunny

      - narrate "<&a>The weather is currently <[weather]>"
      - stop

    - if <context.args.first> == clear:
      - define weather sunny
    - else:
      - define weather <context.args.first>

    - else if <context.args.size> > 1:
      - narrate "<&c>Invalid usage - <&6>/<&e>weather <&6><&lt><&e>weather<&6><&gt>"
      - stop

    - else if !<[weather].advanced_matches[sunny|storm|thunder|clear]>:
      - narrate "<&c>Invalid usage - the only valid weathers are clear or sunny, storm, and thunder"
      - stop

    - weather <[weather]> <player.world>
    - announce "<&a>Weather changed to <[weather].to_titlecase>"
