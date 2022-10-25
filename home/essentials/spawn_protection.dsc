spawn_protections:
  type: world
  debug: false
  events:
    on slime|bat|zombie|skeleton|enderman spawns in:spawn:
      - determine cancelled
    on player breaks block in:spawn:
      - if !<player.has_flag[test]>:
        - determine cancelled
    on player breaks hanging in:spawn:
      - if !<player.has_flag[test]>:
        - determine cancelled
    on player places hanging in:spawn:
      - if !<player.has_flag[test]>:
        - determine cancelled
    on player places block in:spawn:
      - if !<player.has_flag[test]>:
        - determine cancelled
    on player right clicks *item_frame in:spawn:
      - if !<player.has_flag[test]>:
        - determine cancelled
    on player right clicks *door|lever|*_button|*_pressure_plate|anvil|*campfire in:spawn:
      - if !<player.has_flag[test]>:
        - determine cancelled
    on player right clicks block with:flint_and_steel|fire_charge in:spawn:
      - if !<player.has_flag[test]>:
        - determine cancelled
    on player damaged by player in:spawn:
      - if !<player.has_flag[test]>:
        - determine cancelled
    on player opens inventory in:spawn:
      - if !<player.has_flag[test]>:
        - determine cancelled
    on *item_frame damaged by player in:spawn:
        - determine cancelled
    on player teleports cause:CHORUS_FRUIT|ENDER_PEARL:
      - if !<player.has_flag[test]>:
        - determine cancelled
    on player right clicks block with:*boat|*minecart in:spawn:
      - if !<player.has_flag[test]>:
        - determine cancelled
    on block burns in:spawn:
        - determine cancelled
    on block fades in:spawn:
        - determine cancelled
    on block grows in:spawn:
        - determine cancelled
    on block spreads type:vine|*mushroom in:spawn:
        - determine cancelled
    on block spreads type:!vine|*mushroom in:spawn:
        - determine cancelled
    on block ignites in:spawn:
        - determine cancelled
    on block destroyed by explosion in:spawn:
      - if !<player.has_flag[test]>:
        - determine cancelled
    on entity explodes in:spawn:
      - if !<player.has_flag[test].if_null[true]>:
        - determine cancelled
    on block dispenses *minecart|*boat in:spawn:
      - determine cancelled
    on entity changes block in:spawn:
      - if !<player.has_flag[test].if_null[true]>:
        - determine cancelled
    on piston extends in:spawn:
        - determine cancelled
    on piston retracts in:spawn:
      - determine cancelled
    on liquid spreads type:lava in:spawn:
      - determine cancelled
    on liquid spreads type:water in:spawn:
      - determine cancelled
