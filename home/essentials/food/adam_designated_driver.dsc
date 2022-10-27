adam_designated_driver:
  type: assignment
  debug: false
  actions:
    on assignment:
      - trigger click state:true

    on click:
      - inventory open d:adam_designated_driver_temp_gui

adam_designated_driver_temp_gui:
  type: inventory
  debug: false
  inventory: chest
  size: 54
  gui: true
  title: <script.parsed_key[data.title].unseparated>
  data:
    title:
      # gui background
      - <&f><proc[negative_spacing].context[8].font[utility:spacing]>
      - <&chr[<util.random.int[1011].to[1018]>].font[gui]>

      #- <proc[negative_spacing].context[92].font[utility:spacing]>
      #- <&color[#3488A6]><&font[minecraft_4]>Pescetarian Puffman<&co>
      #- <proc[negative_spacing].context[106].font[utility:spacing]>
      #- <black><&font[minecraft_8]>Hey there! Welcome
      #- <proc[negative_spacing].context[95].font[utility:spacing]>
      #- <black><&font[minecraft_12]>to the fishing area;
      #- <proc[negative_spacing].context[98].font[utility:spacing]>
      #- <black><&font[minecraft_16]>Want a quick run-
      #- <proc[negative_spacing].context[89].font[utility:spacing]>
      #- <black><&font[minecraft_20]>down of stuff here?
  definitions:
    #head: pescetarian_puffman_head[lore=<empty.repeat_as_list[160]>]
    #head: pescetarian_puffman_head_temp[lore=<empty.repeat_as_list[160]>]
    soup: good_soup_soup_shop_button
  slots:
    - [] [] [] [] [] [] [] [] []
    - [] [soup] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []

good_soup_soup_shop_button:
  type: item
  debug: false
  material: cooked_chicken
  display name: <element[Good Soup Soup Shop].color_gradient[from=#55ffff;to=#a7ffff]>
  lore:
    - <element[Buy some good soup].color_gradient[from=#555555;to=#9b9b9b]>
  mechanisms:
    custom_model_data: 1001

adams_good_soup_shop:
  type: inventory
  debug: false
  inventory: chest
  size: 54
  gui: true
  title: <script.parsed_key[data.title].unseparated>
  data:
    title:
      # gui background
      - <&f><proc[negative_spacing].context[8].font[utility:spacing]>
      - <&chr[<util.random.int[1011].to[1018]>].font[gui]>
  definitions:
    1: broccoli_cream_soup[lore=]
    2: broccoli_soup[lore=]
    3: cheese_soup[lore=]
    4: cream_soup[lore=]
    5: pufferfish_soup[lore=]
    6: tomato_soup[lore=]
    7: tomato_cream_soup[lore=]
  slots:
    - [] [] [] [] [] [] [] [] []
    - [] [1] [] [2] [] [3] [] [4] []
    - [] [] [] [] [] [] [] [] []
    - [] [5] [] [6] [] [7] [] [] []
    - [] [] [] [] [] [] [] [] []

 

adams_inventory_handler:
  type: world
  debug: false
  events:
    on player clicks good_soup_soup_shop_button in adam_designated_driver_temp_gui:
      - inventory open d:adams_good_soup_shop
