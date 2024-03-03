discord_link_command:
  type: command
  debug: false
  enabled: false
  name: discord
  usage: /discord link/connect (code)
  description: Links your Disord and Minecraft accounts
  data:
    invite_url: https<&co>//www.behr.dev/Discord
  tab completions: link|connect
  sub_paths:
    command_error:
      - narrate "<&c>Invalid usage - just use <&6>/<&e>discord<&c>, <&6>/<&e>discord link<&c>, or <&6>/<&e>discord connect (code)"
  script:
  # % ██ [ check if typing arguments                  ] ██:
    - if !<context.args.size> > 2:
      - inject command_syntax_error

  # % ██ [ define base definitions                    ] ██:
    - if <context.args.is_empty> || <context.args.first> == link:
      - define url <script.parsed_key[data.invite_url]>
      - define state <util.random.duuid>

    # % ██ [ give the link to our discord               ] ██:
      - playsound <player> entity_player_levelup pitch:<util.random.decimal[0.8].to[1.2]> volume:0.3

      - flag server behr.essentials.discord.states.<[state]>:<player> expire:1d
      - narrate "<&e>To connect your Discord account, please use <&b><underline>/discord <[state]><&e> on our discord"
      - narrate "<&e>To simply join, use <&b><underline>https<&co>//www.behr.dev/Discord<&e>!"

    - else if <context.args.first> == connect:
      - define url <script.parsed_key[data.invite_url]>
      - define state <util.random.duuid>

    # % ██ [ give the link to our discord               ] ██:
      - playsound <player> entity_player_levelup pitch:<util.random.decimal[0.8].to[1.2]> volume:0.3

      - flag server behr.essentials.discord.states.<[state]>:<player> expire:1d
      - narrate "<&e>To connect your Discord account, please use <&b><underline>/discord <[state]><&e> on our discord"
      - narrate "<&e>To simply join, use <&b><underline>https<&co>//www.behr.dev/Discord<&e>!"

    - else:
      - inject command_syntax_error
