discord_command:
  type: command
  name: discord
  debug: false
  usage: /discord
  description: Gives you the Discord link
  data:
    auth_url: https<&co>//discord.com/oauth2/authorize
    redirect_uri: https<&co>//api.behr.dev/oAuth/Discord
    client_id: 905309299524382811
    state: <util.random.duuid>
  script:
  # % ██ [ check if typing arguments                  ] ██:
    - if !<context.args.is_empty>:
      - inject command_syntax_error

  # % ██ [ define base definitions                    ] ██:
    - define data <script.parsed_key[data]>
    - define url <[data.auth_url]>?client_id=<[data.client_id]>&response_type=code&redirect_uri=<[data.redirect_uri].url_encode>&scope=identify&state=<[data.state]>

  # % ██ [ give the link to our discord               ] ██:
    - playsound <player> entity_player_levelup pitch:<util.random.decimal[0.8].to[1.2]> volume:0.3 if:<player.has_flag[behr.essentials.settings.playsounds]>

    - narrate <&b><underline>https<&co>//www.behr.dev/Discord
    - stop

    # draft:
    - flag server behr.essentials.discord.states.<[state]>:<player> expire:1d
    - narrate "<&e>To connect your Discord account, please click <&b><underline><element[here].on_click[<[url]>].type[open_url]>"
    - narrate "<&e>To simply join, use <&b><underline>https<&co>//www.behr.dev/Discord<&e>!"

discord_oauth_handler:
  type: world
  debug: false
  enabled: false
  events:
    after server start:
  # % ██ [ clear states on startup                    ] ██:
      - flag server behr.essentials.discord.states:!

    on webserver web request port:8080 path:/oAuth/Discord:
  # % ██ [ check for both a code and state query      ] ██:
      - if !<context.query.contains[code|state]>:
        - announce to_console "<&c>State and Code are missing."
        - determine passively code:300
        - determine parsed_file:404.html

      - define code <context.query.get[code]>
      - define state <context.query.get[state]>

  # % ██ [ check the state query                      ] ██:
      - if !<server.has_flag[behr.essentials.discord.states.<[state]>]>:
        - announce to_console "<&c>State was invalid"
        - determine passively code:300
        - determine parsed_file:bad_discord_link.html

  # % ██ [ determine the player verified and save     ] ██:
      - define player <server.flag[behr.essentials.discord.states.<[state]>]>
      - flag server behr.essentials.discord.states.<[state]>:!

  # % ██ [ congratulate the player on a job well done ] ██:
      - if <[player].is_online>:
        - playsound <[player]> entity_player_levelup pitch:<util.random.decimal[0.8].to[1.2]> volume:0.3 if:<[player].has_flag[behr.essentials.settings.playsounds]>
        - narrate "Your discord was successfully connected!"

  # % ██ [ serve a connected confirmation page        ] ██:
      - determine passively code:200
      - determine parsed_file:discord_connected.html
