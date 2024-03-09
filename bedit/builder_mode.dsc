buildermode_command:
  type: command
  name: buildermode
  debug: false
  description: Adjusts another user or your gamemode
  usage: /buildermode (player (duration))
  tab completions:
    1: <server.online_players.parse[name].exclude[<player.name>]>
  aliases:
    - gmb
  script:
    - if <player.has_flag[behr.essentials.gamemode.builder_mode]>:
      - flag <player> behr.essentials.gamemode.builder_mode:!
      - repeat 5 as:slot:
        - inventory set slot:<[slot]> o:air d:<player.open_inventory>
      - narrate "<&[green]>Builder mode deactivated"
      - stop

    - flag <player> behr.essentials.gamemode.builder_mode
    - if !<player.has_flag[behr.essentials.builder_mode.flight_disabled]>:
      - adjust <player> can_fly:true
    - run builder_gamemode_task def:<player>
    - run builder_inventory_task def:<player>

builder_gamemode_task:
  type: task
  definitions: player
  script:
    - if !<player.has_flag[behr.essentials.permission.builder]>:
      - narrate "<&e>Nothing interesting happens"
      - stop

    - flag <[player]> behr.essentials.last_gamemode:<[player].gamemode>
    - flag <[player]> behr.essentials.gamemode:builder
    - adjust <[player]> gamemode:survival
    - adjust <[player]> can_fly:true
    - adjust <[player]> flying:!<[player].is_on_ground>
    - if <[player]> != <[player]>:
      - narrate "<&e><[player].name><&a>'s gamemode changed to builder"
    - narrate "<&a>Changed gamemode to builder" targets:<[player]>


builder_inventory_task:
  type: task
  definitions: player
  data:
    items:
      - inventory_item[color=<color[red].with_hue[100]>;display=<&[green]>commands;flag=menu:commands]
      - inventory_item[color=<color[red].with_hue[120]>;display=<&[green]>teleport menu;flag=menu:teleport]
      - inventory_item[color=<color[red].with_hue[140]>;display=<&[green]>materials;flag=menu:materials]
      - inventory_item[color=<color[red].with_hue[160]>;display=<&[green]>crafting;flag=menu:crafting]

  script:
    - if <player.inventory> != <player.open_inventory>:
      - wait 1t

    - stop if:!<player.inventory.equals[<player.open_inventory.if_null[null]>]>

    - define inventory <player.open_inventory>

    # Needed to prevent death dropping
    - repeat 5 as:slot:
      - inventory set destination:<[inventory]> origin:air slot:<[slot]>
      #- give to:<[inventory]> air slot:<[slot]>
    - wait 1t

    - stop if:<player.is_online.not>
    - foreach <script.parsed_key[data.items]> as:item:
      - inventory set destination:<[inventory]> origin:<[item]> slot:<[loop_index].add[1]>
      #- give to:<[inventory]> <[item]> slot:<[loop_index].add[1]>
    - wait 1t

    # this is the far right edge of the screen
    #- inventory set slot:1 o:sand d:<[inventory]>
    - inventory update

book_o_builders:
  type: item
  material: book
  display name: <&b>Book o' Builders
  lore:
    - <&e>Shift+click <&3>to open
  flags:
    builder_gamemode_item: <util.random.duuid>

    #on player clicks block with:book_o_builders:
    #  - determine passively cancelled
    #  - wait 2t
    #  - stop if:!<player.is_sneaking>

#testing_hndlty:
#  type: world
#  debug: false
#  events:
#    on player clicks item in inventory:
#      - narrate <context.slot>
#      - narrate <context.inventory>
#      - narrate <context.clicked_inventory>


test_stuff:
  type: task
  script:
    - repeat 50:
      - inventory set destination:<player.inventory> origin:stone slot:<[value]>
      - narrate <[value]>
      - wait 1t

    - narrate <player.inventory>
    - narrate <player.inventory.matrix>
    - narrate <player.open_inventory>
    - narrate <player.open_inventory.matrix>
    - adjust <player.inventory> matrix:sand|sand|sand|sand
    - adjust <player.open_inventory> matrix:sand|sand|sand|sand

#commands
#teleport
#materials
#crafting

builder_mode_handler:
  type: world
  debug: false
  events:
    after player joins flagged:behr.essentials.gamemode.builder_mode:
      #- inject builder_mode_handler.set_inventory
      - adjust <player> can_fly:true if:!<player.has_flag[behr.essentials.builder_mode.flight_disabled]>
      - if <player.has_flag[behr.essentials.builder_mode.logged_flying]>:
        - adjust <player> flying:true
        - flag player behr.essentials.builder_mode.logged_flying:!

    on player quits flagged:behr.essentials.gamemode.builder_mode:
      - if <player.is_flying>:
        - flag <player> behr.essentials.builder_mode.logged_flying

    #on player closes inventory flagged:behr.essentials.gamemode.builder_mode:
     # - inject builder_mode_handler.set_inventory

    on player dies flagged:behr.essentials.gamemode.builder_mode:
      - inventory close
      - inventory clear d:<player.open_inventory>

    on player teleports flagged:behr.essentials.gamemode.builder_mode:
      - inventory close
     # - inject builder_mode_handler.set_inventory

    on player uses recipe book flagged:behr.essentials.gamemode.builder_mode:
      - if <player.open_inventory.inventory_type> != WORKBENCH:
        - determine cancelled

    #on player respawns flagged:behr.essentials.gamemode.builder_mode:
     # - inject builder_mode_handler.set_inventory

    on player clicks item_flagged:builder_gamemode_item in inventory:
      - determine cancelled

    on player drops item_flagged:builder_gamemode_item:
      - determine cancelled

    on entity targets player flagged:behr.essentials.gamemode.builder_mode:
      - determine cancelled

    on player changes farmland into dirt flagged:behr.essentials.gamemode.builder_mode:
      - determine cancelled

    on player changes food level flagged:behr.essentials.gamemode.builder_mode:
      - determine cancelled

    on player combusts flagged:behr.essentials.gamemode.builder_mode:
      - determine cancelled

    on player damaged flagged:behr.essentials.gamemode.builder_mode:
      - determine cancelled

    on player changes xp flagged:behr.essentials.gamemode.builder_mode:
      - determine cancelled

    on player consumes item flagged:behr.essentials.gamemode.builder_mode:
      - determine cancelled

    on player empties lava_bucket flagged:behr.essentials.gamemode.builder_mode:
      - determine cancelled

    after player empties water_bucket flagged:behr.essentials.gamemode.builder_mode:
      - if <player.item_in_hand.material.name> == water_bucket:
        - inventory set slot:hand destination:<player.inventory> origin:water_bucket
      - else if <player.item_in_offhand.material.name> == water_bucket:
        - inventory set slot:offhand destination:<player.inventory> origin:water_bucket
      - else:
        - inventory set slot:<player.inventory.find_item[bucket]> origin:water_bucket

    on player item takes damage flagged:behr.essentials.gamemode.builder_mode:
      - determine cancelled

    on player picks up launched arrow flagged:behr.essentials.gamemode.builder_mode:
      - determine cancelled

    on player changes gamemode to creative|spectator flagged:behr.essentials.gamemode.builder_mode:
      - if <player.is_flying>:
        - flag <player> behr.essentials.builder_mode.was_flying

    on player changes gamemode to survival flagged:behr.essentials.gamemode.builder_mode:
     # - inject builder_mode_handler.set_inventory
      - adjust <player> can_fly:true if:!<player.has_flag[behr.essentials.builder_mode.flight_disabled]>
      - if <player.has_flag[behr.essentials.builder_mode.was_flying]>:
        - adjust <player> flying:true
        - flag player behr.essentials.builder_mode.was_flying:!
    #on player clicks inventory_item in inventory:
    #  - if <context.inventory> == <player.open_inventory> && <list[1|2|3|4|5].contains[<context.raw_slot>]>:
    #    - determine cancelled
#<proc[negative_spacing].context[40].font[utility:spaci].space_separated>
