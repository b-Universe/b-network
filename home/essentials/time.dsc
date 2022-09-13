time_command:
  type: command
  name: time
  debug: false
  description: Changes the time of day
  usage: /time <&lt>time of day/0-23999<&gt>
  permission: behr.essentials.time
  tab completions:
    1: start|day|noon|sunset|bedtime|dusk|night|midnight|sunrise|dawn
  script:
  # % ██ [ Check Args ] ██
    - if <context.args.is_empty>:
      - define text "<&[green]>The current world time of day is <&[yellow]><player.world.time>"
      - define hover "<&[green]>Click to insert<&co><n><script.parsed_key[usage].proc[command_syntax_format]>"
      - narrate "<[text].on_hover[<[hover]>].on_click[/time ].type[suggest_command]>"
      - stop

  # % ██ [ Check if Arg is a number ] ██
    - else if <context.args.first.is_integer>:
      - define time <context.args.first>

    # % ██ [ Check if number is a valid number for usage ] ██
      - if <[time]> < 0:
        - define reason "Time cannot be negative"
        - inject command_error

      - if <[time]> > 23999:
        - define reason "Time cannot exceed 23999"
        - inject command_error

      - if <[time].contains[.]>:
        - define reason "Time cannot contain decimals"
        - inject command_error

      - time <[time]>t
      - define time_name <[time]>

  # % ██ [ Match time with time of day by name ] ██
    - else:
      - choose <context.args.first>:
        - case start:
          - time 0
          - define time Start

        - case day:
          - time 1000t
          - define time Day

        - case noon:
          - time 6000t
          - define time Noon

        - case sunset:
          - time 11615t
          - define time Sunset

        - case bedtime:
          - time 12542t
          - define time Bedtime

        - case dusk:
          - time 12786t
          - define time Dusk

        - case night:
          - time 13000t
          - define time Night

        - case midnight:
          - time 18000t
          - define time Midnight

        - case sunrise:
          - time 22200t
          - define time Sunrise

        - case dawn:
          - time 23216t
          - define time Dawn

        - default:
          - inject command_syntax_error

    - narrate "<&[green]>Time set to <&[yellow]><[time]>"
