discord_get_channel_webhooks:
  type: task
  debug: false
  definitions: channel_id
  script:
    - define url https<&co>//discord.com/api/channels/<[channel_id]>/webhooks

    - definemap headers:
        Authorization: <secret[bbot]>
        Content-Type: application/json
        User-Agent: b

    - ~webget <[url]> headers:<[headers]> save:response
    - inject web_debug.webget_response if:<server.has_flag[behr.developmental.debug_mode]>

    - define response <map.with[data].as[<entry[response].result.if_null[null]>].to_yaml.get[data].if_null[null]>
    - if <entry[response].failed> || !<[response].is_truthy>:
      - stop

    - if !<[response].is_empty>:
      - define token <[response].first.get[token]>
      - define webhook_url https<&co>//discord.com/api/webhooks/<[channel_id]>/<[token]>

discord_get_guild_webhooks:
  type: task
  debug: false
  definitions: guild_id
  script:
    - define url https<&co>//discord.com/api/guilds/<[guild_id]>/webhooks

    - definemap headers:
        Authorization: <secret[bbot]>
        Content-Type: application/json
        User-Agent: b

    - ~webget <[url]> headers:<[headers]> save:response
    - inject web_debug.webget_response if:<server.has_flag[behr.developmental.debug_mode]>

    - define guild_webhooks <map.with[data].as[<entry[response].result.if_null[null]>].to_yaml.get[data].if_null[null]>
    - if <entry[guild_webhooks].failed> || !<[guild_webhooks].is_truthy> || <[guild_webhooks].is_empty>:
      - stop

discord_get_webhook:
  type: task
  debug: false
  definitions: webhook_id
  script:
    - define url https<&co>//discord.com/api/webhooks/<[webhook_id]>

    - definemap headers:
        Authorization: <secret[bbot]>
        Content-Type: application/json
        User-Agent: b

    - ~webget <[url]> headers:<[headers]> save:response
    - inject web_debug.webget_response if:<server.has_flag[behr.developmental.debug_mode]>

    - define response <entry[response].result.to_yaml.if_null[null]>
    - if <entry[response].failed> || !<[response].is_truthy>:
      - stop

webhook_object_example:
  type: data
  data:
    channel_id: <[channel_id]>
    guild_id: <[guild_id]>
    id: <[id]>
    name: Captain Hook
    type: 1
    user:
      id: <[author].id>
      username: hydra_melody
      avatar: 3746ce5fdd5eb27daf94f13eea03f055
      discriminator: 0
      public_flags: 4194304
      flags: 4194304
      accent_color: null
      global_name: Hydra
      banner_color:
    token: <[webhook_token]>
    url: https://discord.com/api/webhooks/<[channel_id]>/<[webhook_token]>
