discord_ban_player:
  type: task
  debug: false
  definitions: user_id|guild_id|reason
  script:
    # % ██ [ hardcode my guild ID ] ██
    - define guild_id 626078288556851230 if:!<[guild_id].exists>

    # % ██ [ create headers       ] ██
    - define headers <script[bdata].parsed_key[api.Discord.headers]>
    - define headers.X-Audit-Log-Reason.reason <[reason]> if:<[reason].exists>

    # % ██ [ send the ban request ] ██
    - ~webget <script[bdata].parsed_key[api.Discord.endpoint]>/guilds/<[guild_id]>/bans/<[user_id]> method:PUT headers:<[headers]>
