suicide_command:
  type: command
  name: suicide
  debug: false
  description: Kills yourself
  usage: /suicide
  script:
  # % ██ [ check args ] ██
    - if !<context.args.is_empty>:
      - inject command_syntax_error

  # % ██ [ check player's gamemode ] ██
    - if <player.gamemode.advanced_matches[spectator|creative]>:
      - repeat 10:
        - animate <player> animation:hurt
        - wait 2t
      - adjust <player> health:0

  # % ██ [ kill self ] ██
    - else:
      - define gamemode <player.gamemode>
      - while <player.is_truthy>:
        - if <player.gamemode> != <[gamemode]>:
          - kill <player>
          - while stop
        - hurt 1
        - adjust <player> no_damage_duration:1t
        - wait 2t
