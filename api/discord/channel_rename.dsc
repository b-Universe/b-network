discord_api_channel_rename:
  type: task
  definitions: channel_id|new_name|reason
  script:
    # % ██ [ create headers                  ] ██
    - definemap headers:
        Authorization: <secret[bbot]>
        Content-Type: application/json
        User-Agent: B
    - define headers.X-Audit-Log-Reason.reason <[reason]> if:<[reason].exists>

    # % ██ [ set the new name data           ] ██
    - define data.name <[new_name]>

    # % ██ [ send the channel rename request ] ██
    - define url https://discord.com/api/channels/<[channel_id]>
    - ~webget <[url]> headers:<[headers]> data:<[data].to_json> method:patch save:response
