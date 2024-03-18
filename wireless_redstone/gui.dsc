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
      - <proc[sp].context[48]>
      - <&chr[E001].font[gui_sprites]>
      - <proc[-sp].context[50]>
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

wireless_redstone_handler:
  type: world
  debug: false
  events:
    on player closes wireless_configuration_gui:
      - define location <player.flag[behr.essentials.wireless_redstone_gui.location]>
      - define material <[location].flag[behr.essentials.wireless_redstone.material]>
      - define old_frequency <[location].flag[behr.essentials.wireless_redstone.frequency]>
      - define new_frequency <player.flag[behr.essentials.wireless_redstone_gui.frequency]>
      - if <[old_frequency]> == <[new_frequency]>:
        - stop
      - flag <[location]> behr.essentials.wireless_redstone.frequency:<[new_frequency]>

      - if <[material]> == receiver:
        - run wireless_redstone_refresh_receiver_task def:<[location]>|<[new_frequency]>

      - else if <[material]> == transmitter:
        - ~run wireless_redstone_refresh_receivers_task def:<[location]>|<[old_frequency]>
        - ~run wireless_redstone_refresh_receivers_task def:<[location]>|<[new_frequency]>


      - actionbar "<&[green]>Frequency set to <player.flag[behr.essentials.wireless_redstone_gui.frequency].if_null[0]>"
      - flag <player> behr.essentials.wireless_redstone_gui.frequency:!

    on player clicks wireless_complete_button in inventory:
      - playsound <player> entity_player_levelup pitch:<util.random.decimal[0.8].to[1.2]> volume:0.3 if:<player.has_flag[behr.essentials.settings.playsounds]>
      - inventory close

    on player clicks wireless_up_1_button in inventory:
      - determine passively cancelled
      - flag <player> behr.essentials.wireless_redstone_gui.frequency:++
      - adjust <context.inventory> title:<script[wireless_configuration_gui].parsed_key[data.title].unseparated><player.flag[behr.essentials.wireless_redstone_gui.frequency].if_null[0]>
      - inventory open d:<context.inventory>
      - playsound <player> entity_player_levelup pitch:<util.random.decimal[0.8].to[1.2]> volume:0.3 if:<player.has_flag[behr.essentials.settings.playsounds]>

    on player clicks wireless_down_1_button in inventory:
      - determine passively cancelled
      - flag <player> behr.essentials.wireless_redstone_gui.frequency:--
      - adjust <context.inventory> title:<script[wireless_configuration_gui].parsed_key[data.title].unseparated><player.flag[behr.essentials.wireless_redstone_gui.frequency].if_null[0]>
      - inventory open d:<context.inventory>
      - playsound <player> entity_player_levelup pitch:<util.random.decimal[0.8].to[1.2]> volume:0.3 if:<player.has_flag[behr.essentials.settings.playsounds]>

    on player clicks wireless_up_10_button in inventory:
      - determine passively cancelled
      - flag <player> behr.essentials.wireless_redstone_gui.frequency:+:10
      - adjust <context.inventory> title:<script[wireless_configuration_gui].parsed_key[data.title].unseparated><player.flag[behr.essentials.wireless_redstone_gui.frequency].if_null[0]>
      - inventory open d:<context.inventory>
      - playsound <player> entity_player_levelup pitch:<util.random.decimal[0.8].to[1.2]> volume:0.3 if:<player.has_flag[behr.essentials.settings.playsounds]>

    on player clicks wireless_down_10_button in inventory:
      - determine passively cancelled
      - flag <player> behr.essentials.wireless_redstone_gui.frequency:-:10
      - adjust <context.inventory> title:<script[wireless_configuration_gui].parsed_key[data.title].unseparated><player.flag[behr.essentials.wireless_redstone_gui.frequency].if_null[0]>
      - inventory open d:<context.inventory>
      - playsound <player> entity_player_levelup pitch:<util.random.decimal[0.8].to[1.2]> volume:0.3 if:<player.has_flag[behr.essentials.settings.playsounds]>


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
