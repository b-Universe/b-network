discord_set_roles_user_api:
  type: task
  definitions: user_id|role_ids|reason
  debug: false
  script:
    # % ██ [ hardcode my guild ID  ] ██
    - define guild_id 901618453356630046 if:!<[guild_id].exists>

    # % ██ [ create headers        ] ██
    - definemap headers:
        Authorization: <secret[cbot]>
        Content-Type: application/json
    - define headers.X-Audit-Log-Reason.reason <[reason]> if:<[reason].exists>

    - foreach <[role_ids]> as:role_id:
      - if !<[role_id].is_integer>:
        - narrate "<&c>Invalid role ID<&4><&co> <&e><[role_id]>"
        - stop

    - definemap data.roles <[role_ids]>

    # % ██ [ send the timeout request ] ██
    - ~webget https://discord.com/api/guilds/<[guild_id]>/members/<[user_id]> data:<[data].to_json> method:PATCH headers:<[headers]> save:response
