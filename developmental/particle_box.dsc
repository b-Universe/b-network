particle_box:
  type: item
  debug: false
  material: gold_block
  display name: <&b>Particle Box
  lore:
    - Place on ground and configure for particles

particle_box_gui_main_menu:
  type: inventory
  debug: false
  inventory: chest
  title: <&b>Particle Display GUI
  gui: true
  size: 18
  definitions:
    1: particle_box_effect_menu_button
    2: particle_box_data_menu_button
    3: particle_box_special_data_menu_button
    4: particle_box_visibility_menu_button
    5: particle_box_quantity_menu_button
    6: particle_box_offset_menu_button
    7: particle_box_velocity_menu_button
    8: particle_box_delay_menu_button
    9: particle_box_randomize_button
    c: particle_box_credit_menu_button
    r: barrierreload
  slots:
    - [1] [2] [3] [4] [5] [6] [7] [8] [9]
    - []  []  []  []  [c] []  []  []  [r]

barrierreload:
  type: item
  debug: false
  material: barrier

particle_box_effect_menu_button:
  type: item
  debug: false
  material: lime_stained_glass
  display name: <&b>Adjust Effect
  lore:
    - <&e>Effect<&6><&co> <&a>Flame
    - <&e>Left Click <&3>to edit the
    - <&3>effect displayed

particle_box_data_menu_button:
  type: item
  debug: false
  material: gray_stained_glass
  display name: <&b>Adjust Data
  lore:
    - <&7>Default disabled
    - <&e>Left Click <&3>to edit
    - <&3>the data argument

particle_box_special_data_menu_button:
  type: item
  debug: false
  material: gray_stained_glass
  display name: <&b>Adjust Special Data
  lore:
    - <&7>Default disabled
    - <&e>Left Click <&3>to edit
    - <&3>the special data argument

particle_box_visibility_menu_button:
  type: item
  debug: false
  material: white_stained_glass
  display name: <&b>Adjust Visibility
  lore:
    - <&e>Visibility<&6><&co> <&a>32
    - <&e>Left Click <&3>to edit
    - <&3>the visibility distance

particle_box_quantity_menu_button:
  type: item
  debug: false
  material: white_stained_glass
  display name: <&b>Adjust Quantity
  lore:
    - <&e>Quantity<&6><&co> <&a>1
    - <&e>Left Click <&3>to edit
    - <&3>the quantity/density

particle_box_offset_menu_button:
  type: item
  debug: false
  material: white_stained_glass
  display name: <&b>Adjust Offset
  lore:
    - <&e>Offset<&6><&co> <&a>0.5<&e>,<&a>0.5<&e>,<&a>0.5
    - <&e>Left Click <&3>to edit
    - <&3>the offset distance

particle_box_velocity_menu_button:
  type: item
  debug: false
  material: gray_stained_glass
  display name: <&b>Adjust Velocity
  lore:
    - <&7>Default disabled
    - <&e>Left Click <&3>to edit
    - <&3>the data argument

particle_box_delay_menu_button:
  type: item
  debug: false
  material: white_stained_glass
  display name: <&b>Adjust Delay
  lore:
    - <&e>Delay<&6><&co> <&a>5t
    - <&e>Left Click <&3>to edit
    - <&3>delay repeat speed

particle_box_randomize_button:
  type: item
  debug: false
  material: pink_stained_glass
  display name: <&b>Randomize
  lore:
    - <&3>Randomizes the particle
    - <&3>effects played

particle_box_credit_menu_button:
  type: item
  debug: false
  material: gold_block
  display name: <&b>Credits
  lore:
    - <&3>Shows contributors and
    - <&3>their credits

particle_box_gui_effect_menu:
  type: inventory
  debug: false
  inventory: chest
  title: <&b>Particle Display GUI | Effect | <&a>Flame
  gui: true
  size: 45

particle_box_active_effect_button:
  type: item
  material: lime_stained_glass
  display name: <&e>Effect<&6><&co> <&a>Flame
  lore:
    - <&7>Currently selected
    - <&3>Flame particles like from Torches,
    - <&3>furnaces, magma cubes, spawners...
  flags:
    effect: flame

particle_box_inactive_effect_button:
  type: item
  debug: false
  material: white_stained_glass

particle_box_main_menu_button:
  type: item
  debug: false
  display name: <&e>Main menu
  material: orange_stained_glass_pane

particle_box_page_button:
  type: item
  debug: false
  material: red_stained_glass_pane

generate_particle_box_guis_startup:
  type: world
  debug: false
  events:
    after server start:
      - run generate_particle_box_guis

generate_particle_box_guis:
  type: task
  debug: false
  script:
    # Generate the main gui
    - flag server behr.essentials.particle_box.default_gui.main_menu:<inventory[particle_box_gui_main_menu]>

    # Generate the effect menu GUI
    - foreach <server.particle_types.sub_lists[36]> as:effect_list:
      - define page_number <[loop_index]>
      - define page.<[page_number]>.inventory:<inventory[particle_box_gui_effect_menu]>
      - foreach <[effect_list]> as:effect:
        - define effect_item <item[particle_box_inactive_effect_button].with[display=<&e>Effect<&6><&co> <&7><[effect].replace_text[_].with[ ].to_titlecase>].with_flag[effect:<[effect]>]>
        - define lore <list_single[<&e>Left click <&3>to select]>
        - if <script[particle_box_data].data_key[effects.<[effect]>.effect].exists>:
          - define lore <[lore].include[<script[particle_box_data].data_key[effects.<[effect]>.effect.description]>]>
        - define effect_item <[effect_item].with[lore=<[lore]>]>
        - give <[effect_item]> to:<[page.<[page_number]>.inventory]>
      - inventory set origin:particle_box_main_menu_button destination:<[page.<[page_number]>.inventory]> slot:37
    - inventory set origin:particle_box_active_effect_button destination:<[page.1.inventory]> slot:27
    - inventory set origin:<item[particle_box_page_button].with[display=<&e>Next page].with_flag[page:1]> destination:<[page.2.inventory]> slot:38
    - inventory set origin:<item[particle_box_page_button].with[display=<&e>Next page].with_flag[page:2]> destination:<[page.3.inventory]> slot:38
    - inventory set origin:<item[particle_box_page_button].with[display=<&e>Previous page].with_flag[page:2]> destination:<[page.1.inventory]> slot:44
    - inventory set origin:<item[particle_box_page_button].with[display=<&e>Previous page].with_flag[page:3]> destination:<[page.2.inventory]> slot:44
    - inventory set origin:barrierreload destination:<[page.2.inventory]> slot:45
    - flag server behr.essentials.particle_box.default_gui.effect_menu:<[page]>

    # Generate the data menu GUI

    # Generate the special_data menu GUI

    # Generate the visibility menu GUI

    # Generate the quantity menu GUI

    # Generate the offset menu GUI

    # Generate the velocity menu GUI


create_particle_box_guis:
  type: task
  debug: true
  definitions: location
  script:
    #- if !<inventory[<[inventory_name]>].is_truthy>
    - if true:
      - run generate_particle_box_guis
      - foreach main_menu as:inventory_name:
        - define inventory <server.flag[behr.essentials.particle_box.default_gui.<[inventory_name]>]>
        - note <[inventory]> as:particle_box_<[inventory_name]>_<[location].simple>
      - foreach <server.flag[behr.essentials.particle_box.default_gui.effect_menu]> key:page_number as:page:
        - note <[page.inventory]> as:particle_box_effect_menu_<[page_number]>_<[location].simple>

    - inventory open destination:particle_box_main_menu_<[location].simple>


particle_box_handler:
  type: world
  debug: true
  events:
    after player clicks particle_box_inactive_effect_button in particle_box_effect_menu_*:
      - define location <context.inventory.note_name.after_last[_]>
      - define player_detector <server.flag[particle_boxes.detectors.<[location]>.entity]>
      - define old_effect <[player_detector].flag[particle_data.effect]>
      - define new_effect <context.item.flag[effect]>
      - define old_effect_index <server.particle_types.find[<[old_effect]>]>
      - if <[old_effect_index]> < 37:
        - define page 1
      - else if <[old_effect_index]> < 73:
        - define page 2
      - else:
        - define page 3

      # apply the new
      - flag <[player_detector]> particle_data.effect:<[new_effect]>
      - inventory set destination:<context.inventory> slot:<context.slot> origin:particle_box_active_effect_button
      - inventory adjust destination:<context.inventory> slot:<context.slot> "display:<&e>Effect<&6><&co> <&a><[new_effect].replace_text[_].with[ ].to_titlecase>"
      - inventory adjust destination:<context.inventory> slot:<context.slot> lore:<list_single[<&7>Currently selected].include[<script[particle_box_data].parsed_key[effects.<[new_effect]>.effect.description].if_null[<list>]>]>

      - wait 5t
      # adjust the old
      - define old_inventory particle_box_effect_menu_<[page]>_<[location]>
      - define slot <[old_effect_index].sub[1].mod[36].add[1]>
      - inventory set  destination:<[old_inventory]> slot:<[slot]> origin:particle_box_inactive_effect_button
      - inventory flag destination:<[old_inventory]> slot:<[slot]> effect:<[old_effect]>
      - inventory adjust destination:<[old_inventory]> slot:<[slot]> "display:<&e>Effect<&6><&co> <&7><[old_effect].replace_text[_].with[ ].to_titlecase>"
      - inventory adjust destination:<[old_inventory]> slot:<[slot]> lore:<list_single[<&e>Left click <&3>to select].include[<script[particle_box_data].parsed_key[effects.<[old_effect]>.effect.description].if_null[<list>]>]>

      - flag <[player_detector]> particle_data.data:!
      - flag <[player_detector]> particle_data.special_data:!
      - flag <[player_detector]> particle_data.offset:!
      - flag <[player_detector]> particle_data.velocity:!

      - choose <[new_effect]>:
      #sculk_charge shriek
        - case item_crack block_crack block_dust falling_dust legacy_block_crack legacy_block_dust legacy_falling_dust block_marker:
          - flag <[player_detector]> particle_data.special_data:<material[stone]>

        - case redston:
          - flag <[player_detector]> particle_data.special_data:1|<color[255,0,0]>
        - case dust_color_transition:
          - flag <[player_detector]> particle_data.special_data:1|<color[255,0,0]>|<color[0,0,255]>


      - define text "<&e>effect<&6><&co> <&a><[new_effect].to_lowercase>"
      - foreach data|special_data|visibility|quantity|offset|velocity as:arg:
        - if <[player_detector].has_flag[particle_data.<[arg]>]>:
          - define text "<[text]><n><&e><[arg]><&6><&co> <&a><[player_detector].flag[particle_data.<[arg]>].to_lowercase>"

      - adjust <[player_detector]> text:<[text]>

    after player clicks particle_box_main_menu_button in inventory:
      - inventory open d:<context.inventory.note_name.before_last[_menu].before_last[_]>_main_menu_<context.inventory.note_name.after_last[_]>

    after player clicks barrierreload in inventory:
      - reload

    after player clicks particle_box_page_button in particle_box_effect_menu_*:
      - define location <context.inventory.note_name.after_last[_]>
      - define page <context.item.flag[page]>
      - inventory open destination:particle_box_effect_menu_<[page]>_<[location]>

    after player clicks particle_box_effect_menu_button in particle_box_main_menu_*:
      - define location <context.inventory.note_name.after_last[_]>
      - inventory open destination:particle_box_effect_menu_1_<[location]>

    on player right clicks block location_flagged:particle_box:
      - define location <context.location>
      - stop if:!<server.has_flag[particle_boxes.detectors.<[location].simple>]>
      - determine passively cancelled

      - inject create_particle_box_guis

    on player breaks block location_flagged:particle_box:
      - define location <context.location>
      - flag <[location]> particle_box:!
      - define entities <context.location.above.to_cuboid[<context.location.above>].entities.filter[scripts.any]>
      - if <[entities].parse[scripts.first.name].contains[player_detector]>:
        - modifyblock <context.location.above> air if:<context.location.above.advanced_matches[*_carpet]>
        - spawn block_display[material=gold_block;interpolation_duration=1s;interpolation_start=0t;translation=-0.5,-0.5,-0.5] <context.location.add[0.5,0.5,0.5]> save:gold_block_display
        - define gold_block_display <entry[gold_block_display].spawned_entity>
        - foreach <[entities].filter[scripts.first.name.equals[player_detector]]> as:entity:
          - flag server particle_boxes.active_detectors.<[entity].uuid>:!
          - flag server particle_boxes.detectors.<[entity].uuid>:!
          - playeffect at:<[entity].location.above> effect:explosion_normal quantity:5 offset:0.5
          - playsound <[entity].location> sound:block_fire_extinguish
          - remove <[entity]>
        - wait 5t
        - adjust <[gold_block_display]> scale:0,0,0
        - wait 1s
        - remove <[gold_block_display]>

    after player places particle_box:
      - define location <context.location>
      - if <context.location.above> matches air:
        - modifyblock <context.location.above> black_carpet
      - create text_display detector <[location].center.above[0.6]> save:player_detector
      - definemap property_data:
          text: <&e>effect<&6><&co> <&a>flame <&b><&lc><&e>offset<&6><&co> <&a>0.5<&b><&rc> <&b><&lc><&e>quantity<&6><&co> <&a>1<&b><&rc>
          pivot: center
          scale: 0.4,0.4,0.4
          name_visible: false

      - define player_detector <entry[player_detector].created_npc>
      - adjust <[player_detector]> <[property_data]>
      - definemap particle_data:
          effect: flame
          #data: default disabled
          #special_data: default disabled
          visibility: 32
          quantity: 1
          #offset: default disabled
          #velocity: default disabled
          delay: 5t
          entity: <[player_detector]>
          uuid: <[player_detector].uuid>

      - flag <[player_detector]> particle_data:<[particle_data]>
      - flag server particle_boxes.detectors.<[location].simple>:<[particle_data]>
      - inject create_particle_box_guis
      - flag <[location]> particle_box
      - assignment add script:player_detector to:<[player_detector]>

player_detector:
  type: assignment
  actions:
    on assignment:
      - trigger name:proximity state:true radius:<npc.flag[particle_data.visibility]>

    on enter proximity:
      - flag server particle_boxes.active_detectors.<npc.uuid>
      - run particle_box_player def.player_detector:<npc>

    on exit proximity:
      - flag server particle_boxes.active_detectors.<npc.uuid>

    on remove:
      - flag server particle_boxes.acive_detectors.<npc.uuid>:!
      - flag server particle_boxes.detectors.<npc.uuid>:!

particle_box_player:
  type: task
  definitions: player_detector
  debug: false
  script:
    - while <server.has_flag[particle_boxes.active_detectors.<[player_detector].uuid.if_null[null]>]>:
      - define particle_data <[player_detector].flag[particle_data]>
      - define location <[player_detector].location.above[1]>
      - wait <[particle_data.delay]>

      - define index 0
      - foreach data|special_data|offset|velocity as:arg:
        - if <[particle_data].contains[<[arg]>]>:
          - define index <[index].add[<element[10].power[<[loop_index]>]>]>

      - choose <[index]>:
        - case 0:
          - playeffect effect:<[particle_data.effect]> at:<[location]>

        # one argument
        - case 10:
          - playeffect effect:<[particle_data.effect]> at:<[location]>
                       data:<[particle_data.data]>
        - case 100:
          - playeffect effect:<[particle_data.effect]> at:<[location]>
                       special_data:<[particle_data.special_data]>
        - case 1000:
          - playeffect effect:<[particle_data.effect]> at:<[location]>
                       offset:<[particle_data.offset]>
        - case 10000:
          - playeffect effect:<[particle_data.effect]> at:<[location]>
                       velocity:<[particle_data.velocity]>

        # two arguments
        - case 110:
          - playeffect effect:<[particle_data.effect]> at:<[location]>
                       data:<[particle_data.data]>
                       special_data:<[particle_data.special_data]>
        - case 1010:
          - playeffect effect:<[particle_data.effect]> at:<[location]>
                       data:<[particle_data.data]>
                       offset:<[particle_data.offset]>
        - case 1100:
          - playeffect effect:<[particle_data.effect]> at:<[location]>
                       special_data:<[particle_data.special_data]>
                       offset:<[particle_data.offset]>
        - case 11000:
          - playeffect effect:<[particle_data.effect]> at:<[location]>
                       offset:<[particle_data.offset]>
                       velocity:<[particle_data.velocity]>
        - case 10100:
          - playeffect effect:<[particle_data.effect]> at:<[location]>
                       special_data:<[particle_data.special_data]>
                       velocity:<[particle_data.velocity]>
        - case 10010:
          - playeffect effect:<[particle_data.effect]> at:<[location]>
                       data:<[particle_data.data]>
                       velocity:<[particle_data.velocity]>

        # three arguments
        - case 1110:
          - playeffect effect:<[particle_data.effect]> at:<[location]>
                       data:<[particle_data.data]>
                       special_data:<[particle_data.special_data]>
                       offset:<[particle_data.offset]>
        - case 10110:
          - playeffect effect:<[particle_data.effect]> at:<[location]>
                       data:<[particle_data.data]>
                       special_data:<[particle_data.special_data]>
                       velocity:<[particle_data.velocity]>
        - case 11010:
          - playeffect effect:<[particle_data.effect]> at:<[location]>
                       data:<[particle_data.data]>
                       offset:<[particle_data.offset]>
                       velocity:<[particle_data.velocity]>
        - case 11100:
          - playeffect effect:<[particle_data.effect]> at:<[location]>
                       special_data:<[particle_data.special_data]>
                       offset:<[particle_data.offset]>
                       velocity:<[particle_data.velocity]>

        # four arguments
        - case 11110:
          - playeffect effect:<[particle_data.effect]> at:<[location]>
                       data:<[particle_data.data]>
                       special_data:<[particle_data.special_data]>
                       offset:<[particle_data.offset]>
                       velocity:<[particle_data.velocity]>

particle_box_data:
  type: data
  args:
    - effect
    - data
    - special_data
    - visibility
    - quantity
    - offset
    - velocity
  effects:
    defaults:
      visibility:
        type: int
        description:
          - <&3>Sets the distance in blocks
          - <&3>this can be seen from
      quantity:
        type: int
        description:
          - <&3>Sets the quantity of particles played,
          - <&3>increasing density of particles
      offset:
        type: int/vector
        description:
          - <&3>Sets the offset from origin
          - <&3>the particle plays at
      velocity:
        type: vector
        description:
          - <&3>Sets the speed and direction
          - <&3>that the particle moves
    #explosion_normal:
    #explosion_large:
    #explosion_huge:
    #fireworks_spark:
    #water_bubble:
    #water_splash:
    #water_wake:
    #suspended:
    #suspended_depth:
    #crit:
    #crit_magic:
    #smoke_normal:
    #smoke_large:
    #spell:
    #spell_instant:
    #spell_mob:
    #spell_mob_ambient:
    #spell_witch:
    #drip_water:
    #drip_lava:
    #villager_angry:
    #villager_happy:
    #town_aura:
    #note:
    #portal:
    #enchantment_table:
    flame:
      effect:
        description:
          - <&3>Flame particles like from Torches,
          - <&3>furnaces, magma cubes, spawners...
      data:
        type: int
        description:
          - <&3>Acts as <&b>Velocity <&3>but
          - <&3>randomizes the <&b>yaw <&3>and <&b>pitch direction
          - <&7>Note<&8><&co> <&7>Velocity overrides this
      visibility:
        type: int
        description:
          - <&3>Sets the distance in blocks
          - <&3>this can be seen from
      quantity:
        type: int
        description:
          - <&3>Sets the quantity of particles played,
          - <&3>increasing density of particles
      offset:
        type: int/vector
        description:
          - <&3>Sets the offset from origin
          - <&3>the particle plays at
      velocity:
        type: vector
        description:
          - <&3>Sets the speed and direction
          - <&3>that the particle moves
          - <&7>Note<&8><&co> <&7>This overrides the Data
          - <&7>argument<&sq>s randomized direction
    #lava:
    #cloud:
    #redstone:
    #snowball:
    #snow_shovel:
    #slime:
    #heart:
    #item_crack:
    #block_crack:
    #block_dust:
    #water_drop:
    #mob_appearance:
    #dragon_breath:
    #end_rod:
    #damage_indicator:
    #sweep_attack:
    #falling_dust:
    #totem:
    #spit:
    #squid_ink:
    #bubble_pop:
    #current_down:
    #bubble_column_up:
    #nautilus:
    #dolphin:
    #sneeze:
    #campfire_cosy_smoke:
    #campfire_signal_smoke:
    #composter:
    #flash:
    #falling_lava:
    #landing_lava:
    #falling_water:
    #dripping_honey:
    #falling_honey:
    #landing_honey:
    #falling_nectar:
    #soul_fire_flame:
    #ash:
    #crimson_spore:
    #warped_spore:
    #soul:
    #dripping_obsidian_tear:
    #falling_obsidian_tear:
    #landing_obsidian_tear:
    #reverse_portal:
    #white_ash:
    #dust_color_transition:
    #vibration:
    #falling_spore_blossom:
    #spore_blossom_air:
    #small_flame:
    #snowflake:
    #dripping_dripstone_lava:
    #falling_dripstone_lava:
    #dripping_dripstone_water:
    #falling_dripstone_water:
    #glow_squid_ink:
    #glow:
    #wax_on:
    #wax_off:
    #electric_spark:
    #scrape:
    #sonic_boom:
    #sculk_soul:
    #sculk_charge:
    #sculk_charge_pop:
    #shriek:
    #cherry_leaves:
    #egg_crack:
    #dust_plume:
    #white_smoke:
    #gust:
    #gust_emitter:
    #gust_dust:
    #trial_spawner_detection:
    #block_marker:
    #legacy_block_crack:
    #legacy_block_dust:
    #legacy_falling_dust: