get_user_of_interaction_from_other_bot_interaction:
  type: task
  definitions: channel_id|message_id
  script:
    - definemap headers:
        Authorization: <secret[bbot]>
        Content-Type: application/json
        User-Agent: B
    - ~webget https://discord.com/api/channels/<[channel_id]>/messages/<[message_id]> headers:<[headers]> save:response
    - if <entry[response].failed.if_null[true]>:
      - debug debug "Webget failed"
      - stop
    - define result <entry[response].result>
    - define data <util.parse_yaml[{<&dq>data<&dq><&co><[result]>}].get[data].if_null[invalid]>
    - if <[data]> == invalid:
      - debug debug "Result parsing failed, verify data received"
      - stop
    - define interaction <[data].get[interaction]>
    - define user <[interaction].get[user]>image.png
    - define user_id <[user].get[id]>
    - define discord_user_object <discord_user[<[user_id]>,b]>

# /ex run get_user_of_interaction_from_other_bot_interaction defmap:<map[message_id=1047195569577271437;channel_id=901618453356630055]>
