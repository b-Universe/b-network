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
    equipment: air|air|air|stick[custom_model_data=3001]
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

# | rewards
pufferfish_bubble_blower:
  type: item
  material: stick

pufferfish_sponge:
  type: item
  material: bucket

pufferfish_sponge_filled:
  type: item
  material: bucket

pufferfish_hat:
  type: item
  material: carved_pumpkin

fish_tank:
  type: item
  material: glass

pufferfish_sticky_grenade_cosmetic:
  type: item
  material: totem

pufferfish_fish_baggie:
  type: item
  material: bundle

pescetarian_puffman:
  type: assignment
  debug: true
  actions:
    on assignment:
      - trigger click state:true
    on click:
      - inventory open d:pescetarian_puffman_dialogue

pescetarian_puffman_dialogue:
  type: inventory
  inventory: chest
  size: 27
  gui: true
  title: <script.parsed_key[data.title].unseparated>
  data:
    title:
      # gui background
      - <&f><proc[negative_spacing].context[8].font[utility:spacing]>
      - <&chr[2002].font[gui]>
      # "Yeah!" button
      - <proc[negative_spacing].context[127].font[utility:spacing]>
      - <&chr[2004].font[gui]>
      # "Nah..." button
      - <proc[positive_spacing].context[18].font[utility:spacing]>
      - <&chr[2005].font[gui]>

      - <proc[negative_spacing].context[92].font[utility:spacing]>
      - <&color[#3488A6]><&font[minecraft_4]>Pescetarian Puffman<&co>
      - <proc[negative_spacing].context[106].font[utility:spacing]>
      - <black><&font[minecraft_8]>Hey there! Welcome
      - <proc[negative_spacing].context[95].font[utility:spacing]>
      - <black><&font[minecraft_12]>to the fishing area;
      - <proc[negative_spacing].context[98].font[utility:spacing]>
      - <black><&font[minecraft_16]>Want a quick run-
      - <proc[negative_spacing].context[89].font[utility:spacing]>
      - <black><&font[minecraft_20]>down of stuff here?
  definitions:
    #head: pescetarian_puffman_head[lore=<empty.repeat_as_list[160]>]
    head: pescetarian_puffman_head_temp[lore=<empty.repeat_as_list[160]>]
  slots:
    - [head] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [air] [air] [] [air] [air] []

pescetarian_puffman_dialogue_handler:
  type: world
  events:
    on player clicks item in pescetarian_puffman_dialogue:
      - choose <context.raw_slot>:
        - case 1 2 10 11:
          - random:
            - narrate "<&e>Pescetarian Puffman<&6>: <&b>Ow!"
            - narrate "<&e>Pescetarian Puffman<&6>: <&b>Hey! Quit that!"
            - narrate "<&e>Pescetarian Puffman<&6>: <&b>That's my head, can I help you?"
            - narrate "<&e>Pescetarian Puffman<&6>: <&b>That's not a button!"
            - narrate "<&e>Pescetarian Puffman<&6>: <&b>NOT THE GUMDROP BUTTONS"
            - narrate "<&e>Pescetarian Puffman<&6>: <&b>Click the buttons, not me!"
            - narrate "<&e>Pescetarian Puffman<&6>: <&b>pspspsp!"

        - case 22 23:
          - narrate accept

        - case 25 26:
          - narrate swish

        - default:
          - narrate <context.raw_slot>

          #_behr head
#pescetarian_puffman_head_temp:
#  type: item
#  material: player_head
#  display name: <&b>Hey! Don't poke me!
#  mechanisms:
#    custom_model_data: 1
#    skull_skin:
#      - _behr
#      - ewogICJ0aW1lc3RhbXAiIDogMTY1NDcyODQ1MDc1NSwKICAicHJvZmlsZUlkIiA6ICI1ODkwNjAyNDYyMzE0ZGFjODM0NWQ3YjI4MmExZDI4ZiIsCiAgInByb2ZpbGVOYW1lIiA6ICJXeW5uY3JhZnRHYW1pbmciLAogICJzaWduYXR1cmVSZXF1aXJlZCIgOiB0cnVlLAogICJ0ZXh0dXJlcyIgOiB7CiAgICAiU0tJTiIgOiB7CiAgICAgICJ1cmwiIDogImh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvNjkzYjhlNzYzOGZmNGM2YWEyODRjOTkxMjI3MDdlODU3NzdjNGQ0N2Q4Mzg4YzA4ODhjMmNjMjViNDA0YTkzOCIKICAgIH0KICB9Cn0=

#_breadcrumb head
#pescetarian_puffman_head_temp:
#  type: item
#  material: player_head
#  display name: <&b>Hey! Don't poke me!
#  mechanisms:
#    custom_model_data: 1
#    skull_skin:
#      - bcba4da7-9e02-4d82-b17d-3a14406657f9
#      - ewogICJ0aW1lc3RhbXAiIDogMTY1NDcxODk1NDE2OSwKICAicHJvZmlsZUlkIiA6ICI1MjhlYzVmMmEzZmM0MDA0YjYwY2IwOTA5Y2JiMjdjYiIsCiAgInByb2ZpbGVOYW1lIiA6ICJQdWxpenppIiwKICAic2lnbmF0dXJlUmVxdWlyZWQiIDogdHJ1ZSwKICAidGV4dHVyZXMiIDogewogICAgIlNLSU4iIDogewogICAgICAidXJsIiA6ICJodHRwOi8vdGV4dHVyZXMubWluZWNyYWZ0Lm5ldC90ZXh0dXJlL2U4ZDA1MDc3MGMwZDFjZjUyMzc2NTQyZDY5ZjAyMjkzZjE3YjcyZjA3OWU0NTU4NDFlOTQ0ZGY5YWVmNDkxOTIiCiAgICB9CiAgfQp9

#hydro-fuck it
pescetarian_puffman_head_temp:
  type: item
  material: player_head
  display name: <&b>Hey! Don't poke me!
  mechanisms:
    custom_model_data: 1
    skull_skin:
      - b15fdebe-4d92-414a-b543-29bc59f85110
      - ewogICJ0aW1lc3RhbXAiIDogMTY1NDcxOTk1NTA1NiwKICAicHJvZmlsZUlkIiA6ICI1NjY3NWIyMjMyZjA0ZWUwODkxNzllOWM5MjA2Y2ZlOCIsCiAgInByb2ZpbGVOYW1lIiA6ICJUaGVJbmRyYSIsCiAgInNpZ25hdHVyZVJlcXVpcmVkIiA6IHRydWUsCiAgInRleHR1cmVzIiA6IHsKICAgICJTS0lOIiA6IHsKICAgICAgInVybCIgOiAiaHR0cDovL3RleHR1cmVzLm1pbmVjcmFmdC5uZXQvdGV4dHVyZS9kMjE2MzEyZmMwNTkyMzZjYzYwYjlmNmRmN2Y3ZjFlNTNkYzY4NDRmMTBlZmU3NWU5MzllMTI4Mzk0MmI0M2MiCiAgICB9CiAgfQp9

pescetarian_puffman_head:
  type: item
  material: player_head
  display name: <&b>Hey! Don't poke me!
  mechanisms:
    custom_model_data: 1
    skull_skin:
      - 0386e456-ca39-45b3-a53f-ec895493da1b
      - ewogICJ0aW1lc3RhbXAiIDogMTY1NDcxOTI4NDA2MiwKICAicHJvZmlsZUlkIiA6ICIxNmFkYTc5YjFjMDk0MjllOWEyOGQ5MjgwZDNjNjE5ZiIsCiAgInByb2ZpbGVOYW1lIiA6ICJMYXp1bGl0ZV9adG9uZSIsCiAgInNpZ25hdHVyZVJlcXVpcmVkIiA6IHRydWUsCiAgInRleHR1cmVzIiA6IHsKICAgICJTS0lOIiA6IHsKICAgICAgInVybCIgOiAiaHR0cDovL3RleHR1cmVzLm1pbmVjcmFmdC5uZXQvdGV4dHVyZS9hNTNjMTA2Mjc0ZTY4NWY3ZjUwMzU5MzNkYzhhNDMwM2IyZjhhYjNlYjFhYzY4YjcyNTEwNjA0ZjM4Mzg0ZjVkIgogICAgfQogIH0KfQ==
