particle_box:
  type: item
  material: gold_block
  display name: <&b>Particle Box
  lore:
    - Place on ground and configure for particles

particle_box_gui:
  type: inventory
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
  slots:
    - [1] [2] [3] [4] [5] [6] [7] [8] [9]
    - []  []  []  []  [c] []  []  []  []

particle_box_effect_menu_button:
  type: item
  material: lime_stained_glass
  display name: <&b>Adjust Effect
  lore:
    - <&e>Effect<&6><&co> <&a>flame
    - <&3>Click to edit the
    - <&3>effect displayed

particle_box_data_menu_button:
  type: item
  material: white_stained_glass
  display name: <&b>Adjust Data
  lore:
    - <&3>Click to edit
    - <&3>the data argument

particle_box_special_data_menu_button:
  type: item
  material: white_stained_glass
  display name: <&b>Adjust Special Data
  lore:
    - <&3>Click to edit
    - <&3>the special data argument

particle_box_visibility_menu_button:
  type: item
  material: white_stained_glass
  display name: <&b>Adjust Visibility
  lore:
    - <&e>Visibility<&6><&co> <&a>32
    - <&3>Click to edit
    - <&3>the visibility distance

particle_box_quantity_menu_button:
  type: item
  material: white_stained_glass
  display name: <&b>Adjust Quantity
  lore:
    - <&e>Quantity<&6><&co> <&a>1
    - <&3>Click to edit
    - <&3>the quantity/density

particle_box_offset_menu_button:
  type: item
  material: white_stained_glass
  display name: <&b>Adjust Offset
  lore:
    - <&e>Offset<&6><&co> <&a>0.5<&e>,<&a>0.5<&e>,<&a>0.5
    - <&3>Click to edit
    - <&3>the offset distance

particle_box_velocity_menu_button:
  type: item
  material: white_stained_glass
  display name: <&b>Adjust Velocity
  lore:
    - <&3>Click to edit
    - <&3>the velocity speed

particle_box_delay_menu_button:
  type: item
  material: white_stained_glass
  display name: <&b>Adjust Delay
  lore:
    - <&e>Delay<&6><&co> <&a>5t
    - <&3>Click to edit the
    - <&3>delay repeat speed

particle_box_randomize_button:
  type: item
  material: pink_stained_glass
  display name: <&b>Randomize
  lore:
    - <&3>Randomizes the particle effects played

particle_box_credit_menu_button:
  type: item
  material: gold_block
  display name: <&b>Credits
  lore:
    - <&3>Shows contributors and
    - <&3>their credits

particle_box_effect_gui:
  type: inventory
  inventory: chest
  title: <&b>Particle Display GUI | Effect
  gui: true
  size: 54
  definitions:
    a: particle_box_active_effect_button
    i: particle_box_inactive_effect_button
    x: barrier
  procedural items:
    - define list <list>
    - foreach <server.particle_types> as:particle_type:
      - define <[list].include_single[<item[particle_type].with[display=<&e>Effect<&6><&co> <&a><[particle_type].replace_text[_].with[ ].to_titlecase>]>]>
      - foreach stop if:<[loop_index].equals[45]>
    - determine <[list]>
  slots:
    - [a] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [x] [] [] [] [x] [] [] [] [x]

particle_box_active_effect_button:
  type: item
  material: lime_stained_glass
  display name: <&e>Effect<&6><&co> <&a>flame
  lore:
    - <&7>Currently Enabled

particle_box_inactive_effect_button:
  type: item
  material: white_stained_glass
  lore:
    - <&b>Click to enable

particle_box_handler:
  type: world
  debug: false
  events:
    after player right clicks block:
      - define location <context.location>
      - stop if:!<server.has_flag[particle_boxes.detectors.<[location].simple>]>
      - define inventory_name particle_box_main_menu_<[location].simple>

      #- if !<inventory[<[inventory_name]>].is_truthy>
      - if true:
        - note <inventory[particle_box_gui]> as:<[inventory_name]>
        - define effect flame
        - define effect_data <script[particle_box_data].parsed_key[effects.<[effect]>]>
        - foreach <script[particle_box_data].parsed_key[args]> as:arg:
          - if !<[effect_data].contains[<[arg]>]>:
            - inventory set "origin:gray_stained_glass[display=<&7><[arg]>;lore=<&7><[effect]> does not|<&7>support this argument]" destination:<[inventory_name]> slot:<[loop_index]>
          - else:
            - inventory set "origin:gray_stained_glass[display=<&7><[arg]>;lore=<&7><[effect]> does not|<&7>support this argument]" destination:<[inventory_name]> slot:<[loop_index]>

      - inventory open destination:<[inventory_name]>

    on player breaks gold_block:
      - define entities <context.location.above.to_cuboid[<context.location.above>].entities.filter[scripts.any]>
      - if <[entities].parse[scripts.first.name].contains[player_detector]>:
        - modifyblock <context.location.above> air if:<context.location.above.advanced_matches[*_carpet]>
        - spawn block_display[material=gold_block;interpolation_duration=1s;interpolation_start=0t;translation=-0.5,-0.5,-0.5] <context.location.add[0.5,0.5,0.5]> save:gold_block_display
        - define gold_block_display <entry[gold_block_display].spawned_entity>
        - foreach <[entities].filter[scripts.first.name.equals[player_detector]]> as:entity:
          - flag server particle_boxes.active_detectors.<[entity].uuid>:!
          - flag server particle_boxes.detectors.<[entity].uuid>:!
          - playeffect at:<[entity].location.above[1]> effect:explosion_normal quantity:5 offset:0.5
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
      #- create armor_stand detector <[location].center> save:player_detector
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
    flame:
      effect:
        description:
          - <&3>flame particles like from Torches,
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
