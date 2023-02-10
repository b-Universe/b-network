discord_join_handler:
  type: world
  debug: false
  events:
    after discord user joins:
      # % ██ [ generic information                    ] ██
      - define user <context.user>
      - define channel_id 976805191586287686
      - define user_id <[user].id>
      - define time <util.time_now.sub[<util.time_now.epoch_millis.sub[<[user_id].div[4194304].add[1420070400000]>].mul[0.001]>].epoch_millis.div[1000].round_up>
      - define account_age_formatted "<&lt>t<&co><[time]><&co>D<&gt>, <&lt>t<&co><[time]><&co>R<&gt>"

      # % ██ [ defome content description and content ] ██
      - define context "<list_single[Discord Profile<&co> <&lt>@<[user_id]><&gt>]>"
      - define context "<[context].include_single[Discord ID<&co> `<[user_id]>`]>"
      - define context "<[context].include_single[Discord Account Creation<&co> <[account_age_formatted]>]>"

      # % ██ [ define embed content                   ] ██
      - definemap embed_data:
          color: <color[0,254,255]>
          title: "<[user].name><&ns> `<[user].discriminator>` joined the Discord!"
          description: <[context].separated_by[<n>]>
          thumbnail: <[user].avatar_url>

      - define embed <discord_embed.with_map[<[embed_data]>]>

      # % ██ [ send information                       ] ██
      - if !<[user].has_flag[discorddata.first_joined]>:
        - flag <[user]> discorddata.first_joined:<util.time_now>
      - flag server behr.discord.users.<[user_id]>.level:0
      - flag server behr.discord.users.<[user_id]>.experience:0
      - ~discordmessage id:c channel:<[channel_id]> <[embed]>

reannounce_discord_join:
  type: task
  debug: false
  definitions: user_id
  script:
      # % ██ [ generic information                    ] ██
      - define user <discord_user[c,<[user_id]>]>
      - define channel_id 976805191586287686

      # % ██ [ define user information                ] ██
      - define username <[user].name>
      - define user_id <[user].id>
      - define discriminator <[user].discriminator>
      - define user_avatar <[user].avatar_url>

      # % ██ [ format timestamps                      ] ██
      - define time <util.time_now.sub[<util.time_now.epoch_millis.sub[<[user_id].div[4194304].add[1420070400000]>].mul[0.001]>].epoch_millis.div[1000].round_up>
      - define account_age_formatted "<&lt>t<&co><[time]><&co>D<&gt>, <&lt>t<&co><[time]><&co>R<&gt>"

      # % ██ [ defome content description and content ] ██
      - define title "<[username]>`<&ns><[discriminator]>` joined the Discord!"
      - define context "<list_single[Discord Profile<&co> <&lt>@<[user_id]><&gt>]>"
      - define context "<[context].include_single[Discord ID<&co> `<[user_id]>`]>"
      - define context "<[context].include_single[Discord Account Creation<&co> <[account_age_formatted]>]>"

      - define thumbnail_url <[user_avatar]>
      - define title <[title]>
      - define description <[context].separated_by[<n>]>

      # % ██ [ define embed content                   ] ██
      - definemap embed_data:
          title: <[title]>
          description: <[description]>
          color: <color[0,254,255]>
          thumbnail: <[user_avatar]>
      - define embed <discord_embed.with_map[<[embed_data]>]>

      # % ██ [ send information                       ] ██
      - ~discordmessage id:c channel:<[channel_id]> <[embed]>
      - if !<[user].has_flag[discorddata.first_joined]>:
        - flag <[user]> discorddata.first_joined:<util.time_now>
