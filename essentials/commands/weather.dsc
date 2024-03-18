weather_command:
  type: command
  name: weather
  debug: false
  description: Adjusts the weather to sunny, clear, stormy, or thundery
  usage: /weather <&lt>weather<&gt>
  tab completions:
    1: sunny|storm|thunder|clear
  script:
    # ██ [ return the current world's weather     ] ██:
    - if <context.args.is_empty>:
      - inventory open destination:weather_menu_gui
      - playsound <player> entity_player_levelup pitch:<util.random.decimal[0.8].to[1.2]> volume:0.3 if:<player.has_flag[behr.essentials.settings.playsounds]>
      - stop

    # ██ [ define the weather being set           ] ██:
    - if <context.args.first> == clear:
      - define weather sunny
    - else:
      - define weather <context.args.first>

    # ██ [ check if using command wrongly         ] ██:
    - if <context.args.size> > 1:
      - inject command_syntax_error

    # ██ [ check if specifying an invalid weather ] ██:
    - if !<list[sunny|storm|thunder|clear].contains[<[weather]>]>:
      - define reason "The only valid weathers are clear or sunny, storm, and thunder"
      - inject command_error


    # ██ [ change the weather                     ] ██:
    - weather <[weather]> <player.world>
    - playsound <player> entity_player_levelup pitch:<util.random.decimal[0.8].to[1.2]> volume:0.3 if:<player.has_flag[behr.essentials.settings.playsounds]>
    - narrate "<&[green]>Weather changed to <[weather].to_titlecase>"

    # ██ [ realism for thunder and stormy weather ] ██:
    - wait 1s
    - playsound <server.online_players> sound:entity_lightning_bolt_thunder if:<list[storm|thunder].contains[<[weather]>]>

weather_menu_gui:
  type: inventory
  debug: false
  inventory: chest
  title: <script.parsed_key[data.title].unseparated>
  size: 27
  gui: true
  data:
    title:
      - <proc[bbackground].context[27|e006]>
      - <proc[sp].context[50]>
      - <element[<player.weather.if_null[Sunny]>].color[<proc[prgb]>].font[minecraft_15.5]>
  definitions:
    clear: weather_clear_button
    stormy: weather_stormy_button
    sunny: weather_sunny_button
    thunder: weather_thunder_button
    lock: weather_lock_button
  slots:
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [clear] [stormy] [sunny] [thunder] [lock] [] []

open_weather_menu:
  type: task
  debug: false
  script:
    - inventory open d:weather_menu_gui

weather_clear_button:
  type: item
  debug: false
  material: mojang_banner_pattern
  display name: <&color[<proc[prgb]>]>Clear Weather
  mechanisms:
    hides: all
  flags:
    weather: clear

weather_stormy_button:
  type: item
  debug: false
  material: mojang_banner_pattern
  display name: <&color[<proc[prgb]>]>Stormy Weather
  mechanisms:
    hides: all
  flags:
    weather: stormy

weather_sunny_button:
  type: item
  debug: false
  material: mojang_banner_pattern
  display name: <&color[<proc[prgb]>]>Sunny Weather
  mechanisms:
    hides: all
  flags:
    weather: sunny

weather_thunder_button:
  type: item
  debug: false
  material: mojang_banner_pattern
  display name: <&color[<proc[prgb]>]>Thunder Weather
  mechanisms:
    hides: all
  flags:
    weather: thunder

weather_lock_button:
  type: item
  debug: false
  material: mojang_banner_pattern
  display name: <&color[<proc[prgb]>]>Lock Weather
  mechanisms:
    hides: all
  flags:
    weather: lock

weather_gui_handler:
  type: world
  debug: false
  events:
    on player clicks weather_* in weather_menu_gui:
      - stop if:!<context.item.has_flag[weather]>
      - determine passively cancelled

      - define weather <context.item.flag[weather]>
      - define world <player.world.name>
      - choose <[weather]>:
      # weather ({global}/player) [sunny/storm/thunder/reset] (<world>) (reset:<duration>)
        - case stormy storm:
          - if <server.has_flag[behr.essentials.weather.world.<[world]>.weather]> && <list[stormy|storm].contains[<server.flag[behr.essentials.weather.world.<[world]>.weather]>]>:
            - narrate "<&[red]>Weather for <&[yellow]><[world]> <&[red]>is already set to <&[yellow]><[weather]>"
          - else:
            - narrate "<&[green]>Weather for <&[yellow]><[world]> <&[green]>set to <&[yellow]><[weather]>"

          - if <server.has_flag[behr.essentials.weather.world.<[world]>.lock]>:
            - weather storm reset:1d
            - flag server behr.essentials.weather.world.<[world]>.weather:storm expire:1d
          - else:
            - weather <[weather]> reset:1h
            - flag server behr.essentials.weather.world.<[world]>.weather:storm expire:1h

        - case clear sunny:
          - if <server.has_flag[behr.essentials.weather.world.<[world]>.weather]> && <list[sunny|clear].contains[<server.flag[behr.essentials.weather.world.<[world]>.weather]>]>:
            - narrate "<&[red]>Weather for <&[yellow]><[world]> <&[red]>is already set to <&[yellow]><[weather]>"
          - else:
            - narrate "<&[green]>Weather for <&[yellow]><[world]> <&[green]>set to <&[yellow]><[weather]>"

          - if <server.has_flag[behr.essentials.weather.world.<[world]>.lock]>:
            - weather sunny reset:1d
            - flag server behr.essentials.weather.world.<[world]>.weather:sunny expire:1d
          - else:
            - weather <[weather]> reset:1h
            - flag server behr.essentials.weather.world.<[world]>.weather:sunny expire:1h

        - case thunder:
          - if <server.has_flag[behr.essentials.weather.world.<[world]>.weather]> && <server.flag[behr.essentials.weather.world.<[world]>.weather]> == thunder:
            - narrate "<&[red]>Weather for <&[yellow]><[world]> <&[red]>is already set to <&[yellow]><[weather]>"
          - else:
            - narrate "<&[green]>Weather for <&[yellow]><[world]> <&[green]>set to <&[yellow]>thunder"

          - if <server.has_flag[behr.essentials.weather.world.<[world]>.lock]>:
            - weather <[weather]> reset:1d
            - flag server behr.essentials.weather.world.<[world]>.weather:thunder expire:1d
          - else:
            - weather <[weather]> reset:1h
            - flag server behr.essentials.weather.world.<[world]>.weather:thunder expire:1h

        - case lock:
          - if <server.has_flag[behr.essentials.weather.world.<[world]>.lock]>:
            - weather reset
            - flag server behr.essentials.weather.world.<[world]>.lock:!
            - narrate "<&[green]> Weather for <&[yellow]><[world]> <&[green]>unlocked"

          - else:
            - flag server behr.essentials.weather.world.<[world]>.lock
            - if <server.has_flag[behr.essentials.weather.world.<[world]>.weather]>:
              - narrate "<&[green]>Weather for <&[yellow]><[world]> <&[green]>locked to <&[yellow]><server.flag[behr.essentials.weather.world.<[world]>.weather]>"

            - else:
              - if <player.world.has_storm>:
                - flag player behr.essentials.weather.world.<[world]>.weather:storm expire:1d
                - weather storm reset:1h

              - else if <player.world.thundering>:
                - flag player behr.essentials.weather.world.<[world]>.weather:thunder expire:1d
                - weather thunder reset:1h

              - else:
                - flag player behr.essentials.weather.world.<[world]>.weather:sunny expire:1d
                - weather sunny reset:1h

              - narrate "<&[green]>Weather for <&[yellow]><[world]> <&[green]>unlocked"
