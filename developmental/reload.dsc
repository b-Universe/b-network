reload_command:
  type: command
  debug: false
  name: /r
  usage: //r
  description: Reloads Denizen scripts
  script:
    - reload

    - if !<server.has_flag[behr.developmental.debug_mode]>:
      - stop

    - define scripts <util.scripts>
    - definemap message:
        text: <&[green]>Scripts reloaded
        hover:
          - <&[green]>Reloaded successfully
          - <&[yellow]>Script types (<&[green]><[scripts].size><&[yellow]>)<&co>
          - <[scripts].parse_tag[<[parse_value].data_key[type]>].deduplicate.parse_tag[  <&[yellow]><[parse_value].to_titlecase><&co> <&[green]><util.scripts.filter[container_type.equals[<[parse_value]>]].size>].separated_by[<n>]>

    - narrate <[message.text].on_hover[<[message.hover].separated_by[<n>]>]>
