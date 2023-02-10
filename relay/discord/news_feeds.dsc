news_feeds_handler:
  type: world
  definitions: channel_id|message_id
  debug: false
  events:
    after discord message received for:c channel:975907326357811260:
      - define author <context.new_message.author>
      - stop if:!<[author].is_bot>
      - stop if:!<[author].name.contains[<&ns>]>

      # example: Denizen and Citizens #changelog
      - define author_name <[author].name.before[ <&ns>]>
      - define news_channel_name <[author].name.after[<&ns>]>
      - define news_channel_id <[author].id>
      - define author_icon_url <[author].avatar_url>
      - define message <context.new_message.text>

      # construct the embed
      - definemap embed:
          author:
            name: <[author_name]>
            icon_url: <[author_icon_url]>
          title: <&ns><[news_channel_name]>
          description: <[message].substring[0,3999]>
          color: <color[0,254,255].rgb_integer>
      - define embeds <list_single[<[embed]>]>

      # create headers
      - definemap headers:
          Authorization: <secret[cbot]>
          Content-Type: application/json
          User-Agent: b

      # create the forum thread if it doesn't exist
      - if <server.has_flag[behr.discord.news_feeds.channels.<[news_channel_id]>]>:
        - define channel_id <server.flag[behr.discord.news_feeds.channels.<[news_channel_id]>]>
        - inject create_news_post

      # send the message
      - else:
        - inject create_news_forum_post

create_news_post:
  type: task
  debug: false
  definitions: channel_id|embeds
  script:
    # create data
    - definemap data:
        embeds: <[embeds]>

    - define url https://discord.com/api/channels/<[channel_id]>/messages
    - ~webget <[url]> data:<[data].to_json> method:post headers:<[headers]> save:response
    - inject web_debug.webget_response

create_news_forum_post:
  type: task
  debug: false
  definitions: embeds
  script:
    # create data
    - definemap data:
        #name: 1-100 characters
        name: <[author_name]> - <&ns><[news_channel_name]>
        message:
          embeds: <[embeds]>
      #|auto_archive_duration: 60, 1440, 4320, 10080 minutes to auto-close
      #|rate_limit_per_user: amount of seconds ratelimiting players for messages
      #|message: forum message thread which is;
        #|content: 1-2000 characters
        #|embeds: embedded messages up to 6000 characters
        #|allowed_mentions: just another key under it parse: <list>
        #|components: buttons and shit
        #|files: oh shit not this again
        #|attachments: i will die
        #|flags: things like crossposted, is_crossposted, suppress_embeds, source_message_deleted, urgent, has_thread, ephemeral, loading, failed_to_mention_some_roles_in_thread
        #| half of those threads are weird af
      #|applied_tags: IDs of tags to apply?

    - define url https://discord.com/api/channels/1072261443027734561/threads
    - ~webget <[url]> data:<[data].to_json> method:post headers:<[headers]> save:response
    - inject web_debug.webget_response
    - define channel_id <util.parse_yaml[<entry[response].result>].get[id]>
    - flag server behr.discord.news_feeds.channels.<[news_channel_id]>:<[channel_id]>
    # todo: check if this was successful or not, try again later if not
