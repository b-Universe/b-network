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
    dnt:
      level: 2
      formatted_name: <&4>[<red>DNT<bold><&chr[2193]><&4>]
      disord_role_id: 1061088975667855511

  # █  [ level three groups ] █:
    master_builder:
      level: 3
      formatted_name:  <&3>[<&b>░Master Builder░<&3>]
    elderly_owl:
      level: 3
      disord_role_id: 1162107100177121342
    good_denizzle:
      level: 3
      formatted_name: <&6>[<&e>✎Good Denizzle✎<&6>]
      disord_role_id: 901639099562225744

  # █  [ level four groups  ] █:
    moderator:
      level: 4
      formatted_name: <&b>Moderator
      disord_role_id: 901618453356630047
    sponsor_1:
      level: 4
      formatted_name: <&3>[<&b>★Sponsor★<&3>]
      disord_role_id: 1072628131598438512
    sponsor_2:
      level: 4
      formatted_name: <&3>[<&b>★Sponsor★★<&3>]
      disord_role_id: 1072642156088545371
    sponsor_3:
      level: 4
      formatted_name: <&3>[<&b>★Sponsor★★★<&3>]
      disord_role_id: 1072643109973938246
    wizard_of_alchemy:
      level: 4
      formatted_name: <&6>[🧪<&e>Chemmy Wizzy🧪<&6>]

  # █  [ level five groups  ] █:
    admin:
      level: 5
      formatted_name:  <&b>Admin
    # disord_role_id: 901618453356630047

  # █  [ level six groups   ] █:
    coordinator:
      level: 5
      formatted_name:  <&5>[<&d><&o>B Coordinator<&5>]
      disord_role_id: 901618453356630049
      permissions:
        inherits:
          - newbie

  # █  [ invalid testing group ] █:
    test:
      level: 69
