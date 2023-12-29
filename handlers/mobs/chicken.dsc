chicken_handler:
  type: world
  debug: false
  events:
    on egg despawns:
      - repeat <context.item.quantity>:
        - spawn chicken[age=baby] if:<util.random_chance[12.5]>
