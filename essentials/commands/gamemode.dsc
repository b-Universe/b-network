gamemode_command:
  type: command
  name: gamemode
  debug: false
  description: Opens the gamemode GUI
  usage: /gamemode
  script:
  # % ██ [ check if typing arguments               ] ██:
    - if !<context.args.is_empty>:
      - inject command_syntax_error

  # % ██ [ open the gui                            ] ██:
    - define items <list[air]>
    - foreach builder|creative|survival|spectator as:gamemode:
      - define item <item[gamemode_button].with[display=<&b><[gamemode].to_titlecase>].with_flag[gamemode:<[gamemode]>]>
      - if <player.has_flag[behr.essentials.permission.<[gamemode]>]>:
        - if <player.flag[behr.essentials.gamemode]> == <[gamemode]>:
          - define item <[item].with[material=lime_stained_glass]>
          - define item <[item].with[lore=<&a>Current gamemode]>

        - else:
          - define item <[item].with[material=white_stained_glass]>
          - define item <[item].with[lore=<&a><&a>Click to change to|<&a><[gamemode]> gamemode]>

      - else:
        - define item <[item].with[material=black_stained_glass]>
        - define item <[item].with[lore=<&c>Unavailable]>

      - define items <[items].include_single[<[item]>].include_single[air]>
      - define inventory <inventory[gamemode_main_menu]>
      - inventory set destination:<[inventory]> origin:<[items].remove[last]>
      - flag server behr.essentials.guis.gamemode.pregenerated:<[inventory]>
      - inventory open d:<server.flag[behr.essentials.guis.gamemode.pregenerated]>
      - playsound <player> entity_player_levelup pitch:<util.random.decimal[0.8].to[1.2]> volume:0.3 if:<player.has_flag[behr.essentials.settings.playsounds]>

gamemode_menu_handler:
  type: world
  debug: false
  events:
    after player clicks gamemode_button in gamemode_main_menu:
      - define new_gamemode <context.item.flag[gamemode]>
      - define current_gamemode <player.flag[behr.essentials.gamemode]>
      - playsound <player> entity_player_levelup pitch:<util.random.decimal[0.8].to[1.2]> volume:0.3 if:<player.has_flag[behr.essentials.settings.playsounds]>

      - if <[current_gamemode]> == <[new_gamemode]>:
        - narrate "<&c>You're already in <[new_gamemode]>"
        - stop

      - if !<player.has_flag[behr.essentials.permission.<[new_gamemode]>]>:
        - narrate "<&c>That gamemode is unavailable"
        - stop

      - if <[new_gamemode]> == builder:
        - inject builder_gamemode_task

      - definemap slot_map:
          2: builder
          4: creative
          6: survival
          8: spectator

      - inventory adjust destination:<context.inventory> slot:<context.slot> material:lime_stained_glass
      - inventory adjust destination:<context.inventory> slot:<context.slot> "lore:<&a>Current gamemode"
      - define old_slot <[slot_map].invert.get[<[current_gamemode]>]>
      - inventory adjust destination:<context.inventory> slot:<[old_slot]> material:white_stained_glass
      - inventory adjust destination:<context.inventory> slot:<[old_slot]> "lore:<&a>Click to change to|<&a><[slot_map.<[old_slot]>]> gamemode"

      - flag <player> behr.essentials.last_gamemode:<[current_gamemode]>
      - flag <player> behr.essentials.gamemode:<[new_gamemode]>
      - adjust <player> gamemode:<[new_gamemode]>
      - narrate "<&a>Changed gamemode to <[new_gamemode]>"

    after player joins flagged:!behr.essentials.gamemode:
      - flag player behr.essentials.gamemode:survival

gamemode_main_menu:
  type: inventory
  debug: false
  inventory: chest
  title: Select Gamemode
  size: 9
  gui: true
  definitions:
    x: air
  slots:
    - [x] [] [x] [] [x] [] [x] [] [x]

gamemode_button:
  type: item
  debug: false
  material: stone
  mechanisms:
    hides: all

gmb_command:
  type: command
  debug: false
  name: gmb
  description: Changes your gamemode to builder
  usage: /gmb
  script:
    - inject gamemode_alias_task

gmc_command:
  type: command
  name: gmc
  debug: false
  description: Changes your gamemode to creative
  usage: /gmc
  script:
    - inject gamemode_alias_task

gms_command:
  type: command
  name: gms
  debug: false
  description: Changes your gamemode to survival
  usage: /gms
  script:
    - inject gamemode_alias_task

gmsp_command:
  type: command
  name: gmsp
  debug: false
  description: Changes your gamemode to spectator
  usage: /gmsp
  script:
    - inject gamemode_alias_task

gamemode_alias_task:
  type: task
  debug: false
  data:
    alias_map:
      gma: adventure
      gmb: builder
      gmc: creative
      gms: survival
      gmsp: spectator
  script:
  # % ██ [ check if using too many arguments       ] ██
    - if <context.args.size> > 1:
      - narrate "<&c>Invalid usage"
      - stop

    - else if <context.args.is_empty>:
      - define player <player>
    - else:
      - define player_name <context.args.first>
      - inject command_player_verification

    - define new_gamemode <script.data_key[data.alias_map].get[<context.alias>]>
    - define current_gamemode <[player].flag[behr.essentials.gamemode].if_null[survival]>
    - define gamemodes <script.data_key[data.alias_map].values>

    - if <[new_gamemode]> !in <[gamemodes]>:
        - narrate "<&c>Invalid usage - <&e>valid options are <[gamemodes].exclude[<[current_gamemode]>].filter_tag[<player.has_flag[behr.essentials.permission.<[filter_value]>]>].comma_separated>"
        - stop

    - if <[current_gamemode]> == <[new_gamemode]>:
      - if <[player]> == <player>:
        - narrate "<&c>You're already in <[new_gamemode]>"
      - else:
        - narrate "<&e><[player_name]> <&c>is already in <[new_gamemode]>"
      - stop

    - if !<player.has_flag[behr.essentials.permission.<[new_gamemode]>]>:
      - if <[player]> == <player>:
        - narrate "<&c>That gamemode is unavailable"
      - else:
        - narrate "<&c>That gamemode is unavailable for you to change"
      - stop

    - if <[new_gamemode]> == builder:
      - run builder_gamemode_task def:<[player]>

    - flag <[player]> behr.essentials.last_gamemode:<[current_gamemode]>
    - flag <[player]> behr.essentials.gamemode:<[new_gamemode]>
    - adjust <[player]> gamemode:<[new_gamemode]>
    - if <[player]> != <player>:
      - narrate "<&e><[player_name]><&a>'s gamemode changed to <[new_gamemode]>"
    - narrate "<&a>Changed gamemode to <[new_gamemode]>" targets:<[player]>
