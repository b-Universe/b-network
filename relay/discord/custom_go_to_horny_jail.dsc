create_custom_discord_hornyjail_command:
  type: task
  debug: false
  script:
    - definemap options:
        1:
          type: user
          name: discord_user
          description: Specify a user to send to horny jail
          required: true
        2:
          type: string
          name: duration
          description: Duration of time to submit to hornyjail, maximum duration being 28 days (currently).
          required: false
    - ~discordcommand id:c create name:hornyjail options:<[options]> "description:Commit someone to horny jail." group:901618453356630046

custom_discord_hornyjail_handler:
  type: world
  debug: false
  sub_paths:
    error_response:
      - define embed <[embed].with[color].as[<color[100,0,0]>]>
      - define embed <[embed].with[footer_icon].as[https://cdn.discordapp.com/emojis/901634983867842610.gif]>

      - ~discordinteraction reply interaction:<context.interaction> <[embed]> save:message ephemeral
      - stop

    mute_user:
      - if <[duration].in_seconds> == 69:
        - define description "<&lt><&co>b_timeout<&co>1067859276967727175<&gt> <[discord_user].mention> was committed to hornyjail for `69 seconds`"
      - else if <[duration].in_seconds> == 269:
        - define description "<&lt><&co>b_timeout<&co>1067859276967727175<&gt> <[discord_user].mention> was committed to hornyjail for `269 seconds`<n><&gt> ||Because it takes two to 69!||"
      - else:
        - define description "<&lt><&co>b_timeout<&co>1067859276967727175<&gt> <[discord_user].mention> was committed to hornyjail for `<[duration].formatted_words>`"
      - define embed <[embed].with[description].as[<[description]>].with[image].as[https://cdn.discordapp.com/attachments/901618453356630054/1073760717255217182/bonk-doge.gif]>
      - discordinteraction reply interaction:<context.interaction> <[embed]>

  events:
    after discord slash command name:hornyjail:
    - define discord_user <context.options.get[discord_user]>
    - define duration <context.options.get[duration].if_null[69s]>

    # check if the duration is valid
    - define duration <duration[<[duration].replace_text[ ]>].if_null[null]>
    - if !<[duration].is_truthy>:
      - define embed "<discord_embed.with[footer].as[You specified an invalid duration<n>For reference on using this properly<&co> `t`=ticks (0.05 seconds), `s`=seconds, `m`=minutes (60 seconds), `h`=hours (60 minutes), `d`=days (24 hours), and `w`=weeks (7 days)<n> The maximum allowed timeout is twenty eight days.]>"
      - inject custom_discord_hornyjail_handler.sub_paths.error_response

    # check if it exceeds twenty eight days, the maximum
    # todo: increase the duration, we're totally capable of just re-applying it
    - if <[duration].in_seconds> > 2419200:
      - define warning "Duration exceeded maximum twenty eight days - Defaulting to `69 seconds`"
      - define duration <duration[28d]>

    - if <[discord_user].id> == 194619362223718400:
      - define embed "<discord_embed.with[footer].as[Sorry, I dont think Behr is horny.]>"
      - inject custom_discord_hornyjail_handler.sub_paths.error_response

    - if <[discord_user].id> == 905309299524382811:
      - define embed "<discord_embed.with[footer].as[I'm not horny, I promise!]>"
      - inject custom_discord_hornyjail_handler.sub_paths.error_response

    - define embed <discord_embed.with[color].as[<color[0,254,255]>]>
    - inject custom_discord_hornyjail_handler.sub_paths.mute_user
    - discordtimeout id:c add user:<[discord_user]> group:901618453356630046 duration:<[duration]>
