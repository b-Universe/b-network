discord_move_user_api:
  type: task
  definitions: user_id|channel_id|reason
  # Channel ID is id of channel to move user to (if they are connected to voice)
  debug: false
  script:
    # % ██ [ hardcode my guild ID  ] ██
    - define guild_id 901618453356630046 if:!<[guild_id].exists>

    # % ██ [ create headers        ] ██
    - definemap headers:
        Authorization: <secret[cbot]>
        Content-Type: application/json
    - define headers.X-Audit-Log-Reason.reason <[reason]> if:<[reason].exists>

    - definemap data.channel_id <[channel_id]>

    # % ██ [ send the mute request ] ██
    - ~webget https://discord.com/api/guilds/<[guild_id]>/members/<[user_id]> data:<[data].to_json> method:PATCH headers:<[headers]> save:response
