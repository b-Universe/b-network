discord_remove_user_role:
  type: task
  debug: false
  definitions: user_id|guild_id|role_id|reason
  script:
    # % ██ [ hardcode my guild ID ] ██
    - define guild_id 626078288556851230 if:!<[guild_id].exists>

    # % ██ [ create headers       ] ██
    - definemap headers:
        Authorization: <secret[bbot]>
        Content-Type: application/json
        User-Agent: b
    - define headers.X-Audit-Log-Reason.reason <[reason]> if:<[reason].exists>

    - ~webget method:GET https://discord.com/api/guilds/guilds/<[guild_id]>/roles headers:<[headers]> save:response
    - if <entry[response].failed>:
      - narrate "<&c>Failed to get list of guild role IDs"
      - stop

    - define role_ids <util.parse_yaml[{<&dq>data<&dq><&co><entry[response].result>}].get[data].parse[get[id]]>
    - if <[role_id]> !in <[role_ids]>:
      - narrate "<&c>Role ID <&e><[role_id]> <&c>is an invalid role available"
      - stop

    # % ██ [ send the ban request ] ██
    - ~webget https://discord.com/api/guilds/<[guild_id]>/members/<[user_id]>/roles/<[role_id]> method:DELETE headers:<[headers]>
