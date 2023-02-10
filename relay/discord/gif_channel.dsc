discord_gif_channel_handler:
  type: world
  debug: false
  events:
    on discord message received channel:1072553008560349205:
      - define message <context.new_message>
      - define user <[message].author>
      - stop if:<[user].advanced_matches[<context.bot.self_user>]>
      - if !<[message].text.contains_any_text[https://|http://]> && <[message].attachments.is_empty>:
        - define channel_id <[message].channel.id>
        - define reason "Wrongly using the GIF only channel"
        - run discord_delete_message_api def:<[channel_id]>|<[message].id>|<[reason]>
        - flag <[user]> behr.discord.moderation.wrong_gif_channel_usage:++ expire:1m
