hitsplat_display_command:
    type: command
    debug: false
    name: holome
    description: A debug command.
    usage: /holome
    script:
        - spawn hitsplat_display_entity <player.eye_location.forward_flat[1]> save:holo
        - adjust <entry[holo].spawned_entity> translation:0,2,0
        - wait 2s
        - remove <entry[holo].spawned_entity>

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
        interpolation_duration: 5s

entity_hitsplat_handler:
    type: world
    debug: false
    events:
        on entity damaged by player:
            - define loc <context.entity.location>
            - spawn hitsplat_display_entity[text=<&c>-<context.damage.round_to[2]>] <[loc].above> save:holo
            - adjust <entry[holo].spawned_entity> translation:0,2,0
            - wait 2s
            - remove <entry[holo].spawned_entity>
