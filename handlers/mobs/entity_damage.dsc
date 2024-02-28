hitsplat_display_command:
  type: command
  debug: false
  name: holome
  description: A debug command.
  usage: /holome
  script:
    - repeat 3:
      - spawn hitsplat_display_entity <player.eye_location.forward_flat[1]> save:hologram
      - define hologram <entry[hologram].spawned_entity>
      - adjust <[hologram]> scale:<location[0.9,0.9,0.9].random_offset[0.1,0.1,0.1]>
      - wait 2t
      - adjust <[hologram]> <map[interpolation_duration=5s;translation=0,2,0]>
      - wait 2s
      - remove <[hologram]>

hitsplat_display_entity:
  type: entity
  debug: false
  entity_type: text_display
  mechanisms:
    text: Hologram Text
    pivot: vertical
    see_through: false
    text_shadowed: true
    interpolation_start: 0
    interpolation_duration: 4t
    scale: 0,0,0

entity_hitsplat_handler:
  type: world
  debug: false
  events:
    on living|player damaged by player:
      - define loc <context.entity.eye_location>
      - spawn hitsplat_display_entity[text=<&c>-<context.damage.round_to[2]>] <[loc].random_offset[0.2,0.2,0.2]> save:hologram
      - define hologram <entry[hologram].spawned_entity>
      - adjust <[hologram]> scale:<location[0.9,0.9,0.9].random_offset[0.1,0.1,0.1]>
      - wait 2t
      - adjust <[hologram]> <map[interpolation_duration=5s;translation=0,2,0]>
      - wait 2s
      - remove <entry[hologram].spawned_entity>
