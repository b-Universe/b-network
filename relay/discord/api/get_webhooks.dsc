discord_api_get_channel_webhooks:
  type: task
  debug: false
  definitions: channel_id
  script:
    # search channel for webhooks
    # check if webhook doesn't exist
    - define url https<&co>//discord.com/api/channels/<[channel_id]>/webhooks
    - ~webget <[url]> method:get save:response
    - inject web_debug.webget_response if:<server.has_flag[behr.debugging]>

    - if <entry[response].failed>:
      - announce to_console "Webget failed. Tried URL: <[url]>"
      - stop
