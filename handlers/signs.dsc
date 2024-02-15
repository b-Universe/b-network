sign_handler:
  type: world
  debug: false
  events:
    on player changes sign:
      - determine <context.new.parse[replace_text[&k].parse_color]>
