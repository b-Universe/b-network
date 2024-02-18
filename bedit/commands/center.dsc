bedit_center_command:
  type: command
  debug: true
  enaled: true
  name: /center
  usage: //center
  description: Changes the material at the center of the selection
  script:
    # % ██ [ Check if a player has a selection they can set ] ██:
    - inject bedit_check_for_selection

    - if <context.args.is_empty>:
      - inject command_syntax_error

    # % ██ [ Check material             ] ██:
    - define new_material <context.args.first>
    - if !<material[<[new_material]>].exists>:
      - define reason "<[new_material]> is an invalid material."
      - inject command_error

    # % ██ [ Add base definitions       ] ██:
    - define sound <[new_material].as[material].block_sound_data>
    - define blocks <[cuboid].blocks>
    - if <[new_material]> == air:
      - define blocks <[blocks].filter[advanced_matches[!air]]>
    - define center <[cuboid].center>

    - foreach <[center].sub[0.4,0.4,0.4].to_cuboid[<[center].add[0.4,0.4,0.4]>].blocks> as:location:
      - define old_material <[location].material>
      - flag <[location]> behr.essentials.bedit.old_material:<[old_material]>

      - if <[new_material]> != air:
        - playeffect at:<[location].center> effect:block_dust special_data:<[new_material]> offset:0.25 quantity:50 visibility:100
        - give <[location].material.item> to:<player.inventory> if:<player.gamemode.equals[survival]>
      - else:
        - playeffect at:<[location].center> effect:block_dust special_data:<[old_material]> offset:0.25 quantity:50 visibility:100
      - modifyblock <[location]> <[new_material]> no_physics

      - if <[new_material]> matches air && <[old_material]> !matches air:
        - playsound <[location]> sound:<[sound.break_sound]> volume:<[sound.volume].add[1]> pitch:<[sound.pitch]>
      - else:
        - playsound <[location]> sound:<[sound.place_sound]> volume:<[sound.volume].add[1]> pitch:<[sound.pitch]>
        - take item:<[new_material]> if:<player.gamemode.equals[survival]>
      - wait 1t

      - flag player behr.essentials.profile.stats.construction.experience:++
    # check if empty, return center if so
    # check if they have a selection
    # check the type of selection
    # modifyblock the center halfway through, divide by two|+one for even size, just divide by two and round up
