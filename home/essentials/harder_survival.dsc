harder_essentials_handler:
  type: world
  debug: false
  data:
    dyes:
    - red
    - orange
    - yellow
    - lime
    - green
    - light_blue
    - blue
    - cyan
    - magenta
    - pink
    - purple
    - white
    - light_gray
    - gray
    - black
    - brown
  events:
    after zombie dies:
      - if <util.random_chance[10]> && <context.entity.age> == adult:
        - spawn zombie[age=baby]|zombie[age=baby]|zombie[age=baby]

    after phantom spawns:
      - if <util.random_chance[20]>:
        - mount skeleton|<context.entity> save:entities
        # apply potion effects
        # - define skeleton <entry[entities].mounted_entities.first>

    after hoglin spawns:
      - if <util.random_chance[10]>:
        - if <context.entity.age> == adult
          - if <util.random_chance[20]>:
            - mount hoglin_brute|<context.entity> save:entities
          - else:
            - mount hoglin|<context.entity> save:entities
        - else if <util.random_chance[5]>:
          - mount hoglin[age=baby]|<context.entity> save:entities

    on shulker spawns:
      - determine shulker[color=<script.data_key[data.dyes].random>]

    on slime splits:
      - announce to_console "count<&co> <context.count>"
