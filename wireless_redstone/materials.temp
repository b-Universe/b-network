redstone_crystal:
  type: item
  debug: false
  material: stone
  display name: <&b>Redstone Crystal
  recipes:
    1:
      type: shaped
      input:
        - redstone|amethyst_shard|redstone
        - amethyst_shard|redstone|amethyst_shard
        - redstone|amethyst_shard|redstone

attuned_lever:
  type: item
  debug: false
  material: lever
  display name: <&b>Attuned Lever
  recipes:
    1:
      type: shaped
      input:
        - redstone_crystal|air|redstone_crystal
        - air|lever|air
        - redstone_crystal|air|redstone_crystal
    2:
      type: shaped
      input:
        - air|redstone_crystal|air
        - redstone_crystal|lever|redstone_crystal
        - air|redstone_crystal|air

attuned_observer:
  type: item
  debug: false
  material: observer
  display name: <&b>Attuned Observer
  recipes:
    1:
      type: shaped
      input:
        - redstone_crystal|air|redstone_crystal
        - air|lever|air
        - redstone_crystal|air|redstone_crystal
    2:
      type: shaped
      input:
        - air|redstone_crystal|air
        - redstone_crystal|observer|redstone_crystal
        - air|redstone_crystal|air

wireless_transmitter_block:
  type: item
  debug: false
  material: dispenser
  display name: <&b>Wireless Transmitter
  mechanisms:
    custom_model_data: 1002
  flags:
    wireless_redstone: transmitter
    frequency: 0
  recipes:
    1:
      type: shaped
      input:
        - iron_ingot|quartz|iron_ingot
        - quartz|attuned_lever|quartz
        - iron_ingot|quartz|iron_ingot
    2:
      type: shaped
      input:
        - quartz|iron_ingot|quartz
        - iron_ingot|attuned_lever|iron_ingot
        - quartz|iron_ingot|quartz

wireless_receiver_block:
  type: item
  debug: false
  material: dispenser
  display name: <&b>Wireless Receiver
  mechanisms:
    custom_model_data: 1004
  flags:
    wireless_redstone: receiver
    frequency: 0
  recipes:
    1:
      type: shaped
      input:
        - iron_ingot|quartz|iron_ingot
        - quartz|attuned_observer|quartz
        - iron_ingot|quartz|iron_ingot
    2:
      type: shaped
      input:
        - quartz|iron_ingot|quartz
        - iron_ingot|attuned_observer|iron_ingot
        - quartz|iron_ingot|quartz

wireless_repeater_block:
  type: item
  debug: false
  material: dispenser
  display name: <&b>Wireless Repeater
  mechanisms:
    custom_model_data: 1013
  flags:
    wireless_redstone: repeater
    frequency: 0
  recipes:
    1:
      type: shaped
      input:
        - iron_ingot|quartz|iron_ingot
        - quartz|repeater|quartz
        - iron_ingot|quartz|iron_ingot
    2:
      type: shaped
      input:
        - quartz|iron_ingot|quartz
        - iron_ingot|repeater|iron_ingot
        - quartz|iron_ingot|quartz

wireless_redstone_display_block:
  type: entity
  debug: false
  entity_type: item_display
  mechanisms:
    translation: -0.001,-0.001,-0.001
    scale: 1.0021,1.0021,1.0021
