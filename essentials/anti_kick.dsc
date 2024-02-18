kick_handler:
  type: world
  debug: false
  events:
    on player kicked flagged:!behr.essentials.kickable:
      - determine cancelled
    #on projectile hits entity:skeleton:
    #  - determine cancelled
