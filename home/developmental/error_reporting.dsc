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
      - define context.message <context.message>
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

      - bungeerun server:relay error_report def:<[context]>
      
error_report:
  type: task
  definitions: context
  script:
    # % ██ [ define base definitions             ] ██
    - define development_guild <discord_group[a_bot,631199819817549825]>
    - define embed <discord_embed>
    - definemap embed_data:
        title: __`<&lb>Click for log<&rb>`__ | `<&lb><[context.server]><&rb>` | Error response<&co>
        color: <color[255,255,0]>
