space_pickaxe:
  type: item
  debug: false
  material: iron_pickaxe
  display name: <&f>Space Pickaxe

space_pickaxe_handler:
  type: world
  debug: false
  events:
    on player space_pickaxe takes damage:
      - determine cancelled
