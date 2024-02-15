restart_command:
  type: command
  name: restart
  usage: /restart ((delay) (rate)/instant)/cancel
  description: Restarts the server
  script:
    - if <context.server>:
      - adjust server restart
      - stop

    - if <context.args.first.if_null[invalid]> != cancel:
      - run restart_task def:<context.args>

    - else:
      - flag server behr.essentials.restart_queue:!

restart_handler:
  type: world
  events:
    on system time hourly every:40:
      - run restart_task def:60s|5t

    on restart command:
      - determine fulfilled passively if:<context.source_type.equals[server]>
      - run restart_task def:<context.args>

    after server start:
      - flag server behr.essentials.restart_queue:!

restart_task:
  type: task
  debug: false
  definitions: initial_duration|rate
  script:
    - if <[initial_duration].if_null[null].is_truthy>:
      - if <[initial_duration]> == instant:
        - define initial_duration <duration[1t]>
      - else:
        - define duration_input <[initial_duration]>
        - inject verify_duration
        - define initial_duration <duration[<[duration]>]>
    - else:
      - define initial_duration <duration[10s]>

    - if <[rate].is_truthy>:
      - define rate <duration[<[rate]>]>
    - else:
      - define rate <duration[5t]>

    - announce "<&a>Server restart in <[initial_duration].formatted_words>"
    - playsound <server.online_players> entity_player_levelup pitch:<util.random.int[8].to[12].div[10]> volume:0.3
    - bossbar players:<server.online_players> id:restart create color:red
    - flag server behr.essentials.restart_queue

    - repeat <[initial_duration].in_ticks.div[<[rate].in_ticks>].sub[1]> as:loop_index:
      - define duration <[initial_duration].sub[<duration[<[rate].in_ticks.mul[<[loop_index]>]>t]>]>
      - bossbar players:<server.online_players> id:restart update "title:<&a>Server restart in <[duration].formatted_words>" progress:<[duration].in_ticks.div[<[initial_duration].in_ticks>]>
      - wait <[rate]>
      - if !<server.has_flag[behr.essentials.restart_queue]>:
        - announce "<&a>Restart cancelled"
        - bossbar players:<server.online_players> id:restart remove
        - stop

    - playsound <server.online_players> entity_player_levelup pitch:<util.random.int[8].to[12].div[10]> volume:0.3
    - bossbar players:<server.online_players> id:restart update title:Restarting...
    - wait 2s
    - bossbar id:restart remove
    - adjust server restart
