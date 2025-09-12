time_command:
  type: command
  name: time
  debug: false
  description: Changes the time of day
  usage: /time <&lt>time of day/0-23999<&gt>
  tab completions:
    1: day|noon|sunset|bedtime|dusk|night|midnight|sunrise|dawn
  data:
    time_of_day:
      day: 1000t
      noon: 6000t
      sunset: 11615t
      bedtime: 12542t
      dusk: 12786t
      night: 13000t
      midnight: 18000t
      sunrise: 22200t
      dawn: 23216t
  script:
  # % ██ [ Check Args ] ██
    - if <context.args.is_empty>:
      - inject command_syntax_error

  # % ██ [ Check if Arg is a number ] ██
    - if <context.args.first.is_integer>:
      - define time <context.args.first>

    # % ██ [ Check if number is a valid number for usage ] ██
      - if <[time]> < 0:
        - define reason "Time cannot be negative"
        - inject command_error

      - if <[time]> > 23999:
        - define reason "Time cannot exceed 23999"
        - inject command_error

      - if <[time].contains[.]>:
        - define time <[time].round.min[23999].max[0]>

      - time <[time]>t
      - define time_name <[time]>

  # % ██ [ Match time with time of day by name ] ██
    - else:
      - define time_name <context.args.first>
      - define time <script.data_key[data.time_of_day.<[time_name]>].if_null[null]>

      - if !<[time].is_truthy>:
        - inject command_syntax_error

    - playsound <player> entity_player_levelup pitch:<util.random.decimal[0.8].to[1.2]> volume:0.3 if:<player.has_flag[behr.essentials.settings.playsounds]>
    - time <[time]>
    - narrate "<&[green]>Time set to <&[yellow]><[time_name]>"

time_menu_gui:
  type: inventory
  debug: false
  inventory: chest
  title: <script.parsed_key[data.title].unseparated>
  size: 27
  gui: true
  data:
    title:
      - <proc[bbackground].context[27|e007]>
      - <proc[sp].context[50]>
      - <element[<player.weather.if_null[Sunny]>].color[<proc[prgb]>].font[minecraft_15.5]>
  definitions:
    bedtime: book[display=<&[green]>Bedtime;lore=<&[yellow]>Click to set;flag=set_time:Bedtime]
    dawn: book[display=<&[green]>Dawn;lore=<&[yellow]>Click to set;flag=set_time:Dawn]
    day: book[display=<&[green]>Day;lore=<&[yellow]>Click to set;flag=set_time:Day]
    dusk: book[display=<&[green]>Dusk;lore=<&[yellow]>Click to set;flag=set_time:Dusk]
    midnight: book[display=<&[green]>Midnight;lore=<&[yellow]>Click to set;flag=set_time:Midnight]

    night: book[display=<&[green]>Night;lore=<&[yellow]>Click to set;flag=set_time:Night]
    noon: book[display=<&[green]>Noon;lore=<&[yellow]>Click to set;flag=set_time:Noon]
    start: book[display=<&[green]>Start;lore=<&[yellow]>Click to set;flag=set_time:Start]
    sunrise: book[display=<&[green]>Sunrise;lore=<&[yellow]>Click to set;flag=set_time:Sunrise]
    sunset: book[display=<&[green]>Sunset;lore=<&[yellow]>Click to set;flag=set_time:Sunset]
    clear: book[display=<&[green]>Clear;flag=weather:clear]

    lock: book[display=<&[green]>lock;lore=<&[yellow]>Click to lock;flag=set_time:lock]
    unlock: book[display=<&[green]>unlock;lore=<&[yellow]>Click to unlock;flag=set_time:unlock]

    command_menu: inventory_item[display=Back;custom_model_data=1;flag=menu:commands]
  slots:
    - [] [start] [day] [noon] [sunset] [bedtime] [lock] [] []
    - [] [dusk] [night] [midnight] [sunrise] [dawn] [unlock] [] [command_menu]
