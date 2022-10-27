# harder events
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
        - if <context.entity.age> == adult:
          - if <util.random_chance[20]>:
            - mount hoglin_brute|<context.entity> save:entities
          - else:
            - mount hoglin|<context.entity> save:entities
        - else if <util.random_chance[5]>:
          - mount hoglin[age=baby]|<context.entity> save:entities

    after shulker spawns:
      - adjust <context.entity> color:<script.data_key[data.dyes].random>

    on slime dies:
      - if <context.entity.fire_time.in_ticks> > 0:
        - flag <context.entity> on_fire
        - flag <context.entity> death_location:<context.entity.location>

    on slime splits:
      - if !<context.entity.has_flag[death_location]>:
      #- if <context.entity.fire_time.in_ticks> == 0:
        - determine <context.count.mul[<util.random.decimal[1.8].to[3].round_up>]>

      - else:
        - spawn <context.entity.flag[death_location]> <entity[magma_cube[size=<context.entity.size.sub[2].max[1]>]].repeat_as_list[<util.random.decimal[0.8].to[2].round_up>]>
        - determine <context.count.mul[<util.random.decimal[0.9].to[1.6].round_up>]>


# harder items

diamond_nugget:
  type: item
  debug: false
  material: iron_nugget
  display name: <&f>Diamond Nugget
  mechanisms:
    quantity: 9
    # todo: correct custom model data here                                      
    custom_model_data: 1
  recipes:
    1:
      type: shapeless
      input: diamond

diamond_ingot:
  type: item
  debug: false
  material: iron_ingot
  display name: <&f>Diamond Ingot
  mechanisms:
    # todo: correct custom model data here                                      
    custom_model_data: 1
  recipes:
    1:
      type: shaped
      input:
        - diamond|diamond|diamond
        - diamond|diamond|diamond
        - diamond|diamond|diamond

reverse_diamond_block:
  type: item
  debug: false
  material: iron_ingot
  display name: <&f>Diamond Ingot
  mechanisms:
    # todo: correct custom model data here                                      
    custom_model_data: 1
    quantity: 9
  recipes:
    2:
      type: shapeless
      input: diamond_block

new_diamond_block:
  type: item
  debug: false
  material: diamond_block
  no_id: true
  recipes:
    1:
      type: shaped
      input:
        - diamond_ingot|diamond_ingot|diamond_ingot
        - diamond_ingot|diamond_ingot|diamond_ingot
        - diamond_ingot|diamond_ingot|diamond_ingot

emerald_nugget:
  type: item
  debug: false
  material: iron_nugget
  display name: <&f>Emerald Nugget
  mechanisms:
    quantity: 9
    # todo: correct custom model data here                                      
    custom_model_data: 1
  recipes:
    1:
      type: shapeless
      input: emerald

emerald_ingot:
  type: item
  debug: false
  material: iron_ingot
  display name: <&f>Emerald Ingot
  mechanisms:
    # todo: correct custom model data here                                      
    custom_model_data: 1
  recipes:
    1:
      type: shaped
      input:
        - emerald|emerald|emerald
        - emerald|emerald|emerald
        - emerald|emerald|emerald

reverse_emerald_block:
  type: item
  debug: false
  material: iron_ingot
  display name: <&f>Emerald Ingot
  mechanisms:
    # todo: correct custom model data here                                      
    custom_model_data: 1
    quantity: 9
  recipes:
    1:
      type: shapeless
      input: emerald_block

new_emerald_block:
  type: item
  debug: false
  material: emerald_block
  no_id: true
  recipes:
    1:
      type: shaped
      input:
        - emerald_ingot|emerald_ingot|emerald_ingot
        - emerald_ingot|emerald_ingot|emerald_ingot
        - emerald_ingot|emerald_ingot|emerald_ingot

redstone_ingot:
  type: item
  debug: false
  material: iron_ingot
  display name: <&f>Redstone Ingot
  mechanisms:
    # todo: correct custom model data here                                      
    custom_model_data: 1
  recipes:
    1:
      type: shaped
      input:
        - redstone|redstone|redstone
        - redstone|redstone|redstone
        - redstone|redstone|redstone

reverse_redstone_block:
  type: item
  debug: false
  material: iron_ingot
  display name: <&f>Redstone Ingot
  mechanisms:
    # todo: correct custom model data here                                      
    custom_model_data: 1
    quantity: 9
  recipes:
    1:
      type: shapeless
      input: redstone_block


new_redstone_block:
  type: item
  debug: false
  material: redstone_block
  no_id: true
  recipes:
    1:
      type: shaped
      input:
        - redstone_ingot|redstone_ingot|redstone_ingot
        - redstone_ingot|redstone_ingot|redstone_ingot
        - redstone_ingot|redstone_ingot|redstone_ingot

lapis_lazuli_ingot:
  type: item
  debug: false
  material: iron_ingot
  display name: <&f>Lapis Lazuli Ingot
  mechanisms:
    # todo: correct custom model data here                                      
    custom_model_data: 1
  recipes:
    1:
      type: shaped
      input:
        - lapis_lazuli|lapis_lazuli|lapis_lazuli
        - lapis_lazuli|lapis_lazuli|lapis_lazuli
        - lapis_lazuli|lapis_lazuli|lapis_lazuli

reverse_lapis_lazuli_block:
  type: item
  debug: false
  material: iron_ingot
  display name: <&f>Lapis Lazuli Ingot
  mechanisms:
    # todo: correct custom model data here                                      
    custom_model_data: 1
    quantity: 9
  recipes:
    1:
      type: shapepless
      input: lapis_block

new_lapis_lazuli_block:
  type: item
  debug: false
  material: lapis_block
  no_id: true
  recipes:
    1:
      type: shaped
      input:
        - lapis_lazuli_ingot|lapis_lazuli_ingot|lapis_lazuli_ingot
        - lapis_lazuli_ingot|lapis_lazuli_ingot|lapis_lazuli_ingot
        - lapis_lazuli_ingot|lapis_lazuli_ingot|lapis_lazuli_ingot
