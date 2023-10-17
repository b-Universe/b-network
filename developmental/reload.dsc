reload_command:
  type: command
  debug: false
  name: /r
  usage: //r
  description: Reloads Denizen scripts
  script:
    - flag server behr.developmental.debug.command.reload.active expire:1s
    - reload

    # ██ [ return any script reload errors if in debug mode ] ██:
    - if <server.has_flag[behr.developmental.debug_mode]>:
      - waituntil <server.has_flag[behr.developmental.debug.command.reload.response]> max:1s
      - if !<server.has_flag[behr.developmental.debug.command.reload.response]>:
        - define scripts <util.scripts>
        - definemap message:
            text: <&a>Scripts reloaded
            hover:
              - <&a>Reloaded successfully
              - <&b>Click to celebrate!
              - <&e>Script types (<&a><[scripts].size><&e>)<&co>
              - <[scripts].parse_tag[<[parse_value].data_key[type]>].deduplicate.parse_tag[  <&e><[parse_value].to_titlecase><&co> <&a><util.scripts.filter[container_type.equals[<[parse_value]>]].size>].separated_by[<n>]>

        - narrate <[message.text].on_hover[<[message.hover].separated_by[<n>]>].on_click[yay]>
        - stop

      - define data <server.flag[behr.developmental.debug.command.reload.response]>
      - define data <[data].filter_tag[<[filter_value].get[value].equals[invalid].not>]>

      - if <context.source_type.if_null[invalid]> != player || <context.server.if_null[false]>:
        - define data <[data].parse_value_tag[<&6><&lt><&e>context<&6>.<&e><[parse_key]><&6><&gt> <&b>| <reset><[parse_value.value]> <&b>| <&3><[parse_value.description]>].values.separated_by[<n>]>
        - announce to_console "<&c>Script reloaded with errors <n><[data]>"

      - else:
        - define data <[data]>
        - definemap message:
            text: <&c>Scripts reloaded with errors
            hover: <&c><&lb><[data.line.value].if_null[X]><&rb> <[data.script.value].if_null[Invalid script]><n><&e>Queue<&co> <&c><[data.queue.value].if_null[/ex]><n><&e>Reload error<&co> <reset><[data.message.value].if_null[Invalid]><n><&b>Click to copy
            hover_old: <&b>Click to copy<&co><n><[data].parse_value_tag[<&6>`<&lt><&e>context<&6>.<&e><[parse_key]><&6><&gt>` <&b>| <reset><[parse_value.value]> <&b>| <&3><[parse_value.description]>].values.separated_by[<n>]>
        - narrate <[message.text].on_hover[<[message.hover]>].on_click[<[message.hover].before_last[<n>].strip_color.replace_text['].with[`]>].type[copy_to_clipboard]>

      - flag server behr.developmental.debug.command.reload:!

reload_handler:
  type: world
  debug: false
  events:
    on console output:
      # ██ [ clear debug spam from debug enabled scripts    ] ██:
      - determine cancelled if:<context.message.substring[9,29].strip_color.starts_with[Static Tag Processing].if_null[false]>

    on script generates error server_flagged:behr.developmental.debug_mode:
      # ██ [ check for //reload errors with debug mode   ] ██:
      - if <server.has_flag[behr.developmental.debug.command.reload.active]>:
        - determine cancelled passively
        - definemap data:
            message:
              value: <context.message.if_null[invalid]>
              description: returns the error message.
            queue:
              value: <context.queue.if_null[invalid]>
              description: returns the queue that caused the error, if any.
            script:
              value: <context.script.if_null[invalid]>
              description: returns the script that caused the error, if any.
            line:
              value: <context.line.if_null[invalid]>
              description: returns the line number within the script file that caused the error, if any.

        - flag server behr.developmental.debug.command.reload.response:<[data]> expire:1s
