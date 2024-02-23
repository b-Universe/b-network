resource_command:
  type: command
  name: resource
  debug: false
  usage: /resource
  description: Grabs the resource pack
  script:
  # % ██ [ check if typing arguments                ] ██:
    - if !<context.args.is_empty> && !<player.name.contains[behr]>:
      - inject command_syntax_error

  # % ██ [ temp checking if the player is behr      ] ██:
    - if <context.args.size> == 1:
      - define player_name <context.args.first>
      - inject command_online_player_verification
    - else:
      - define player <player>

  # % ██ [ give the player the resource pack        ] ██:
    - playsound <player> entity_player_levelup pitch:<util.random.decimal[0.8].to[1.2]> volume:0.3 if:<player.has_flag[behr.essentials.settings.playsounds]>
    - define url https:api.behr.dev/resource/b.zip
    - define hash <server.flag[behr.essentials.resource.SHA-1]>
    - resourcepack url:<[url]> hash:<[hash]> targets:<[player]>
    - announce to_console "<&e><player.name> taking pack<&co> <&a><[hash]>"

resource_handler:
  type: world
  debug: false
  events:
    after resource pack status:
      - announce to_console "<&e><player.name> <&3>resource pack status<&b><&co> <&a><context.status>"
    after server start:
      - run resource_fetch
    after player joins:
    - wait 1s

  # % ██ [ give the player the resource pack        ] ██:
    - define url https://api.behr.dev/resource/b.zip
    - define hash <server.flag[behr.essentials.resource.SHA-1]>
    - resourcepack url:<[url]> hash:<[hash]>
    - announce to_console "<&e><player.name> taking pack<&co> <&a><[hash]>"

resource_fetch:
  type: task
  debug: false
  script:
    - ~webget https://api.behr.dev/resource/b.zip headers:[User-Agent=b] save:response
    - inject web_debug.webget_response
    - stop if:<entry[response].failed>
    - flag server behr.essentials.resource.SHA-1:<entry[response].result_binary.hash[SHA-1].to_hex>
