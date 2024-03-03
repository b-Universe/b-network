discord_mute_user_api:
  type: task
  definitions: user_id|toggle|reason
  debug: false
  script:
    # % ██ [ hardcode my guild ID  ] ██
    - define guild_id 901618453356630046 if:!<[guild_id].exists>

    # % ██ [ create headers        ] ██
    - definemap headers:
        Authorization: <secret[cbot]>
        Content-Type: application/json
    - define headers.X-Audit-Log-Reason.reason <[reason]> if:<[reason].exists>

    - definemap data.mute <[toggle].if_null[true]>

    # % ██ [ send the timeout request ] ██
    - ~webget https://discord.com/api/guilds/<[guild_id]>/members/<[user_id]> data:<[data].to_json> method:PATCH headers:<[headers]> save:response

discord_deafen_user_api:
  type: task
  definitions: user_id|toggle|reason
  debug: false
  script:
    # % ██ [ hardcode my guild ID  ] ██
    - define guild_id 901618453356630046 if:!<[guild_id].exists>

    # % ██ [ create headers        ] ██
    - definemap headers:
        Authorization: <secret[cbot]>
        Content-Type: application/json
    - define headers.X-Audit-Log-Reason.reason <[reason]> if:<[reason].exists>

    - definemap data.deaf <[toggle].if_null[true]>

    # % ██ [ send the timeout request ] ██
    - ~webget https://discord.com/api/guilds/<[guild_id]>/members/<[user_id]> data:<[data].to_json> method:PATCH headers:<[headers]> save:response
