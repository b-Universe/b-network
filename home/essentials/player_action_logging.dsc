player_action_logging:
  type: world
  debug: false
  events:
    on player places block:
      - define time <util.time_now>
      - definemap data:
          player: <player>
          old_material: <context.old_material>
          new_material: <context.location.material>
          time: <[time]>

      - flag <context.location> behr.essentials.action_data.<[time].epoch_millis>:<[data]>
