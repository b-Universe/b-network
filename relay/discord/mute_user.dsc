create_discord_unmute_command:
  type: task
  debug: false
  script:
    - definemap options:
        1:
          type: user
          name: discord_user
          description: Defines the specific Discord user to unmute. Unmutes the Minecraft player attached, if linked.
          required: true
    - ~discordcommand id:c create name:unmute options:<[options]> "description:Unmutes the Discord user specified" group:901618453356630046

create_discord_mute_command:
  type: task
  debug: false
  script:
    - definemap options:
        1:
          type: string
          name: duration
          description: Duration of time to mute this user or player for between 5 seconds and 28 days
          required: true
        2:
          type: user
          name: discord_user
          description: Defines the specific Discord user to mute. Mutes the Minecraft player attached, if linked.
          required: false
        #3:
        #  type: string
        #  name: minecraft_player
        #  description: Defines the specific Minecraft player to mute. Mutes the discord user attached, if linked.
        #  required: false
        4:
          type: string
          name: discord_user_id
          description: Defines the specific Discord user by ID to mute. Mutes the Minecraft player attached, if linked.
          required: false
        5:
          type: string
          name: reason
          description: Specifies the reason this mute was initiated
          required: false
        #6:
        #  type: string
        #  name: reason_references
        #  description: Adds message references as to why a user is muted
        #  required: false
    # comment: h
    - ~discordcommand id:c create name:mute options:<[options]> "description:Mutes the Discord user specified" group:901618453356630046

discord_mute_handler:
  type: world
  debug: false
  sub_paths:
    error_response:
      - define embed <[embed].with[color].as[<color[100,0,0]>]>
      - define embed <[embed].with[footer_icon].as[https://cdn.discordapp.com/emojis/901634983867842610.gif]>

      - ~discordinteraction reply interaction:<context.interaction> <[embed]> save:message ephemeral
      - stop

    mute_user:
      - define description <list_single[<&lt>:b_timeout:1067859276967727175<&gt> <[discord_user].mention> was muted for `<[duration].formatted_words>`]>
      - define description "<[description].include_single[**Reason**<&co> <[reason].replace_text[<n>].with[<n><&gt> ]>]>" if:<[reason].is_truthy>
      - define description "<[description].include_single[**Note**<&co> <[warning]>]>" if:<[warning].is_truthy>
      - define embed <[embed].with[description].as[<[description].separated_by[<n><&gt> ]>]>
      - discordinteraction reply interaction:<context.interaction> <[embed]>

  events:
    after discord slash command name:unmute:
      - define discord_user <context.options.get[discord_user]>
      - if !<[discord_user].is_timed_out[<discord_group[c,901618453356630046]>]>:
        - define embed "<discord_embed.with[footer].as[<[discord_user].name> isn't muted.]>"
        - inject discord_mute_handler.sub_paths.error_response

      - definemap embed_data:
          color: <color[0,254,255]>
          description: <[discord_user].mention>'s timeout was removed.
          author_name: <[discord_user].name>
          #author_url: ElementTag of a URL (requires author_name set)
          author_icon_url: <[discord_user].avatar_url>

      - flag <[discord_user]> behr.discord.moderation.mute_lifts:|:<util.time_now>

      - discordinteraction reply interaction:<context.interaction> <discord_embed.with_map[<[embed_data]>]>
      - discordtimeout id:c remove user:<[discord_user]> group:901618453356630046


    after discord slash command name:mute:
    - foreach discord_user|discord_user_id|minecraft_user|duration|reason|reason_references as:definition:
      - define <[definition]> <context.options.get[<[definition]>]> if:<context.options.contains[<[definition]>]>

    # check to make sure a player or user is being targeted
    # todo: add linked minecraft players via && !<[minecraft_user].exists> and You must specify a minecraft player,
    - if !<[discord_user].exists> && !<[discord_user_id].exists>:
      # todo: add the option to just add more references - or specify reason references to a minecraft player or discord user.
      - define embed "<discord_embed.with[footer].as[You must specify a discord user]>"
      - inject discord_mute_handler.sub_paths.error_response


    - define embed <discord_embed.with[color].as[<color[0,254,255]>]>

    # check if the duration is valid
    - define duration <duration[<context.options.get[duration]>].if_null[null]>
    - if !<[duration].is_truthy>:
      - define embed "<[embed].with[footer].as[You specified an invalid duration<n>For reference on using this properly<&co> `t`=ticks (0.05 seconds), `s`=seconds, `m`=minutes (60 seconds), `h`=hours (60 minutes), `d`=days (24 hours), and `w`=weeks (7 days)<n> The maximum allowed timeout is twenty eight days.]>"
      - inject discord_mute_handler.sub_paths.error_response

    # check if it exceeds twenty eight days, the maximum
    # todo: increase the duration, we're totally capable of just re-applying it
    - if <[duration].in_seconds> > 2419200:
      - define warning "Duration exceeded maximum twenty eight days - Defaulting to `28d`"
      - define duration <duration[28d]>

    # check if user ID is numerical, if used
    - if <[discord_user_id].exists>:

      # check if it's a valid number
      - if !<[discord_user_id].is_integer>:
        - define embed "<[embed].with[footer].as[Invalid user ID; user IDs are only numbers.]>"
        - inject discord_mute_handler.sub_paths.error_response

      # check if the user is a valid user
      - if !<discord_user[c,<[discord_user_id]>].name.exists>:
        # todo: just check if it's a message id for them first
        - define embed "<[embed].with[footer].as[Invalid user ID; try checking if you copied a message ID instead]>"
        - inject discord_mute_handler.sub_paths.error_response

      - define discord_user <discord_user[c,<[discord_user_id]>]>


    - if <[discord_user].id> == 194619362223718400:
      - define embed "<discord_embed.with[footer].as[Sorry, I can't mute them, they're immune.]>"
      - inject discord_mute_handler.sub_paths.error_response

    - if <[discord_user].id> == 905309299524382811:
      - define embed "<discord_embed.with[footer].as[You can't mute me! I'm Champagne!]>"
      - inject discord_mute_handler.sub_paths.error_response

    - inject discord_mute_handler.sub_paths.mute_user
    - discordtimeout id:c add user:<[discord_user]> group:901618453356630046 "reason:<[reason].if_null[No reason specified]>" duration:<[duration]>

        #- define embed "<[embed].with[footer].as[]>"
        #- inject discord_mute_handler.sub_paths.error_response

discord_api_mute_user:
  type: task
  definitions: user_id|time|reason
  debug: false
  script:
    # hardcode my guild ID
    - define guild_id 901618453356630046 if:!<[guild_id].exists>

    # create headers
    - definemap headers:
        Authorization: <secret[cbot]>
        Content-Type: application/json

    - definemap data:
    #   format: 2023-01-08T06:49:00.996+0200
        communication_disabled_until: <util.time_now.add[<[time]>].format[yyyy-MM-dd'T'HH:mm:ss.s'Z']>

    - define headers <[headers].with[X-Audit-Log-Reason].as[<map.with[reason].as[<[reason]>]>]> if:<[reason].exists>

    - ~webget https://discord.com/api/guilds/<[guild_id]>/members/<[user_id]> data:<[data].to_json> method:PATCH headers:<[headers]> save:response
