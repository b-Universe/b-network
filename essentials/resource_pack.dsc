resource_command:
  type: command
  name: resource
  debug: false
  usage: /resource
  description: Grabs the resource pack
  script:
    - if !<context.args.is_empty> && !<player.name.contains[behr]>:
      - inject command_syntax_error

    - if <context.args.size> == 1:
      - define player_name <context.args.first>
      - inject command_online_player_verification
    - else:
      - define player <player>

    - define url https://download.mc-packs.net/pack/a62acf61a8d1311eb6acad3b348b7dbc02735bde.zip
    - define hash a62acf61a8d1311eb6acad3b348b7dbc02735bde

    - resourcepack url:<[url]> hash:<[hash]> targets:<[player]>

resource_handler:
  type: world
  events:
    after player joins:
    - wait 1s

    - define url https://download.mc-packs.net/pack/a62acf61a8d1311eb6acad3b348b7dbc02735bde.zip
    - define hash a62acf61a8d1311eb6acad3b348b7dbc02735bde

    - playsound <player> entity_player_levelup pitch:<util.random.decimal[0.8].to[1.2]> volume:0.3 if:<player.has_flag[behr.essentials.settings.playsounds]>
    - resourcepack url:<[url]> hash:<[hash]>
