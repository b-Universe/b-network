endermite_handler:
  type: world
  debug: false
  events:
    on enderman targets endermite:
      - determine cancelled

    after player damaged by endermite chance:75:
      - adjust <player> no_damage_duration:1t
