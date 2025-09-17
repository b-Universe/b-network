max_health_command:
  type: command
  name: max_health
  debug: false
  description: Adjusts yours or another player's max health from 1 to 100
  usage: /max_health (player) <&lt>1-100<&gt>
  aliases:
    - maxhp
  tab completions:
    1: <server.online_players.exclude[<player>].parse[name]>
  script:
  # % ██ [ check if typing too many or no arguments ] ██
    - if <context.args.is_empty> || <context.args.size> > 2:
      - inject command_syntax_error

  # % ██ [ check if specifying another player       ] ██
    - if <context.args.size> == 2:
      - define player_name <context.args.first>
      - inject command_player_verification
      - define max_hp <context.args.last>

    # % ██ [ default to using themself              ] ██
    - else:
      - define player <player>
      - define max_hp <context.args.first>


  # % ██ [ check maximum health input               ] ██
    - if !<[max_hp].is_integer>:
      - define reason "Health is measured as a number."
      - inject command_error

    - if <[max_hp]> < 1:
      - define reason "Health cannot be negative or below 1."
      - inject command_error

    - if <[max_hp].contains[.]>:
      - define reason "Health cannot have a decimal."
      - inject command_error

    - if <[max_hp]> > 100:
      - define reason "Health can range up to 100."
      - inject command_error

  # % ██ [ adjust player's maximum health           ] ██
    - adjust <[player]> max_health:<[max_hp]>
    - if <[player]> != <player>:
      - narrate "<&[yellow]><[player_name]><&[green]><&sq>s maximum health adjusted to <&[yellow]><[max_hp]>"
    - narrate targets:<[player]> "<&[green]>Maximum health adjusted to <&[yellow]><[max_hp]>"
    - playsound <server.online_players> sound:entity_lightning_bolt_thunder if:<list[storm|thunder].contains[<[weather]>]>
