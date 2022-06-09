fishing_spawn:
  type: world
  debug: false
  events:
    on player enters no_swim_zone:
      - stop if:<context.to.advanced_matches[!water]>
      - if <player.is_inside_vehicle>:
        - wait 1s
      - title title:<black><&font[fade:white]><&chr[0004]><&chr[F801].font[utility:spacing]><&chr[0004]> fade_in:5t stay:0s fade_out:1s
      - wait 5t
      - teleport <server.flag[behr.spawn.no_swim_zone_respawns].sort_by_number[distance[<player.location>]].first>
      - playsound <player> sound:BLOCK_BEACON_ACTIVATE

    on *boat enters no_swim_zone:
      - wait 1s
      - playeffect effect:EXPLOSION_large at:<context.entity.location> offset:1 quantity:3
      - playeffect effect:lava at:<context.entity.location.above[0.2]> offset:1 quantity:6
      - playsound sound:ENTITY_DRAGON_FIREBALL_EXPLODE <context.entity.location> volume:2
      - playsound sound:ENTITY_GENERIC_EXTINGUISH_FIRE <context.entity.location> pitch:1 volume:0.2
      - remove <context.entity>

    on player enters fishing_area_spawnable:
      - flag server behr.playing_fish.players:->:<player>
      - if !<server.has_flag[behr.playing_fish.fish]>:
        - run its_fishing_time

    on player exits fishing_area_spawnable:
      - flag server behr.playing_fish.players:<-:<player>
      #- if !<server.has_flag[behr.playing_fish.players]> || <server.flag[behr.playing_fish.players].is_empty>:
      - remove <server.flag[behr.playing_fish.fish].filter[is_truthy]>
      - flag server behr.playing_fish.fish:!

    on player enters fishing_area:
      - repeat 2:
        - actionbar "<&f>🐠 <&color[#000001]>Fishing Area <&f>🦀"
        - wait 2s

    #on player fishes:
    #  - narrate <context.state>

    on player fishes while fishing:
      - define timeout <util.time_now.add[4s]>
      - flag player hook_maybe:<context.hook.if_null[invalid]>
      - flag player left_hook_delay expire:1t
      #! attachments
      #!- spawn light_that_boy_up <context.hook.location> if:<context.hook.is_truthy> save:light
      #!- attach <entry[light].spawned_entity> to:<context.hook> if:<context.hook.is_truthy>
      - waituntil <util.time_now.is_after[<[timeout]>]> || !<context.hook.is_truthy> || <context.hook.fish_hook_state.advanced_matches[HOOKED_ENTITY|BOBBING]>
      - stop if:!<context.hook.is_truthy>
      - if <context.hook.fish_hook_state> == hooked_entity && <context.hook.fish_hook_hooked_entity.script.name.if_null[invalid]> == spawn_fish:
        - narrate catch!
        - flag player hook_maybe:!
        - wait 2s
        - remove <context.hook> if:<context.hook.is_truthy>
      - else:
        - repeat 5:
          - if <player.has_flag[left_hook_delay]>:
            - wait 1s
          - stop if:!<context.hook.is_truthy>
          - if !<context.hook.location.find_entities[spawn_fish].within[0.5].is_empty>:
            - narrate catch!
            - flag player hook_maybe:!
            - wait 2s
            - remove <context.hook> if:<context.hook.is_truthy>
            - repeat stop
          - wait 5t
      #!- remove <entry[light].spawned_entity>

    on player fishes spawn_fish while caught_entity:
      - determine passively cancelled
      - remove <context.hook>

    on player clicks block with:fishing_rod flagged:!left_hook_delay:
      - stop if:<context.click_type.contains_text[right]>
      - flag player left_hook_delay expire:2s
      - define hook <player.flag[hook_maybe].if_null[null]>
      - if <[hook].is_truthy>:
        - playsound <player.location> sound:ENTITY_FISHING_BOBBER_THROW pitch:0 volume:0.2
        - adjust <[hook]> velocity:<[hook].velocity.add[<player.location.forward[0.5].up[0.5].sub[<player.location>]>]>

#fishing_spawn_debug:
#  type: world
#  debug: true
#  events:

move_fish:
  type: task
  script:
  - define fish <server.flag[behr.playing_fish.fish]>
  - define location <cuboid[fishing_area_fish_spawn].blocks.random>
  - define rate 10

  - repeat <[rate]>:
  # percent is 0 -1, eases from location a to location b, with a type (sine, quad, cubic, quart, quint, exp, circ, back, elastic, bounce) and a direction (in, out, inout)
      - define loc1 <[fish].location>
      - define loc2 <proc[lib_ease_location].context[<[value].div[<[rate]>]>|<[fish].location.above>|<[location].above>|quad|inout]>
      - define vector <[loc2].sub[<[loc1]>].normalize.mul[0.5].with_y[0]>
      - playeffect at:<[loc1].above[0.5]> effect:bubble offset:0.3,0,0.3 quantity:5 visibility:100
      - playeffect at:<[loc1].above[0.3]> effect:WATER_SPLASH offset:0.4,0,0.4 quantity:15 visibility:100
      - adjust <[fish]> velocity:<[vector]>
      #- teleport <[fish]> <proc[lib_ease_location].context[<[value].div[<[rate]>]>|<[fish].location>|<[location]>|quad|in]>
      #- playeffect effect:redstone at:<proc[lib_ease_location].context[<[value].div[<[rate]>]>|<[fish].location.above>|<[location].above>|quad|inout]> offset:0 special_data:4|<color[red].with_hue[<element[255].div[<[value].div[<[rate]>]>].round_down>]> visibility:100
      - wait 2t

its_fishing_time:
  type: task
  debug: false
  definitions: fish
  sub_scripts:
    move_fish:
      - define rate 10
      - while <server.has_flag[behr.playing_fish.fish]> && <[fish].is_truthy>:
        - define location <cuboid[fishing_area_fish_spawn].blocks.random>
        - playsound at:<[fish].location> sound:ENTITY_BOAT_PADDLE_WATER volume:2
        - repeat <[rate]>:
          - stop if:!<[fish].is_truthy>
          - define loc1 <[fish].location>
          - define loc2 <proc[lib_ease_location].context[<[value].div[<[rate]>]>|<[fish].location.above>|<[location].above>|quad|inout]>
          - define vector <[loc2].sub[<[loc1]>].normalize.mul[0.5].with_y[0]>
          - playeffect at:<[loc1].above[0.5]> effect:bubble offset:0.3,0,0.3 quantity:5 visibility:100
          - playeffect at:<[loc1].above[0.3]> effect:WATER_SPLASH offset:0.4,0,0.4 quantity:15 visibility:100
          - adjust <[fish]> velocity:<[vector]>
          - wait 2t
        - wait <util.random.int[80].to[500]>t
      - remove <[fish]> if:<[fish].is_truthy>
        #- wait 3s

    playeffect:
      - while <server.has_flag[behr.playing_fish.fish]> && <[fish].is_truthy>:
        - playeffect at:<[fish].location.above[0.25]> effect:bubble offset:0.4,0,0.4 quantity:15 visibility:100
        - playeffect at:<[fish].location.above[0.3]> effect:WATER_SPLASH offset:0.4,0,0.4 quantity:5 visibility:100
        - wait 1t

  script:
    - if !<server.has_flag[behr.playing_fish.fish]> || !<server.flag[behr.playing_fish.fish].is_truthy>:
      - repeat 3:
        - spawn spawn_fish <cuboid[fishing_area_fish_spawn].blocks.random> save:fish
        - flag server behr.playing_fish.fish:->:<entry[fish].spawned_entity>

    - define fishies <server.flag[behr.playing_fish.fish]>
    - wait 2s
    - foreach <[fishies]> as:fish:
      - run its_fishing_time.sub_scripts.playeffect def:<[fish]>
      - run its_fishing_time.sub_scripts.move_fish def:<[fish]>


spawn_fish:
  type: entity
  debug: false
  entity_type: vex
  mechanisms:
    is_aware: false
    equipment: air|air|air|stick[custom_model_data=3000]
    item_in_hand: torch
    invulnerable: true
    silent: true
    potion_effects:
      type: INVISIBILITY
      aplifier: 1
      duration: 9999h
      ambient: true
      particles: false

light_that_boy_up:
  type: entity
  entity_type: armor_stand
  mechanisms:
    item_in_hand: torch
    marker: true
    is_small: true
    visible: false
