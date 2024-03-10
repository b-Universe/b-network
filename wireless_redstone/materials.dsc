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

wireless_complete_button:
  type: item
  debug: false
  material: player_head
  display name: <&color[<proc[prgb]>]>Set Frequency
  mechanisms:
    custom_model_data: 1053

wireless_up_1_button:
  type: item
  debug: false
  material: player_head
  display name: <&color[<proc[prgb]>]>Increase Frequency +1
  mechanisms:
    custom_model_data: 1053

wireless_down_1_button:
  type: item
  debug: false
  material: player_head
  display name: <&color[<proc[prgb]>]>Decrease Frequency +1
  mechanisms:
    custom_model_data: 1053

wireless_up_10_button:
  type: item
  debug: false
  material: player_head
  display name: <&color[<proc[prgb]>]>Increase Frequency +10
  mechanisms:
    custom_model_data: 1053

wireless_down_10_button:
  type: item
  debug: false
  material: player_head
  display name: <&color[<proc[prgb]>]>Decrease Frequency +10
  mechanisms:
    custom_model_data: 1053

wireless_frequency_tuner:
  type: item
  debug: false
  material: dispenser
  display name: <&b>Wireless Receiver
  mechanisms:
    custom_model_data: 1014
  flags:
    wireless_redstone: frequency_tuner

wireless_configuration_gui:
  type: inventory
  debug: false
  inventory: chest
  gui: true
  size: 27
  title: <script.parsed_key[data.title].unseparated>
  data:
    title:
      - <proc[bbackground].context[27|e005]>
      - <proc[positive_spacing].context[48]>
      - <&chr[E001].font[gui_sprites]>
      - <proc[negative_spacing].context[50]>
      - <&color[<proc[prgb]>]><element[Frequency<&co><&sp>].color[<proc[prgb]>].font[minecraft_15.5]>
      - <&font[minecraft_15.5]>
  definitions:
    1: wireless_up_1_button
    2: wireless_up_10_button
    c: wireless_complete_button
    3: wireless_down_1_button
    4: wireless_down_10_button
  slots:
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [4] [3] [c] [1] [2] [] []
