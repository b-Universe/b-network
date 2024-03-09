discord_link_command:
  type: command
  debug: false
  enabled: false
  name: discorde
  usage: /discorde (code)
  description: Links your Disord and Minecraft accounts or gives you the invite
  data:
    invite_url: https<&co>//www.behr.dev/Discord
  script:
  # % ██ [ check if typing arguments                  ] ██:
    - if <context.args.size> > 1:
      - narrate "<&c>Invalid usage - just use <&6>/<&e>discord<&c>or <&6>/<&e>discord connect <&gt>code<&lt>)"

  # % ██ [ define base definitions                    ] ██:
    - else if <context.args.is_empty>:
      - define url <script.parsed_key[data.invite_url]>
      - if <player.has_flag[behr.essentials.discord.state]>:
        - define state <player.flag[behr.essentials.discord.state]>
      - else:
        - define state <util.random.duuid>
        - flag <player> behr.essentials.discord.states:<[state]>

    # % ██ [ give the link to our discord             ] ██:
      - playsound <player> entity_player_levelup pitch:<util.random.decimal[0.8].to[1.2]> volume:0.3

      - flag server behr.essentials.discord.states.<[state]>:<player> expire:1d
      - narrate "<&e>To connect your Discord account, please use <&b><underline>/minecraft_link <[state]><&e> on our discord"
      - narrate "<&e>To simply join, use <&b><underline><[url]><&e>!"

    - else:
      - define state <context.args.first>
      - if !<server.has_flag[behr.essentials.discord.states.<[state]>]>:
        - narrate "<&c>Invalid code. Use <&6>/<&e>discord <&c>here or <&6>/<&e>minecraft_link <&c>on Discord for a valid code."
        - stop

      - define user <server.flag[behr.essentials.discord.states.<[state]>.user]>
      - flag <player> behr.essentials.profile.discord:<[user]>
      - flag <[user]> behr.essentials.profile.player:<player>
      - playsound <player> entity_player_levelup pitch:<util.random.decimal[0.8].to[1.2]> volume:0.3
      - narrate "<&a>Your discord account is now linked!"

discord_create_minecraft_link_command:
  type: task
  debug: false
  enabled: false
  script:
  - definemap options:
      1:
        type: string
        name: code
        description: Code you received from Minecraft
        required: false

  - ~discordcommand id:c create name:minecraft_link "description:Links your Disord and Minecraft accounts" group:901618453356630046 options:<[options]>

discord_minecraft_link_command:
  type: world
  debug: false
  enabled: false
  events:
    on discord slash command name:minecraft_link:
    - ~discordinteraction defer interaction:<context.interaction>
    - define user <context.interaction.user>

    - if <context.options.contains[code]>:

      - if <[user].has_flag[behr.essentials.discord.state]>:
        - define state <[user].flag[behr.essentials.discord.state]>
      - else:
        - define state <util.random.duuid>
        - flag <[user]> behr.essentials.discord.states:<[state]>

      - if !<server.has_flag[behr.essentials.discord.states.<[state]>.player]>:
        - definemap embed:
            description: Use <&lt>/minecraft_link<&co>0123456789<&gt> or `/discord` in-game to receive a valid code.
            color: 200,0,0
            footer: "Invalid Code"
            footer_icon: https://cdn.discordapp.com/emojis/901634983867842610.gif
        - discordinteraction reply interaction:<context.interaction> ephemeral embed:<discord_embed.with_map[<[embed]>]>
        - stop

      - define player <server.flag[behr.essentials.discord.states.<[state]>.player]>
      - flag <[player]> behr.essentials.profile.discord:<[user]>
      - flag <[user]> behr.essentials.profile.player:<[player]>
      - definemap embed:
          description: Discord account linked! Thanks <[player].name>!
          color: 200,0,0
          thumbnail: https://minotar.net/armor/bust/<[player].uuid.replace_text[-]>/100.png?date=<util.time_now.format[MM-dd]>
      - discordinteraction reply interaction:<context.interaction> embed:<discord_embed.with_map[<[embed]>]>
      - if <[player].is_online>:
        - playsound <[player]> entity_player_levelup pitch:<util.random.decimal[0.8].to[1.2]> volume:0.3
        - narrate "<&a>Your discord account is now linked!" targets:<[player]>

    - else:
      - define state <util.random.duuid>
      - define embed.color <color[0,254,255]>
      - flag server behr.essentials.discord.states.<[state]>.discord:<[user]> expire:1d
      - definemap embed:
          description: Use `/discord <[state]>` in-game to link your accounts.
          color: 200,0,0
      - discordinteraction reply interaction:<context.interaction> ephemeral embed:<discord_embed.with_map[<[embed]>]>
