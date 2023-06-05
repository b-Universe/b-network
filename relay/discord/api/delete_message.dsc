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
    # % ██ [ Create headers          ] ██
    - define headers <script[bdata].parsed_key[api.Discord.headers]>
    - define headers.X-Audit-Log-Reason.reason <[reason]> if:<[reason].exists>

    # % ██ [ Check for mass delete   ] ██
    - flag server behr.discord.marked_for_delete:->:<[message_id]> expire:10t
    - wait 10t
    - if <server.has_flag[behr.discord.marked_for_delete]>:
      - define message_ids <server.flag[behr.discord.marked_for_delete]>
      - if <[reason].exists>:
        - run discord_delete_bulk_messages_api def:<list_single[<[channel_id]>].include_single[<[message_ids]>]>
      - else:
        - run discord_delete_bulk_messages_api def:<list_single[<[channel_id]>].include_single[<[message_ids]>].include_single[<[reason]>]>
    - flag server behr.discord.marked_for_delete:!

    # % ██ [ Send the delete request ] ██
    - ~webget <script[bdata].parsed_key[api.Discord.endpoint]>/channels/<[channel_id]>/messages/<[message_id]> method:delete headers:<[headers]> save:response

# | ██ [ Deletes two to one hundred discord message by ID at once                                                                          ] ██
# | ██ [ Enable flag `behr.discord.settings.mass_deletion_enabled` to bypass 100 message delete limit                                      ] ██
# | ██ [ usage:                                                                                                                            ] ██
# % ██ [ - run delete_discord_message_api def:channel_id|message_ids(|reason)                                                              ] ██
# - ██ [ run discord_delete_bulk_messages_api def:<list_single[<[channel_id]>].include_single[<[message_ids]>]>                            ] ██
# - ██ [ run discord_delete_bulk_messages_api def:<list_single[<[channel_id]>].include_single[<[message_ids]>].include_single[<[reason]>]> ] ██
discord_delete_bulk_messages_api:
  type: task
  debug: false
  definitions: channel_id|message_ids|reason|mass_enabled
  script:
    # % ██ [ Create headers            ] ██
    - define headers <script[bdata].parsed_key[api.Discord.headers]>
    - define headers.X-Audit-Log-Reason.reason <[reason]> if:<[reason].exists>

    # % ██ [ Construct the message IDs ] ██
    - define data.messages <[message_ids]>

    # % ██ [ Verify valid request      ] ██
    - if <[message_ids].size> < 2:
      - if <[reason].exists>:
        - run discord_delete_message_api def:<list[<[channel_id]>|<[message_ids].first>].include_single[<[reason]>]>
      - else:
        - run discord_delete_message_api def:<[channel_id]>|<[message_ids].first>
      - stop

    # % ██ [ Mass delete if enabled    ] ██
    - else if <[message_ids].size> > 100:
      - if !<[mass_enabled].exists> && <server.has_flag[behr.discord.settings.mass_deletion_enabled]>:
        - repeat <[message_ids].size.div[100].round_up> as:loop_index:
          - if <[reason].is_truthy>:
            - run discord_delete_bulk_messages_api def:<list_single[<[channel_id]>].include_single[<[message_ids]>].include_single[<[reason]>].include_single[true]>
          - else:
            - run discord_delete_bulk_messages_api def:<list_single[<[channel_id]>].include_single[<[message_ids]>].include_single[true]>
          - wait 5s

      - else:
        - announce to_console "<&4>Warning<&6><&co> <&c>Cannot exceed 100 messages to bulk delete, defaulting to first 100. Enable the setting flag `behr.discord.settings.mass_deletion_enabled` to bypass."
      - define message_ids <[message_ids].get[1].to[100]>

    # % ██ [ Send the delete request   ] ██
    - ~webget <script[bdata].parsed_key[api.Discord.endpoint]>/channels/<[channel_id]>/messages/bulk-delete data:<[data].to_json> method:post headers:<[headers]> save:response
    - inject web_debug.webget_response
