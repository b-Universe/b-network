heal_command:
  type: command
  name: heal
  debug: false
  description: Heals yourself or another player
  usage: /heal (player)
  tab completions:
    1: <server.online_players.exclude[<player>].parse[name]>
  script:
    - if <context.args.is_empty>:
      - define player <player>

    - else if <context.args.size> == 1:
      - define player_name <context.args.first>
      - inject command_online_player_verification

    - else:
      - inject command_syntax_error

    - heal <[player]>
    - adjust <[player]> food_level:20
    - foreach blindness|confusion|darkness|poison|slow|slow_digging|weakness|wither as:effect:
      - cast <[effect]> remove
    - if <[player]> != <player>:
      - narrate "<&[yellow]><[player_name]> <&[green]>was healed"
    - narrate targets:<[player]> "<&[green]>You were healed"

    - playsound <player> entity_player_levelup pitch:<util.random.decimal[0.8].to[1.2]> volume:0.3 if:<player.has_flag[behr.essentials.settings.playsounds]>
    - repeat 100 as:i:
      - playeffect at:<[player].location.add[<location[1,0,0].rotate_around_y[<[i].mul[183].to_radians>]>].above[<[i].div[40]>]> effect:villager_happy offset:0.05
      - if <[i].mod[10].equals[0]>:
        - wait 1t
        - playeffect at:<[player].location.above> effect:electric_spark offset:0.5 quantity:10
