advancement_handler:
  type: world
  debug: false
  events:
    #on player granted advancement criterion:
    #  - announce <context.advancement.on_click[<context.advancement>].type[copy_to_clipboard]> to_ops

    on player granted advancement criterion advancement:end/enter_end_gateway|story/enter_the_end:
      - determine cancelled
