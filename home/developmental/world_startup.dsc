world_startup:
  type: data
  debug: false
  events:
    after server start:
      #- foreach new_home as:world:
      #  - createworld <[world]>

      #- createworld spawn_save generator:denizen:void

    #on server prestart:
    #  - foreach wwe as:world:
    #    - createworld <[world]> worldtype:FLAT
