discord_remove_user:
  type: task
  debug: false
  definitions: user_id|guild_id|reason
  script:
    # % ██ [ hardcode my guild ID ] ██
    - define guild_id 626078288556851230 if:!<[guild_id].exists>

    # % ██ [ create headers       ] ██
    - definemap headers:
        Authorization: <secret[bbot]>
        Content-Type: application/json
        User-Agent: b
    - define headers.X-Audit-Log-Reason.reason <[reason]> if:<[reason].exists>

    # % ██ [ send the ban request ] ██
    - ~webget https://discord.com/api/guilds/<[guild_id]>/members/<[user_id]> method:DELETE headers:<[headers]>
