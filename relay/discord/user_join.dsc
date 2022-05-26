discord_join_handler:
  type: world
  debug: true
  data:
    invites:
      Denizen and Citizens: https://discord.gg/Q6pZGSR
      Discord Developers: https://discord.gg/discord-developers
      BehrCraft: https://example.com
    threads:
      Denizen and Citizens: 976785685455470663
      Discord Developers: 977174222352822284
      Minecraft Commands: 977174224085086278
      BlockBench news: 977174225070727228
      Inspirational servers: 977174226270294026
  events:
    after discord message received for:c channel:975907326357811260:
      - stop if:!<context.new_message.author.is_bot>
      - define author <context.new_message.author>
      - define author_name "<[author].name.before[ <&ns>]>"

      - define embed_data.author_icon_url <[author].avatar_url>
      - define embed_data.author_name <[author_name]>
      - define embed_data.title "`<&lb><[author_name]><&rb>` <&ns><[author].name.after[ <&ns>]>"
      - define embed_data.title_url <script.parsed_key[data.invites].get[<[author_name]>]> if:<script.parsed_key[data.invites].get[<[author_name]>].exists>
      - define embed_data.description <context.new_message.text.substring[0,3999]>
      - define embed_data.color 0,255,255
      #- define embed_data.attachments <context.new_message.attachments> if:<context.new_message.attachments.exists>
      - if <context.new_message.replied_to.exists>:
        - define embed_data.footer <context.new_message.replied_to.author.name>
        - define embed_data.footer_icon <context.new_message.replied_to.author.avatar_url>
      - define embed <discord_embed.with_map[<[embed_data]>]>
      - ~discordmessage id:c channel:<script.parsed_key[data.threads.<[author_name]>]> <[embed]>

    after discord user joins:
      # generic information
      - define user <context.user>
      - define channel_id 976805191586287686

      # define user information
      - define user_id <[user].id>
      # format timestamps
      - define time <util.time_now.sub[<util.time_now.epoch_millis.sub[<[user_id].div[4194304].add[1420070400000]>].mul[0.001]>].epoch_millis.div[1000].round_up>
      - define account_age_formatted "<&lt>t<&co><[time]><&co>D<&gt>, <&lt>t<&co><[time]><&co>R<&gt>"

      # defome content description and content
      - define context "<list_single[Discord Profile<&co> <&lt>@<[user_id]><&gt>]>"
      - define context "<[context].include_single[Discord ID<&co> `<[user_id]>`]>"
      - define context "<[context].include_single[Discord Account Creation<&co> <[account_age_formatted]>]>"

      # define embed content
      - definemap embed_data:
          color: 0,255,255
          title: "<[user].name><&ns> `<[user].discriminator>` joined the Discord!"
          description: <[context].separated_by[<n>]>
          thumbnail: <[user].avatar_url>

      - define embed <discord_embed.with_map[<[embed_data]>]>

      # send information
      # check if channel archived
      #- if <discord_channel[c,976805191586287686].is_thread_archived>:
      #  - stop
      - ~discordmessage id:c channel:<[channel_id]> <[embed]>
      - if !<[user].has_flag[discorddata.first_joined]>:
        - flag <[user]> discorddata.first_joined:<util.time_now>

  embed:
    title: <[title]>
    description: <[description]>
    color: <color[0,254,255]>
    thumbnail: <[ ]>

reannounce_discord_join:
  type: task
  debug: false
  definitions: user_id
  script:
      # generic information
      - define user <discord_user[c,<[user_id]>]>
      - define channel_id 976805191586287686

      # define user information
      - define username <[user].name>
      - define user_id <[user].id>
      - define discriminator <[user].discriminator>
      - define user_avatar <[user].avatar_url>

      # format timestamps
      - define time <util.time_now.sub[<util.time_now.epoch_millis.sub[<[user_id].div[4194304].add[1420070400000]>].mul[0.001]>].epoch_millis.div[1000].round_up>
      - define account_age_formatted "<&lt>t<&co><[time]><&co>D<&gt>, <&lt>t<&co><[time]><&co>R<&gt>"

      # defome content description and content
      - define title "<[username]>`<&ns><[discriminator]>` joined the Discord!"
      - define context "<list_single[Discord Profile<&co> <&lt>@<[user_id]><&gt>]>"
      - define context "<[context].include_single[Discord ID<&co> `<[user_id]>`]>"
      - define context "<[context].include_single[Discord Account Creation<&co> <[account_age_formatted]>]>"

      - define thumbnail_url <[user_avatar]>
      - define title <[title]>
      - define description <[context].separated_by[<n>]>

      # define embed content
      - define embed <discord_embed.with_map[<script.parsed_key[embed]>]>

      # send information
      # check if channel archived
      #- if <discord_channel[c,976805191586287686].is_thread_archived>:
      #  - stop
      - ~discordmessage id:c channel:<[channel_id]> <[embed]>
      - if !<[user].has_flag[discorddata.first_joined]>:
        - flag <[user]> discorddata.first_joined:<util.time_now>

  embed:
    title: <[title]>
    description: <[description]>
    color: <color[0,254,255]>
    thumbnail: <[user_avatar]>
