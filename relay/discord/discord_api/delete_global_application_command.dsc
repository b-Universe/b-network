discord_delete_global_application_command_api:
  type: task
  debug: false
  definitions: application_id|command_id|guild_id
  script:
    # % ██ [ hardcode my guild ID    ] ██
    - define guild_id 626078288556851230 if:!<[guild_id].exists>

    # % ██ [ create headers          ] ██
    - define headers <script[bdata].parsed_key[api.Discord.headers]>

    # % ██ [ send the delete request ] ██
    - ~webget <script[bdata].parsed_key[api.Discord.endpoint]>/applications/<[application_id]>/commands/<[command_id]> method:delete headers:<[headers]> save:response
    - inject web_debug.webget_response
# ex run discord_delete_global_application_command_api def:905309299524382811|1073043734259843122

discord_delete_guild_application_command_api:
  type: task
  debug: false
  definitions: application_id|command_id|guild_id
  script:
    # % ██ [ hardcode my guild ID    ] ██
    - define guild_id 626078288556851230 if:!<[guild_id].exists>

    # % ██ [ create headers          ] ██
    - define headers <script[bdata].parsed_key[api.Discord.headers]>

    # % ██ [ send the delete request ] ██
    - ~webget <script[bdata].parsed_key[api.Discord.endpoint]>/applications/<[application_id]>/guilds/<[guild_id]>/commands/<[command_id]> method:delete headers:<[headers]> save:response
    - inject web_debug.webget_response
# ex run discord_delete_guild_application_command_api def:756231724127748256|1073043734259843122
