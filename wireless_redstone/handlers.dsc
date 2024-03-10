wireless_redstone_material_handler:
  type: world
  debug: false
  events:
    on item moves from inventory to inventory:
      - determine cancelled if:<context.destination.location.has_flag[behr.essentials.wireless_redstone]>

    on wireless_redstone_display_block spawns:
      - define block_entity <context.entity>
      - flag server behr.essentials.bedit.display_blocks:->:<[block_entity]>
      - define blocks <list[<[block_entity].location.left>|<[block_entity].location.right>|<[block_entity].location.forward>|<[block_entity].location.backward>|<[block_entity].location.up>]>
      - define block_light <[blocks].parse[light.blocks].exclude[0]>
      - if <[block_light].is_empty>:
        - define block_light 0
      - else:
        - define block_light <[block_light].sum.div[<[block_light].size>].round>
      - define sky_light <[blocks].parse[light.sky].highest.max[<[blocks].parse[light].highest>]>
      - adjust <[block_entity]> brightness:<map[sky=<[sky_light]>;block=<[block_light]>]>

    after time changes:
    - define wireless_blocks <server.flag[behr.essentials.wireless_redstone.locations].parse[flag[behr.essentials.wireless_redstone.entity]].filter[is_truthy]>
    - foreach <[wireless_blocks]> as:block_entity:
      - if <[loop_index].mod[25]> == 0:
        - wait 1t
      - define blocks <list[<[block_entity].location.left>|<[block_entity].location.right>|<[block_entity].location.forward>|<[block_entity].location.backward>|<[block_entity].location.up>]>
      - define block_light <[blocks].parse[light.blocks].exclude[0]>
      - if <[block_light].is_empty>:
        - define block_light 0
      - else:
        - define block_light <[block_light].sum.div[<[block_light].size>].round>
      - define sky_light <[blocks].parse[light.sky].highest.max[<[blocks].parse[light].highest>]>
      - define data <[block_entity].brightness>
      - if <[data.sky]> == <[sky_light]> && <[data.block]> == <[block_light]>:
        - foreach next
      - adjust <[block_entity]> brightness:<map[sky=<[sky_light]>;block=<[block_light]>]>

    on player places dispenser:
      - stop if:!<context.item_in_hand.has_flag[wireless_redstone]>

      - define location <context.location>
      - define item <context.item_in_hand.flag[wireless_redstone]>

      - flag server behr.essentials.wireless_redstone.locations:->:<[location]>
      - spawn wireless_redstone_display_block[item=wireless_<[item]>_block] <[location].center> save:block

      - flag <[location]> behr.essentials.wireless_redstone.material:<[item]>
      - flag <[location]> behr.essentials.wireless_redstone.entity:<entry[block].spawned_entity>
      - flag <[location]> behr.essentials.wireless_redstone.frequency:0

      - choose <[item]>:
        - case receiver:
          - define transmitters <[location].proc[find_wireless_blocks].context[transmitter|0|true]>
          - if !<[transmitters].is_empty>:
            - wait 1t
            - adjust <entry[block].spawned_entity> item:wireless_receiver_block[custom_model_data=1003]
            - playeffect at:<[location].center> effect:REDSTONE offset:0.5 special_data:1|255,0,0 quantity:10
            - playeffect at:<[location].center> effect:electric_spark offset:0.5 quantity:10
            - playsound at:<[location]> sound:block_amethyst_cluster_place pitch:<util.random.int[7].to[10].div[10]> volume:2
            - modifyblock <[location]> redstone_block

    on player breaks dispenser|redstone_block location_flagged:behr.essentials.wireless_redstone:
      - define location <context.location>

      - choose <[location].flag[behr.essentials.wireless_redstone.material]>:
        - case transmitter:
          - determine passively wireless_transmitter_Block if:<player.gamemode.equals[survival]>
        - case receiver:
          - determine passively wireless_receiver_block if:<player.gamemode.equals[survival]>

      - if <[location].flag[behr.essentials.wireless_redstone.material]> == transmitter:
        - run wireless_redstone_deactivate_transmitter_task def:<[location]>

      - flag server behr.essentials.wireless_redstone.locations:<-:<[location]>
      - remove <[location].flag[behr.essentials.wireless_redstone.entity]>
      - flag <[location]> behr.essentials.wireless_redstone:!

    on block physics location_flagged:behr.essentials.wireless_redstone:
      - define location <context.location>
      - stop if:<[location].has_flag[behr.essentials.wireless_redstone.ratelimited]>
      - stop if:<server.has_flag[behr.essentials.wireless_ratelimit.<[location].simple>]>
      - flag server behr.essentials.wireless_ratelimit.<[location].simple> expire:2t

      - wait 1t
      - if <[location].flag[behr.essentials.wireless_redstone.material]> != transmitter:
        - stop

      - if <[location].switched>:
        - run wireless_redstone_activate_transmitter_task def:<[location]>

      - else:
        - run wireless_redstone_deactivate_transmitter_task def:<[location]>

    on player right clicks dispenser|redstone_block location_flagged:behr.essentials.wireless_redstone:
      - if <player.is_sneaking> && <player.item_in_hand.is_truthy>:
        - stop
      - determine passively cancelled
      - wait 1t
      - flag player behr.essentials.wireless_redstone_gui.location:<context.location>
      - flag player behr.essentials.wireless_redstone_gui.frequency:<context.location.flag[behr.essentials.wireless_redstone.frequency].if_null[0]>
      - if !<inventory[wireless_redstone_<context.location.simple>].exists>:
        - note <inventory[wireless_configuration_gui]> as:wireless_configuration_gui_<context.location.simple>
        - adjust <inventory[wireless_configuration_gui_<context.location.simple>]> title:<script[wireless_configuration_gui].parsed_key[data.title].unseparated><context.location.flag[behr.essentials.wireless_redstone.frequency].if_null[0]>
      - inventory open destination:wireless_configuration_gui_<context.location.simple>
