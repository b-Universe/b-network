discord_get_guild_roles_api:
  type: task
  debug: false
  definitions: guild_id
  script:
    # % ██ [ hardcode my guild ID    ] ██
    - define guild_id 626078288556851230 if:!<[guild_id].exists>

    # % ██ [ create headers          ] ██
    - definemap headers:
        Authorization: <secret[cbot]>
        Content-Type: application/json
        User-Agent: b

    # % ██ [ send the delete request ] ██
    - ~webget https<&co>//discord.com/api/guilds/<[guild_id]>/roles method:get headers:<[headers]> save:response
    - inject web_debug.webget_response
