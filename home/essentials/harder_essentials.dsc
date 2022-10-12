harder_essentials_handler:
  type: world
  debug: false
  events:
    after zombie dies:
      - if <util.random_chance[10]> && <context.entity.age> == adult:
        - spawn zombie[age=baby]|zombie[age=baby]|zombie[age=baby]

    after phantom spawns:
      - if <util.random_chance[20]>:
        - mount skeleton|<context.entity> save:entities
        - define skeleton <entry[entities].mounted_entities.first>

    on slime splits:
      - announce to_console "count<&co> <context.count>"
