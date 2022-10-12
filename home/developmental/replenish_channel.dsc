replenish_channel:
  type: task
  debug: false
  script:
    - define old_channel_id 909416438442377248
    - define new_channel_id 1020700450384777276

    - define headers <map[User-Agent=B;Content-Type=application/json]>

    - define url <secret[webhook_here]>
    #?thread_id=<[new_channel_id]>

    - define first_message <discord_channel[b,<[old_channel_id]>].first_message>
    - define last_message <discord_channel[b,<[old_channel_id]>].last_message>
    - define current_message <[first_message]>

    - while true:

      - define author <[current_message].author>
      - definemap data:
          username: <[author].nickname[<discord_group[b,901618453356630046]>].if_null[<[author].name>]>
          avatar_url: <[author].avatar_url>
          thread_id: <[new_channel_id]>

      - define data.content <[current_message].text.substring[0,1950]>
      - narrate <[data].to_json>
      - if <[data.content]> != <empty>:
        - ~webget <[url]> data:<[data].to_json> headers:<[headers]> method:POST save:message
      - if <entry[message].failed>:
        - narrate "<&[red]>webget failed; <entry[message].result.if_null[invalid]>"
        - stop

      - if !<[current_message].attachments.is_empty>:
        - foreach <[current_message].attachments> as:attachment:
          - wait 3s
          - define data.content <[attachment]>
          - ~webget <[url]> data:<[data].to_json> headers:<[headers]> method:POST save:message
          - if <entry[message].failed>:
            - narrate "<&[red]>webget failed; <entry[message].result.if_null[invalid]>"
            - stop

      - if <[current_message]> == <[last_message]>:
        - while stop
      - define current_message <[current_message].next_messages[1].first>
      - wait 3s
