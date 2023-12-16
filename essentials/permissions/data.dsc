permission_data:
  type: data
  groups:
  # █  [ level one groups   ] █:
    newbie:
      level: 1
      formatted_name: <&b>Newbie
      permissions:
        commands:
          - settings

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
          - regular
        commands:
          - builder
          - weather
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
          - regular
          - sponsor_1

  # █  [ level four groups  ] █:
    moderator:
      level: 4
      formatted_name: <&b>Moderator
      disord_role_id: 901618453356630047
      permissions:
        inherits:
          - regular
          - sponsor_1
        commands:
          - group
          - gamemode
          - spectator
          - survival
          - gms
          - gmsp
          - world

          - kick
    sponsor_1:
      level: 4
      formatted_name: <&3>[<&b>★Sponsor★<&3>]
      disord_role_id: 1072628131598438512
      permissions:
        inherits:
          - regular
        commands:
          - hat
    sponsor_2:
      level: 4
      formatted_name: <&3>[<&b>★Sponsor★★<&3>]
      disord_role_id: 1072642156088545371
      permissions:
        inherits:
          - sponsor_1
    sponsor_3:
      level: 4
      formatted_name: <&3>[<&b>★Sponsor★★★<&3>]
      disord_role_id: 1072643109973938246
      permissions:
        inherits:
          - sponsor_2
    wizard_of_alchemy:
      level: 4
      formatted_name: <&6>[🧪<&e>Chemmy Wizzy🧪<&6>]
      permissions:
        inherits:
          - newbie
          - regular

  # █  [ level five groups  ] █:
    admin:
      level: 5
      formatted_name:  <&b>Admin
      permissions:
        inherits:
          - dnt
          - master_builder
          - elderly_owl
          - good_denizzle
          - moderator
          - sponsor_3
          - wizard_of_alchemy
        commands:
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

          - ex
          - npc
          - /r
          - worldborder
          - denizen
          - save-all
          - chunky
          - dynmap
    # disord_role_id: 901618453356630047

  # █  [ level six groups   ] █:
    coordinator:
      level: 6
      formatted_name:  <&5>[<&d><&o>B Coordinator<&5>]
      disord_role_id: 901618453356630049
      permissions:
        inherits:
          - admin
        commands:
          - datapack

  # █  [ invalid testing group ] █:
    test:
      level: 69
