permission_data:
  type: data
  groups:
  # █  [ level one groups   ] █:
    newbie:
      level: 1
      formatted_name: <&b>Newbie
      permissions:
        commands:
          - bed
          - discord
          - dynmap
          - resource
          - settings
          - spawn
  # █  [ level two groups   ] █:
    regular:
      level: 2
      formatted_name: <&b>Regular
      permissions:
        inherits:
          - newbie
        commands:
          - me
          - ping
          - crafting_table

          - /pos1
          - /pos2
          - /bset
          - /bstack
          - /center
          - /frame
          - /shell
    dnt:
      level: 2
      formatted_name: <&4>[<red>DNT<bold><&chr[2193]><&4>]
      disord_role_id: 1061088975667855511

  # █  [ level three groups ] █:
    master_builder:
      level: 3
      formatted_name:  <&3>[<&b>░Master Builder░<&3>]
      permissions:
        inherits:
          - newbie
          - regular
          - sponsor_1
        commands:
          - builder
          - weather
          - time
          - fly
          - fly_speed
          - gamemode
          - survival
          - gms
          - gmb
    elderly_owl:
      level: 3
      disord_role_id: 1162107100177121342
      permissions:
        inherits:
          - newbie
          - regular
          - sponsor_1
    good_denizzle:
      level: 3
      formatted_name: <&6>[<&e>✎Good Denizzle✎<&6>]
      disord_role_id: 901639099562225744
      permissions:
        commands:
          - survival
          - spectator
        inherits:
          - newbie
          - regular
          - sponsor_1

  # █  [ level four groups  ] █:
    moderator:
      level: 4
      formatted_name: <&b>Moderator
      disord_role_id: 901618453356630047
      permissions:
        inherits:
          - newbie
          - regular
          - sponsor_1
        commands:
          - group
          - gamemode
          - spectator
          - survival
          - gms
          - gmsp
          - inventory_look
          - teleport

          - kick
    sponsor_1:
      level: 4
      formatted_name: <&3>[<&b>★Sponsor★<&3>]
      disord_role_id: 1072628131598438512
      permissions:
        inherits:
          - newbie
          - regular
        commands:
          - hat
    sponsor_2:
      level: 4
      formatted_name: <&3>[<&b>★Sponsor★★<&3>]
      disord_role_id: 1072642156088545371
      permissions:
        inherits:
          - newbie
          - regular
          - sponsor_1
    sponsor_3:
      level: 4
      formatted_name: <&3>[<&b>★Sponsor★★★<&3>]
      disord_role_id: 1072643109973938246
      permissions:
        inherits:
          - newbie
          - regular
          - sponsor_1
          - sponsor_2
    wizard_of_alchemy:
      level: 4
      formatted_name: <&6>[🧪<&e>Chemmy Wizzy🧪<&6>]
      permissions:
        inherits:
          - newbie
          - regular
          - sponsor_1

  # █  [ level five groups  ] █:
    admin:
      level: 5
      formatted_name:  <&b>Admin
      permissions:
        inherits:
          - newbie
          - regular
          - dnt
          - master_builder
          - elderly_owl
          - good_denizzle
          - moderator
          - sponsor_1
          - sponsor_2
          - sponsor_3
          - wizard_of_alchemy
        commands:
          - command_refresh
          - group_refresh
          - restart
          - heal
          - weather
          - fly
          - fly_speed
          - gamemode
          - gmc
          - creative
          - debug
          - experience
          - weather
          - time

          - ex
          - npc
          - /r
          - worldborder
          - denizen
          - save-all
          - chunky
          - dynmap
          - copy_to_clipboard
    # disord_role_id: 901618453356630047

  # █  [ level six groups   ] █:
    coordinator:
      level: 6
      formatted_name:  <&5>[<&d><&o>B Coordinator<&5>]
      disord_role_id: 901618453356630049
      permissions:
        inherits:
          - newbie
          - regular
          - dnt
          - master_builder
          - elderly_owl
          - good_denizzle
          - moderator
          - sponsor_1
          - sponsor_2
          - sponsor_3
          - wizard_of_alchemy
          - admin
        commands:
          - datapack
          - place

  # █  [ invalid testing group ] █:
    test:
      level: 69
