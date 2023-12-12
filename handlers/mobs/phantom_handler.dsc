phantom_hndler:
  type: world
  debug: false
  events:
    on phantom dies:
      - if <util.random_chance[25]>:
        - define extra_drops bone[<util.random.int[1].to[5].div[3].round>]
      - else:
        - define extra_drops bone_meal[<util.random.int[1].to[5].div[3].round>]

      - determine <context.drops.include[<[extra_drops]>]>

    after phantom spawns chance:20:
      - if <util.random_chance[10]>:
        - mount wither_skeleton[item_in_hand=bow]|<context.entity>
        - adjust <context.entity> size:4
      - else:
        - mount skeleton|<context.entity>

    #after phantom targets player:
    #  - wait 5t
    #  - push <context.entity> origin:<context.entity.location> destination:<player.eye_location> speed:<util.random.decimal[0.6].to[1.1]>

    on player damaged by phantom chance:100 flagged:!behr.essentials.phantom_kidnapped:
      - flag <player> behr.essentials.phantom_kidnapped expire:5s
      - mount <player>|<context.damager>
      - wait <util.random.int[3].to[5]>s
      - flag <player> behr.essentials.phantom_kidnapped:!
      - mount cancel <player>

    on player flagged:behr.essentials.phantom_kidnapped exits vehicle:
        - determine cancelled
