discord_mute_user_api:
  type: task
  definitions: user_id|time|reason
  debug: false
  script:
    # % ██ [ hardcode my guild ID  ] ██
    - define guild_id 901618453356630046 if:!<[guild_id].exists>

    # % ██ [ create headers        ] ██
    - define headers <script[bdata].parsed_key[api.Discord.headers]>
    - define headers.X-Audit-Log-Reason.reason <[reason]> if:<[reason].exists>

    - definemap data.communication_disabled_until <util.time_now.add[<[time]>].format[yyyy-MM-dd'T'HH:mm:ss.s'Z']>

    # % ██ [ send the mute request ] ██
    - ~webget <script[bdata].parsed_key[api.Discord.endpoint]>/guilds/<[guild_id]>/members/<[user_id]> data:<[data].to_json> method:PATCH headers:<[headers]> save:response
