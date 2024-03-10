redstone_crystal:
  type: item
  debug: false
  material: stone
  display name: <&b>Redstone Crystal
  recipes:
    1:
      type: shaped
      input:
        - redstone|amethyst_shard|redstone
        - amethyst_shard|redstone|amethyst_shard
        - redstone|amethyst_shard|redstone

attuned_lever:
  type: item
  debug: false
  material: lever
  display name: <&b>Attuned Lever
  recipes:
    1:
      type: shaped
      input:
        - redstone_crystal|air|redstone_crystal
        - air|lever|air
        - redstone_crystal|air|redstone_crystal
    2:
      type: shaped
      input:
        - air|redstone_crystal|air
        - redstone_crystal|lever|redstone_crystal
        - air|redstone_crystal|air

attuned_observer:
  type: item
  debug: false
  material: observer
  display name: <&b>Attuned Observer
  recipes:
    1:
      type: shaped
      input:
        - redstone_crystal|air|redstone_crystal
        - air|lever|air
        - redstone_crystal|air|redstone_crystal
    2:
      type: shaped
      input:
        - air|redstone_crystal|air
        - redstone_crystal|observer|redstone_crystal
        - air|redstone_crystal|air

wireless_transmitter_block:
  type: item
  debug: false
  material: dispenser
  display name: <&b>Wireless Transmitter
  mechanisms:
    custom_model_data: 1002
  flags:
    wireless_redstone: transmitter
    frequency: 0
  recipes:
    1:
      type: shaped
      input:
        - iron_ingot|quartz|iron_ingot
        - quartz|attuned_lever|quartz
        - iron_ingot|quartz|iron_ingot
    2:
      type: shaped
      input:
        - quartz|iron_ingot|quartz
        - iron_ingot|attuned_lever|iron_ingot
        - quartz|iron_ingot|quartz

wireless_receiver_block:
  type: item
  debug: false
  material: dispenser
  display name: <&b>Wireless Receiver
  mechanisms:
    custom_model_data: 1004
  flags:
    wireless_redstone: receiver
    frequency: 0
  recipes:
    1:
      type: shaped
      input:
        - iron_ingot|quartz|iron_ingot
        - quartz|attuned_observer|quartz
        - iron_ingot|quartz|iron_ingot
    2:
      type: shaped
      input:
        - quartz|iron_ingot|quartz
        - iron_ingot|attuned_observer|iron_ingot
        - quartz|iron_ingot|quartz

wireless_repeater_block:
  type: item
  debug: false
  material: dispenser
  display name: <&b>Wireless Repeater
  mechanisms:
    custom_model_data: 1013
  flags:
    wireless_redstone: repeater
    frequency: 0
  recipes:
    1:
      type: shaped
      input:
        - iron_ingot|quartz|iron_ingot
        - quartz|repeater|quartz
        - iron_ingot|quartz|iron_ingot
    2:
      type: shaped
      input:
        - quartz|iron_ingot|quartz
        - iron_ingot|repeater|iron_ingot
        - quartz|iron_ingot|quartz
wireless_redstone_display_block:
  type: entity
  debug: false
  entity_type: item_display
  mechanisms:
    translation: -0.001,-0.001,-0.001
    scale: 1.0021,1.0021,1.0021

wireless_redstone_activate_transmitter_task:
  type: task
  debug: false
  definitions: location
  script:
    # base definitions
    - define frequency <[location].flag[behr.essentials.wireless_redstone.frequency]>
    - define receivers <[location].proc[find_wireless_blocks].context[receiver|<[frequency]>]>

    - if <[location].switched>:
      # activate both transmitter and receivers in range
      - adjust <[receivers].parse[flag[behr.essentials.wireless_redstone.entity]]> item:wireless_receiver_block[custom_model_data=1003]
      - adjust <[location].flag[behr.essentials.wireless_redstone.entity]> item:wireless_transmitter_block[custom_model_data=1001]

      - playeffect at:<[location].center> effect:REDSTONE offset:0.5 special_data:1|255,0,0 quantity:10
      - playeffect at:<[location].center> effect:electric_spark offset:0.5 quantity:10
      - playsound at:<[location]> sound:block_amethyst_cluster_place pitch:<util.random.int[7].to[10].div[10]> volume:2

      - foreach <[receivers].filter[advanced_matches[dispenser]]> as:receiver:
        - flag <[receiver]> behr.essentials.wireless_redstone.ratelimited
        - adjust <[receiver].flag[behr.essentials.wireless_redstone.entity]> item:wireless_receiver_block[custom_model_data=1003]
        - modifyblock <[receiver]> redstone_block
        - playeffect at:<[receiver].center> effect:REDSTONE offset:0.5 special_data:1|255,0,0 quantity:10
        - playeffect at:<[receiver].center> effect:electric_spark offset:0.5 quantity:10
        - playsound at:<[receiver]> sound:block_amethyst_cluster_place pitch:<util.random.int[7].to[10].div[10]> volume:2
        - flag <[receiver]> behr.essentials.wireless_redstone.ratelimited:!

    - else:
      - adjust <[location].flag[behr.essentials.wireless_redstone.entity]> item:wireless_transmitter_block[custom_model_data=1002]
      - foreach <[receivers]> as:receiver:
        - flag <[receiver]> behr.essentials.wireless_redstone.ratelimited
        - adjust <[receiver].flag[behr.essentials.wireless_redstone.entity]> item:wireless_receiver_block[custom_model_data=1004]
        - modifyblock <[receiver]> dispenser
        - flag <[receiver]> behr.essentials.wireless_redstone.ratelimited:!

wireless_redstone_deactivate_transmitter_task:
  type: task
  debug: false
  definitions: location
  script:
    # base definitions
    - define frequency <[location].flag[behr.essentials.wireless_redstone.frequency]>
    - define receivers <[location].proc[find_wireless_blocks].context[receiver|<[frequency]>]>

    - adjust <[location].flag[behr.essentials.wireless_redstone.entity]> item:wireless_transmitter_block[custom_model_data=1002]

    - playeffect at:<[location].center> effect:electric_spark offset:0.5 quantity:10

    - foreach <[receivers].filter[advanced_matches[redstone_block]]> as:receiver:
      - foreach next if:!<[location].proc[find_wireless_blocks].context[transmitter|<[frequency]>|true].is_empty>
      - flag <[receiver]> behr.essentials.wireless_redstone.ratelimited
      - adjust <[receiver].flag[behr.essentials.wireless_redstone.entity]> item:wireless_receiver_block[custom_model_data=1004]
      - modifyblock <[receiver]> dispenser
      - playeffect at:<[receiver].center> effect:electric_spark offset:0.5 quantity:10
      - playsound at:<[receiver]> sound:block_amethyst_cluster_place pitch:<util.random.int[7].to[10].div[10]> volume:2
      - flag <[receiver]> behr.essentials.wireless_redstone.ratelimited:!

wireless_redstone_refresh_receivers_task:
  type: task
  debug: false
  definitions: location|frequency
  script:
    # play effects
    - playeffect at:<[location].center> effect:electric_spark offset:0.5 quantity:10

    # check old frequency receivers
    - define receivers <[location].proc[find_wireless_blocks].context[receiver|<[frequency]>]>
    - foreach <[receivers]> as:receiver:
      - run wireless_redstone_refresh_receiver_task def:<[receiver]>|<[frequency]>

wireless_redstone_refresh_receiver_task:
  type: task
  debug: false
  definitions: location|frequency
  script:
    # base definitions
    - define transmitters <[location].proc[find_wireless_blocks].context[transmitter|<[frequency]>|true]>

    - if <[location]> matches redstone_block && <[transmitters].is_empty>:
      - flag <[location]> behr.essentials.wireless_redstone.ratelimited
      - adjust <[location].flag[behr.essentials.wireless_redstone.entity]> item:wireless_receiver_block[custom_model_data=1004]
      - modifyblock <[location]> dispenser
      - flag <[location]> behr.essentials.wireless_redstone.ratelimited:!

    - else if <[location]> matches dispenser && !<[transmitters].is_empty>:
      - flag <[location]> behr.essentials.wireless_redstone.ratelimited
      - adjust <[location].flag[behr.essentials.wireless_redstone.entity]> item:wireless_receiver_block[custom_model_data=1003]
      - modifyblock <[location]> redstone_block
      - playeffect at:<[location].center> effect:REDSTONE offset:0.5 special_data:1|255,0,0 quantity:10
      - playeffect at:<[location].center> effect:electric_spark offset:0.5 quantity:10
      - playsound at:<[location]> sound:block_amethyst_cluster_place pitch:<util.random.int[7].to[10].div[10]> volume:2
      - flag <[location]> behr.essentials.wireless_redstone.ratelimited:!


find_wireless_blocks:
  type: procedure
  debug: false
  definitions: location|type|frequency|active|range
  script:
    - define range 16 if:!<[range].exists>
    - define wireless_blocks <[location].find_blocks_flagged[behr.essentials.wireless_redstone].within[<[range]>]>
    - define wireless_blocks <[wireless_blocks].filter[flag[behr.essentials.wireless_redstone.material].equals[<[type]>]]>
    - define wireless_blocks <[wireless_blocks].filter[flag[behr.essentials.wireless_redstone.frequency].equals[<[frequency]>]]>
    - if <[active].exists>:
      - if <[active]>:
        - define wireless_blocks <[wireless_blocks].filter[switched]>
      - else:
        - define wireless_blocks <[wireless_blocks].filter[switched]>
    - determine <[wireless_blocks]>

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

    on player closes wireless_configuration_gui:
      - define location <player.flag[behr.essentials.wireless_redstone_gui.location]>
      - define material <[location].flag[behr.essentials.wireless_redstone.material]>
      - define old_frequency <[location].flag[behr.essentials.wireless_redstone.frequency]>
      - define new_frequency <player.flag[behr.essentials.wireless_redstone_gui.frequency]>
      - if <[old_frequency]> == <[new_frequency]>:
        - stop
      - flag <[location]> behr.essentials.wireless_redstone.frequency:<[new_frequency]>

      - if <[material]> == receiver:
        - run wireless_redstone_refresh_receiver_task def:<[location]>|<[new_frequency]>

      - else if <[material]> == transmitter:
        - ~run wireless_redstone_refresh_receivers_task def:<[location]>|<[old_frequency]>
        - ~run wireless_redstone_refresh_receivers_task def:<[location]>|<[new_frequency]>


      - actionbar "<&a>Frequency set to <player.flag[behr.essentials.wireless_redstone_gui.frequency].if_null[0]>"
      - flag <player> behr.essentials.wireless_redstone_gui.frequency:!

    on player clicks wireless_complete_button in inventory:
      - inventory close

    on player clicks wireless_up_1_button in inventory:
      - determine passively cancelled
      - flag <player> behr.essentials.wireless_redstone_gui.frequency:++
      - adjust <context.inventory> title:<script[wireless_configuration_gui].parsed_key[data.title].unseparated><player.flag[behr.essentials.wireless_redstone_gui.frequency].if_null[0]>
      - inventory open d:<context.inventory>

    on player clicks wireless_down_1_button in inventory:
      - determine passively cancelled
      - flag <player> behr.essentials.wireless_redstone_gui.frequency:--
      - adjust <context.inventory> title:<script[wireless_configuration_gui].parsed_key[data.title].unseparated><player.flag[behr.essentials.wireless_redstone_gui.frequency].if_null[0]>
      - inventory open d:<context.inventory>

    on player clicks wireless_up_10_button in inventory:
      - determine passively cancelled
      - flag <player> behr.essentials.wireless_redstone_gui.frequency:+:10
      - adjust <context.inventory> title:<script[wireless_configuration_gui].parsed_key[data.title].unseparated><player.flag[behr.essentials.wireless_redstone_gui.frequency].if_null[0]>
      - inventory open d:<context.inventory>

    on player clicks wireless_down_10_button in inventory:
      - determine passively cancelled
      - flag <player> behr.essentials.wireless_redstone_gui.frequency:-:10
      - adjust <context.inventory> title:<script[wireless_configuration_gui].parsed_key[data.title].unseparated><player.flag[behr.essentials.wireless_redstone_gui.frequency].if_null[0]>
      - inventory open d:<context.inventory>

wireless_complete_button:
  type: item
  debug: false
  material: player_head
  display name: <&color[<proc[prgb]>]>Set Frequency
  mechanisms:
    custom_model_data: 1053
wireless_up_1_button:
  type: item
  debug: false
  material: player_head
  display name: <&color[<proc[prgb]>]>Increase Frequency +1
  mechanisms:
    custom_model_data: 1053
wireless_down_1_button:
  type: item
  debug: false
  material: player_head
  display name: <&color[<proc[prgb]>]>Decrease Frequency +1
  mechanisms:
    custom_model_data: 1053
wireless_up_10_button:
  type: item
  debug: false
  material: player_head
  display name: <&color[<proc[prgb]>]>Increase Frequency +10
  mechanisms:
    custom_model_data: 1053
wireless_down_10_button:
  type: item
  debug: false
  material: player_head
  display name: <&color[<proc[prgb]>]>Decrease Frequency +10
  mechanisms:
    custom_model_data: 1053

wireless_frequency_tuner:
  type: item
  debug: false
  material: dispenser
  display name: <&b>Wireless Receiver
  mechanisms:
    custom_model_data: 1014
  flags:
    wireless_redstone: frequency_tuner

wireless_configuration_gui:
  type: inventory
  debug: false
  inventory: chest
  gui: true
  size: 27
  title: <script.parsed_key[data.title].unseparated>
  data:
    title:
      - <proc[bbackground].context[27|e005]>
      - <proc[positive_spacing].context[48]>
      - <&chr[E001].font[gui_sprites]>
      - <proc[negative_spacing].context[50]>
      - <&color[<proc[prgb]>]><element[Frequency<&co><&sp>].color[<proc[prgb]>].font[minecraft_15.5]>
      - <&font[minecraft_15.5]>
  definitions:
    1: wireless_up_1_button
    2: wireless_up_10_button
    c: wireless_complete_button
    3: wireless_down_1_button
    4: wireless_down_10_button
  slots:
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [4] [3] [c] [1] [2] [] []
