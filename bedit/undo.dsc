bedit_undo_command:
  type: command
  debug: false
  enabled: true
  name: bundo
  usage: /bundo
  description: Undos bEdit actions made
  script:
    # Stop if they don't have anything to undo
    - if !<player.flag[behr.essentials.bedit.history].is_truthy>:
      - define reason "You don't have anything to undo"
      - inject command_error

    # Check for anything left to undo
    - define times <player.flag[behr.essentials.bedit.history].filter_tag[<[filter_value.action].is_in[set|redo|stack]>].keys>
    - if <[times].is_empty>:
      - define reason "You don't have anything left to undo"
      - inject command_error
    - define time <[times].highest>

    # Hide the display entities
    - inject hide_bedit_display_entity

    # Loop through the blocks
    - foreach <player.flag[behr.essentials.bedit.history.<[time]>.block]> key:location as:new_material:
      - define location <location[<[location]>]>
      - define old_material <[location].material>
      - define sound <[new_material].block_sound_data>
      - define old_sound <[old_material].block_sound_data>
      - playeffect at:<[location].center> effect:block_dust special_data:<[new_material]> offset:0.25 quantity:50 visibility:100
      - playeffect at:<[location].center> effect:block_dust special_data:<[new_material]> offset:0.25 quantity:50 visibility:100
      - if <[old_material]> !matches air:
        - playsound <[location]> sound:<[old_sound.break_sound]> volume:<[old_sound.volume].add[1]> pitch:<[old_sound.pitch]>
      - wait 1t
      - if <[new_material]> !matches air:
        - playsound <[location]> sound:<[sound.place_sound]> volume:<[sound.volume].add[1]> pitch:<[sound.pitch]>
      - if <player.gamemode.equals[survival]>:
        - take item:<[new_material]>
        - drop <[old_material].item> <[location].center> speed:0
      - modifyblock <[location]> <[new_material]> no_physics

      - flag <[location]> behr.essentials.bedit.history.<[time]>.player:<player> expire:1d
      - flag <[location]> behr.essentials.bedit.history.<[time]>.old_material:<[old_material]> expire:1d
      - flag <[location]> behr.essentials.bedit.history.<[time]>.action:undo expire:1d
      - flag <player> behr.essentials.bedit.history.<[time]>.block.<[location].simple>:<[old_material]> expire:1d
      - flag <player> behr.essentials.bedit.history.<[time]>.action:undo expire:1d

    - inject show_bedit_display_entity

    - if <player.flag[behr.essentials.bedit.history].size> > 10:
      - define time <player.flag[behr.essentials.bedit.history].keys.lowest>
      - flag <player> behr.essentials.bedit.history.<[time]>:!