get_all_threads_ids:
  type: task
  debug: false
  definitions: guild_id|channel_id
  script:
    - inject get_channel_active_threads.sub_paths.ids
    - inject get_archived_threads.sub_paths.ids
    - define threads <[active_thread_ids].include[<[archived_thread_ids]>]>

get_all_active_threads:
  type: task
  debug: false
  definitions: guild_id
  sub_paths:
    ids:
      - inject get_all_active_threads
      - define active_thread_ids <[active_threads].parse[get[id]]>
  script:
    - define url https://discord.com/api/guilds/<[guild_id]>/threads/active

    - definemap headers:
        Authorization: <secret[cbot]>
        Content-Type: application/json
        User-Agent: B

    - ~webget <[url]> headers:<[headers]> save:response
    - define active_threads <util.parse_yaml[<entry[response].result>].get[threads]>

get_channel_active_threads:
  type: task
  debug: false
  definitions: guild_id|channel_id
  sub_paths:
    ids:
      - inject get_channel_active_threads
      - define active_thread_ids <[active_threads].parse[get[id]]>
  script:
    - inject get_all_active_threads
    - define active_threads <[active_threads].filter[get[parent_id].equals[<[channel_id]>]]>

get_archived_threads:
  type: task
  debug: false
  definitions: channel_id
  sub_paths:
    ids:
      - inject get_archived_threads
      - define archived_thread_ids <[archived_threads].parse[get[id]]>
  script:
    - define url https://discord.com/api/channels/<[channel_id]>/threads/archived/public
    - definemap headers:
        Authorization: <secret[cbot]>
        Content-Type: application/json
        User-Agent: B

    - ~webget <[url]> headers:<[headers]> save:response
    - define archived_threads <util.parse_yaml[<entry[response].result>].get[threads]>
