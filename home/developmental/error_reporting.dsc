error_reporting:
  type: world
  events:
  	after script generates error:
      # % ██ [ disable headless queues ] ██
      - define queue <context.queue.if_null[null]>
      - stop if:!<[queue].is_truthy>:

      # % ██ [ disable /ex reporting   ] ██
      - stop if:<[queue].id.starts_with[excommand]>

      # % ██ [ verify enabled          ] ██
      - stop if:!<server.has_flag[behr.essentials.error_reporting]>

      # % ██ [ verify enabled          ] ██
      - define context.time <util.time_now>

      # % ██ [ verify bungee connection ] ██
      - waituntil <bungee.connected> max:1m
      - stop if:!<bungee.connected>

      # % ██ [ collect basic context ] ██
      - define context.server <bungee.server>
      - define context.message <context.message.if_null[invalid]>
      - define context.queue.name <[queue].id>
      - define context.queue.definition_map:<[queue].definition_map> if:!<[queue].definition_map.is_empty.if_null[true]>

      # % ██ [ collect script context ] ██
      - if <context.script.exists>:
        - define context.script.name:<context.script.name.if_null[invalid]>
        - define context.script.line:<context.line.if_null[invalid]>
        - define context.script.file_path:<context.script.filename.if_null[invalid]>

      # % ██ [ collect player context ] ██
      - if <player.exists>:
        - define context.player.uuid:<player.uuid>
        - define context.player.name:<player.name>

      # % ██ [ collect npc context ] ██
      - if <npc.exists>:
        - define context.npc.id:<npc.id>
        - define context.npc.name:<npc.name>

      # % ██ [ track errors ] ██
      - define flag behr.essentials.error_listening.<[queue].id>.<[context.script.name]>
      - flag server behr.essentials.error_listening.<[context.script.name]>:->:<util.time_now> expire:1h
      - flag server <[flag]>.<[context.script.line]>:->:<[context.message]> expire:15s
      - stop if:<server.has_flag[<[flag]>.runtime]>
      - flag server <[flag]>.runtime expire:15s
      - waituntil <[queue].state> != running rate:1s max:3s
      - flag server <[flag]>.runtime:!
      
      # % ██ [ provide ratelimit ] ██
      - define context.rate <server.flag[behr.essentials.error_listening.<[context.script.name]>].size>
      - if <[context.rate]> > 60:
        - define context.rate_limited true
        - flag server behr.essentials.error_listening.ratelimited_scripts.<[context.script.name]>:<[context.time]> expire:5m
        - stop
      
      # % ██ [ submit errors ] ██
      - bungeerun server:relay error_report def:<[context]>
      
error_report:
  type: task
  definitions: context
  script:
    # % ██ [ define base definitions ] ██
    - define guild <discord_group[b,631199819817549825]>
    - define embed <discord_embed>
    - definemap embed_data:
        title: __`<&lb>Click for log<&rb>`__ | `<&lb><[context.server]><&rb>` | Error response<&co>
        color: <color[255,255,0]>
