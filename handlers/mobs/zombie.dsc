zombie_handler:
  type: world
  debug: false
  events:
    on zombie spawns:
      - define chance <util.random.int[1].to[100]>
      - choose <[chance]>:
        - case 1:
          - equip <context.entity> head:zombie_head_steve_mask
        - case 2:
          - equip <context.entity> head:custom_zombie_01_helmet chest:custom_zombie_01_top boots:custom_zombie_01_bottom
        - case 3:
          - equip <context.entity> head:custom_zombie_02_helmet chest:custom_zombie_02_top boots:custom_zombie_02_bottom
        - case 4:
          - equip <context.entity> head:zombie_dress_helmet chest:zombie_dress_top boots:zombie_dress_bottom

zombie_head_steve_mask:
  type: item
  debug: false
  material: player_head
  mechanisms:
    skull_skin: 66b6004f-4998-4c13-8b85-e734ec258d76|ewogICJ0aW1lc3RhbXAiIDogMTYxODg5NDE0ODg4MCwKICAicHJvZmlsZUlkIiA6ICI1ZWE0ODg2NTg2OWI0Y2ZhOWRjNTg5YmFlZWQwNzM5MCIsCiAgInByb2ZpbGVOYW1lIiA6ICJfUllOMF8iLAogICJzaWduYXR1cmVSZXF1aXJlZCIgOiB0cnVlLAogICJ0ZXh0dXJlcyIgOiB7CiAgICAiU0tJTiIgOiB7CiAgICAgICJ1cmwiIDogImh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvOTIzYTY4NThhZWZmODk4MmE2MjUzYWZkYTEwOTljNjI3N2Y1NmRhMTljZGJkNmUxMzA5NzcxNjU3NzgxYmQ1MCIKICAgIH0KICB9Cn0=|

custom_zombie_01_helmet:
  type: item
  debug: false
  material: player_head
  mechanisms:
    skull_skin: 65b6004f-4998-4c13-8b85-e734ec258d76|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvNWExMjEwNWQ5N2MzNGUwMWFjNGJjYWMyN2IzNzdiY2E5MGU4OTQxNDg0MDM1MjgzYTZlNGE5MzEwZWFjZGI4ZCJ9fX0=|b

custom_zombie_01_top:
  type: item
  debug: false
  material: chainmail_chestplate
  mechanisms:
    trim:
      material: diamond
      pattern: custom_armor:custom_zombie_01

custom_zombie_01_bottom:
  type: item
  debug: false
  material: chainmail_boots
  mechanisms:
    trim:
      material: diamond
      pattern: custom_armor:custom_zombie_01

custom_zombie_02_helmet:
  type: item
  debug: false
  material: player_head
  mechanisms:
    skull_skin: 996f84ea-9efa-4933-a17e-f80763148ee2|ewogICJ0aW1lc3RhbXAiIDogMTcwODI4NDMwMTYwNiwKICAicHJvZmlsZUlkIiA6ICIzZTY1NWNiNGJiYTY0ZWE5YTdmZTBmNDYzMGVjNzhiNyIsCiAgInByb2ZpbGVOYW1lIiA6ICJTYWdoemlmeSIsCiAgInNpZ25hdHVyZVJlcXVpcmVkIiA6IHRydWUsCiAgInRleHR1cmVzIiA6IHsKICAgICJTS0lOIiA6IHsKICAgICAgInVybCIgOiAiaHR0cDovL3RleHR1cmVzLm1pbmVjcmFmdC5uZXQvdGV4dHVyZS8zMjBmYmYzZmNjNDVlNzk1N2NkZDQyZDFhODJjNDI5NDhmZmU2NzRlOGU4ZDcwZGM5NTZjNmMzMzlhNmI5Yzk4IgogICAgfQogIH0KfQ==|

custom_zombie_02_top:
  type: item
  debug: false
  material: chainmail_chestplate
  mechanisms:
    trim:
      material: diamond
      pattern: custom_armor:custom_zombie_02

custom_zombie_02_bottom:
  type: item
  debug: false
  material: chainmail_boots
  mechanisms:
    trim:
      material: diamond
      pattern: custom_armor:custom_zombie_02

zombie_dress_helmet:
  type: item
  debug: false
  material: player_head
  mechanisms:
    skull_skin: 7c04d663-bf12-4fe8-b28c-7d86e8dd8256|ewogICJ0aW1lc3RhbXAiIDogMTcxMDY3NTAyMTA2NSwKICAicHJvZmlsZUlkIiA6ICIzZmE5ODRmZDI2NGY0MjU3ODU4ODY3YjM5MzgxZjU0NiIsCiAgInByb2ZpbGVOYW1lIiA6ICJZVFJpbWFudGFzIiwKICAic2lnbmF0dXJlUmVxdWlyZWQiIDogdHJ1ZSwKICAidGV4dHVyZXMiIDogewogICAgIlNLSU4iIDogewogICAgICAidXJsIiA6ICJodHRwOi8vdGV4dHVyZXMubWluZWNyYWZ0Lm5ldC90ZXh0dXJlL2JiNGY5YmQzOGIxNzdkYjkxZGE5NDYzMWUzNDhjYWFiOTc4NTNhMjU4MTY2Y2Q3MDg2NzgxZTViZDE1ZGMxODIiCiAgICB9CiAgfQp9|

zombie_dress_top:
  type: item
  debug: false
  material: chainmail_chestplate
  mechanisms:
    trim:
      material: diamond
      pattern: custom_armor:zombie_dress

zombie_dress_bottom:
  type: item
  debug: false
  material: chainmail_boots
  mechanisms:
    trim:
      material: diamond
      pattern: custom_armor:zombie_dress
