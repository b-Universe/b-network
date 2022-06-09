text_width_command:
  type: command
  name: text_width
  debug: false
  description: Checks the text width of a message
  usage: /text_width
  permission: behr.essentials.text_width
  script:
  # % ██ [ check arguments ] ██
    - if <context.args.is_empty>:
      - narrate "<&c>Invalid usage - /text_width"
      - stop

  # % ██ [ count and parse ] ██
    - define text <context.raw_args>
    - narrate "<&e>Text<&co> <&a><[text]><n><&e>Length<&co> <&a><[text].text_width>"
