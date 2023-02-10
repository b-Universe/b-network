champagne_dm_tracking:
  type: world
  debug: false
  events:
    on discord message received:
      - stop if:!<context.new_message.is_direct>

      - define user <context.new_message.author>
      - definemap embed_data:
          color: <color[0,254,255]>
          author_name: <[user].name>
          author_icon_url: <[user].avatar_url>
          description: <context.new_message.text>

      - if <discord_channel[c,1072097305966157834].active_threads.parse[name].contains[<[user].name>]>:
        - define channel <discord_channel[c,1072097305966157834].active_threads.filter[name.equals[<[user].name>]].first>
        - discordmessage id:c channel:<[channel]> <discord_embed.with_map[<[embed_data]>]>
      - else:
        - ~discordcreatethread id:c name:<[user].name> parent:1072097305966157834 save:thread
        - discordmessage id:c channel:<entry[thread].created_thread> <discord_embed.with_map[<[embed_data]>]>
