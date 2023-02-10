# | ██ [ Deletes a discord message                                                                             ] ██
# | ██ [ usage:                                                                                                ] ██
# % ██ [ - run delete_discord_message_api def:channel_id|message_id(|reason)                                   ] ██
# - ██ [ - run delete_discord_message_api def:<[channel_id]>|<[message_id]>                                    ] ██
# - ██ [ - run delete_discord_message_api def:<list[<[channel_id]>|<[message_id]>].include_single[<[reason]>]> ] ██
discord_delete_message_api:
  type: task
  debug: false
  definitions: channel_id|message_id|reason
  script:
    # % ██ [ create headers          ] ██
    - definemap headers:
        Authorization: <secret[cbot]>
        Content-Type: application/json
        User-Agent: b
    - define headers.X-Audit-Log-Reason.reason <[reason]> if:<[reason].exists>

    # % ██ [ send the delete request ] ██
    - ~webget https://discord.com/api/channels/<[channel_id]>/messages/<[message_id]> method:delete headers:<[headers]> save:response

# | ██ [ Deletes two to one hundred discord message by ID at once                                                                          ] ██
# | ██ [ usage:                                                                                                                            ] ██
# % ██ [ - run delete_discord_message_api def:channel_id|message_ids(|reason)                                                              ] ██
# - ██ [ run delete_discord_bulk_messages_api def:<list_single[<[channel_id]>].include_single[<[message_ids]>]>                            ] ██
# - ██ [ run delete_discord_bulk_messages_api def:<list_single[<[channel_id]>].include_single[<[message_ids]>].include_single[<[reason]>]> ] ██
discord_delete_bulk_messages_api:
  type: task
  debug: false
  definitions: channel_id|message_ids|reason
  script:
    # % ██ [ create headers            ] ██
    - definemap headers:
        Authorization: <secret[cbot]>
        Content-Type: application/json
        User-Agent: b
    - define headers.X-Audit-Log-Reason.reason <[reason]> if:<[reason].exists>

    # % ██ [ construct the message IDs ] ██
    - define data.messages <[message_ids]>

    # % ██ [ send the delete request   ] ██
    - ~webget https://discord.com/api/channels/<[channel_id]>/messages/bulk-delete data:<[data].to_json> method:post headers:<[headers]> save:response
