discord_delete_global_application_command_api:
  type: task
  debug: false
  definitions: application_id|command_id|guild_id
  script:
    # % ██ [ hardcode my guild ID    ] ██
    - define guild_id 626078288556851230 if:!<[guild_id].exists>

    # % ██ [ create headers          ] ██
    - definemap headers:
        Authorization: <secret[cbot]>
        Content-Type: application/json
        User-Agent: b

    # % ██ [ send the delete request ] ██
    - ~webget https://discord.com/api/applications/<[application_id]>/commands/<[command_id]> method:delete headers:<[headers]> save:response
    - inject web_debug.webget_response

discord_delete_guild_application_command_api:
  type: task
  debug: false
  definitions: application_id|command_id|guild_id
  script:
    # % ██ [ hardcode my guild ID    ] ██
    - define guild_id 626078288556851230 if:!<[guild_id].exists>

    # % ██ [ create headers          ] ██
    - definemap headers:
        Authorization: <secret[cbot]>
        Content-Type: application/json
        User-Agent: b

    # % ██ [ send the delete request ] ██
    - ~webget https://discord.com/api/applications/<[application_id]>/guilds/<[guild_id]>/commands/<[command_id]> method:delete headers:<[headers]> save:response
    - inject web_debug.webget_response
