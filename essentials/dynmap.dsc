dynmap_command:
  type: command
  name: dynmap
  debug: false
  usage: /dynmap
  description: Gives you the dynmap link
  script:
    - if !<context.args.is_empty>:
      - inject command_syntax_error

    - narrate <element[<&b><underline>https<&co>//www.behr.dev/dynmap].on_click[http://68.51.84.156:8123].type[open_url]>
