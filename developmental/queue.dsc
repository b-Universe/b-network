queue_command:
  type: command
  debug: true
  name: /queue
  usage: //queue <&lt>queue<&gt> STOP
  description: Manages queues
  script:
    - define active_queues <util.queues.exclude[<queue>]>

    - choose <context.args.size>:
      - case 0:
        - if <[active_queues].is_empty>:
          - narrate "<&[yellow]>No active queues"
          - stop

        - foreach <[active_queues]> as:active_queue:
          - definemap click:
              command: /queue <[active_queue].name> stop
              hover: <&a>Click to stop queue
              text: <&[red]><&lb>X<&rb>
          - define button <[click.text].on_hover[<[click.hover]>].on_click[<[click.command]>]>
          - narrate "<[button]> <&[yellow]><[active_queue].name>"

      - case 1:
        - define queue_name <context.args.first>
        - if !<[active_queues].parse[name].contains[<[queue_name]>]>:
          - define reason "<[queue_name]> is not an active queue"
          - inject command_error

        - if <context.args.last> !in clear|stop:
          - inject command_syntax_error

        - queue <[queue_name]> clear

      - default:
        - inject command_syntax_error