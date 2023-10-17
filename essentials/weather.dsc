weather_command:
  type: command
  name: weather
  debug: false
  description: Adjusts the weather to sunny, clear, stormy, or thundery
  usage: /weather <&lt>weather<&gt>
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

    - if <context.args.size> > 1:
      - definemap message:
          text: <&c>Invalid usage - <&6>/<&e>weather <&6><&lt><&e>weather<&6><&gt>
          hover: <&a>Click to insert<&co><n><&6>/<&e>weather<n><&c>You typed<&co> <underline><context.alias> <context.raw_args>
      - narrate <[message.text].on_hover[<[message.hover]>].on_click[/weather ].type[suggest_command]>
      - stop

    - if !<list[sunny|storm|thunder|clear].contains[<[weather]>]>:
      - definemap message:
          text: <&c>Invalid usage - <&e>the only valid weathers are clear or sunny, storm, and thunder
          hover: <&a>Click to insert<&co><n><&6>/<&e>weather<n><&c>You typed<&co> <underline><context.alias> <context.raw_args>
      - narrate <[message.text].on_hover[<[message.hover]>].on_click[/weather ].type[suggest_command]>
      - stop

    - weather <[weather]> <player.world>
    - playsound <player> entity_player_levelup pitch:<util.random.decimal[0.8].to[1.2]> volume:0.3 if:<player.has_flag[behr.essentials.settings.playsounds]>
    - narrate "<&a>Weather changed to <[weather].to_titlecase>"
    - wait 1s
    - playsound <server.online_players> sound:entity_lightning_bolt_thunder if:<list[storm|thunder].contains[<[weather]>]>
