suicide_command:
  type: command
  name: suicide
  debug: false
  description: Kills yourself
  usage: /suicide
  permission: behr.essentials.suicide
  script:
  # % ██ [ Check Args ] ██
    - if !<context.args.is_empty>:
      - inject command_syntax_error

  # % ██ [ Check player's Gamemode ] ██
    - if <player.gamemode.advanced_matches[spectator|creative]>:
      - repeat 10:
        - animate <player> animation:hurt
        - wait 2t
      - adjust <player> health:0

  # % ██ [ Kill Self ] ██
    - else:
      - define gamemode <player.gamemode>
      - while <player.health> > 0 || <player.is_online>:
        - if <player.gamemode> != <[gamemode]>:
          - kill <player>
          - while stop
        - adjust <player> no_damage_duration:1t
        - hurt 1
        - wait 2t
