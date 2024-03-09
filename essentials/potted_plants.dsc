essentials:
  type: world
  debug: false
  events:
    after player right clicks potted_*:
      - define old_material <context.location.material.name.after[potted_]>
      - define old_potted_material <context.location.material>
      - define new_material potted_<context.item.material.name>
      - define new_potted_material <material[<[new_material]>].if_null[null]>

      - if !<[new_potted_material].is_truthy> || <context.location.material.name> == <[new_potted_material]>:
        - determine passively cancelled
        - playeffect at:<context.location.center> effect:block_dust special_data:<[old_potted_material]> offset:0.25 quantity:10 if:<[old_potted_material].exists>
        - repeat 3:
          - playsound <context.location> sound:block_grass_step pitch:2
          - wait 3t
        - stop

      - drop <context.location.material.name.after[potted_]> <context.location.center> if:<player.gamemode.equals[survival]>
      - if <context.hand> == hand:
        - animate <player> animation:swing_main_hand
        - take iteminhand quantity:1 if:<player.gamemode.equals[survival]>
      - else:
        - animate <player> animation:swing_off_hand
        - take slot:offhand quantity:1 if:<player.gamemode.equals[survival]>
      - playeffect at:<context.location.center> effect:block_dust special_data:<context.location.material.name.after[potted_].as[material]> offset:0.25 quantity:10
      - modifyblock <context.location> <[new_material]>
