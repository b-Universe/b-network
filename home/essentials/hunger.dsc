hunger_command:
  type: command
  name: hunger
  debug: false
  description: Hungers or satiates another player's or your own hunger
  usage: /hunger (player) <&lt>#<&gt>
  permission: behr.essentials.hunger
  aliases:
    - feed
  tab completions:
    1: <server.online_players.exclude[<player>].parse[name]>
  script:
  # % ██ [ check if typing too many or no arguments ] ██
    - if <context.args.is_empty> || <context.args.size> > 2:
      - inject command_syntax_error

  # % ██ [ check if using self or named player      ] ██
    - if <context.args.size> == 1:
      - define player <player>
      - define level <context.args.first>

    - else:
      - define player_name <context.args.first>
      - inject player_verification
      - define level <context.args.last>

  # % ██ [ check hunger level ] ██
    - if !<[level].is_integer>:
      - define reason "Hunger must be a number"
      - inject command_error

    - if <[level]> > 20:
      - define reason "Hunger must be less than 20"
      - inject command_error

    - if <[level]> < 0:
      - define reason "Hunger must be between 0-20"
      - inject command_error

    - if <[level].contains_text[.]>:
      - define reason "Hunger cannot be a decimal"
      - inject command_error

  # % ██ [ check food adjustment direction & narrate ] ██
  # % ██ [ satiate hunger                            ] ██
    - if <[player].food_level> > <[level]>:
      - if <[player]> != <player>:
        - narrate "<&[yellow]><[player_name]><&[green]>'s hunger was satiated"
      - narrate targets:<[player]> "<&[green]>Your hunger was satiated"

  # % ██ [ did nothing / stayed the same             ] ██
    - else if <[player].food_level> == <[level]>:
      - define text "<&[yellow]>>Nothing interesting happens"
      - define hover "<&[yellow]><[player].name><[green]><&sq>s food level is already <&[yellow]><[player].food_level>
      - narrate <[text].on_hover[<[hover]>]>
      - stop

  # % ██ [ starve the player                         ] ██
    - else if <[player].food_level> < <[level]>:
      - if <[player]> != <player>:
        - narrate "<&[yellow]><[player].name><&[green]><&sq>s hunger was intensified"
      - narrate targets:<[player]> "<&[red]>Your hunger intensifies"

  # % ██ [ adjust the satiation and food level       ] ██
    - adjust <[player]> food_level:<[level]>
    - feed <[player]> saturation:20
