discord_mute_command_create:
  type: task
  debug: false
  script:
    - ~discordcommand id:b create group:901618453356630046 name:mute type:message "description:Mutes the Discord or Minecraft user specified"

discord_mute_command_handler:
  type: world
  debug: false
  sub_paths:
    error_response:
      - define embed <[embed].with[color].as[<color[100,0,0]>]>
      - define embed <[embed].with[footer_icon].as[https://cdn.discordapp.com/emojis/901634983867842610.gif]>

      - ~discordinteraction reply interaction:<context.interaction> <[embed]> save:message ephemeral
      - stop

  events:
    on discord message command name:mute:
      - define message <context.interaction.target_message>
      - define message_url https<&co>//discord.com/channels/<context.group.id>/<context.channel.id>/<[message].id>
      - announce to_console "<&e><context.interaction.target_message.author.name> <&a>muted at <&b><[message_url]>"

      - define discord_user <[message].author>
      - define discord_user_id <[discord_user].id>
      - define time <util.time_now>
      - define embed <discord_embed.with[color].as[<color[0,254,255]>]>
      - define duration <duration[24h]>
      - if <[discord_user_id]> == 1102238494631415850:
        - define player <server.match_offline_player[<[discord_user].name>]>
        - define player_name <[player].name>


        - if <[player].uuid> in <server.flag[behr.uuids]>:
          - define embed <discord_embed.with[footer].as[Sorry, I can<&sq>t mute them, they<&sq>re immune.]>
          - inject discord_mute_command_handler.sub_paths.error_response


        - flag <[player]> behr.essentials.muted expire:24h
        - narrate "<red>You were muted." targets:<[player]>

        - definemap embed_data:
            color: <color[0,254,255]>
            author_name: <[player_name]>
            author_url: <[message_url]>
            author_icon_url: <[player].uuid.proc[player_profiles].context[armor/bust|<[time]>]>

        - define embed <discord_embed.with[color].as[<color[0,254,255]>]>
        - define description <list_single[<&lt>:b_timeout:1067859276967727175<&gt> `<[player_name]>` was muted for `<[duration].formatted_words>`]>
        - define description <[description].include_single[**Reason**<&co> <[reason].replace_text[<n>].with[<n><&gt> ]>]> if:<[reason].is_truthy>
        - define description <[description].include_single[**Note**<&co> <[warning]>]> if:<[warning].is_truthy>
        - define embed <[embed].with[description].as[<[description].separated_by[<n><&gt> ]>]>

        - flag server champagne.relay_ratelimit
        - ~discordinteraction reply interaction:<context.interaction> <[embed]>
        - flag server champagne.relay_ratelimit:!
      - else:
        - if <[discord_user_id]> == 194619362223718400:
          - define embed <discord_embed.with[footer].as[Sorry, I can<&sq>t mute them, they<&sq>re immune.]>
          - inject discord_mute_command_handler.sub_paths.error_response

        - if <[discord_user_id]> == 905309299524382811:
          - define embed <discord_embed.with[footer].as[You can<&sq>t mute me! I<&sq>m Champagne!]>
          - inject discord_mute_command_handler.sub_paths.error_response

        - discordtimeout id:b add user:<[discord_user]> group:901618453356630046 reason:right-click-command duration:<[duration]>

        - definemap embed_data:
            color: <color[0,254,255]>
            author_name: <[message].author.name>
            author_url: <[message_url]>
            author_icon_url: <[message].author.avatar_url>

        - define description <list_single[<&lt>:b_timeout:1067859276967727175<&gt> <[discord_user].mention> was muted for `<[duration].formatted_words>`]>
        - define description <[description].include_single[**Reason**<&co> <[reason].replace_text[<n>].with[<n><&gt> ]>]> if:<[reason].is_truthy>
        - define description <[description].include_single[**Note**<&co> <[warning]>]> if:<[warning].is_truthy>
        - define embed <[embed].with[description].as[<[description].separated_by[<n><&gt> ]>]>

        - ~discordinteraction reply interaction:<context.interaction> <[embed]>
