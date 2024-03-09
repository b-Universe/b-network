generate_blockstates_tool:
  type: task
  debug: false
  definitions: input
  data:
    blocks:
    # x 0/90/180/270, y 0/90/180/270
      set_0:
        - dirt
        - coarse_dirt
        - rooted_dirt
        - mud
        - clay
        - gravel
        - sand
        - red_sand
        - ice
        - packed_ice
        - blue_ice
        - snow_block
        - moss_block
        - granite
        - diorite
        - prismarine
        - calcite
        - tuff
        - ancient_debris
        #- end_stone
        - glowstone
        - amethyst_block
        - budding_amethyst

        - oak_leaves
        - birch_leaves
        - jungle_leaves
        - cherry_leaves
        - flowering_azalea_leaves
        - azalea_leaves

        - tube_coral_block
        - brain_coral_block
        - bubble_coral_block
        - fire_coral_block
        - horn_coral_block
        - dead_tube_coral_block
        - dead_brain_coral_block
        - dead_bubble_coral_block
        - dead_fire_coral_block
        - dead_horn_coral_block
        - wet_sponge
        - sponge

        - honeycomb_block
        - slime_block
        - honey_block
    # x 0/180, y 0/180
      set_1:
        - andesite

        - dripstone_block

        - magma_block
        - obsidian
        - crying_obsidian
        - netherrack
        - blackstone
        - basalt

        - coal_ore
        - deepslate_coal_ore
        - iron_ore
        - deepslate_iron_ore
        - copper_ore
        - deepslate_copper_ore
        - gold_ore
        - deepslate_gold_ore
        - redstone_ore
        - deepslate_redstone_ore
        - emerald_ore
        - deepslate_emerald_ore
        - lapis_ore
        - deepslate_lapis_ore
        - diamond_ore
        - deepslate_diamond_ore
        - nether_gold_ore
        - nether_quartz_ore
        - raw_iron_block
        - raw_copper_block
        - raw_gold_block

        - spruce_leaves
        - mangrove_leaves

        - pumpkin
        - melon
        - bee_hive

        - white_wool
        - light_gray_wool
        - gray_wool
        - black_wool
        - brown_wool
        - red_wool
        - orange_wool
        - yellow_wool
        - lime_wool
        - green_wool
        - cyan_wool
        - light_blue_wool
        - blue_wool
        - purple_wool
        - magenta_wool
        - pink_wool
        - terracotta
        - white_terracotta
        - light_gray_terracotta
        - gray_terracotta
        - light_blue_terracotta
        - cyan_terracotta
        - green_terracotta
        - lime_terracotta
        - yellow_terracotta
        - orange_terracotta
        - red_terracotta
        - brown_terracotta
        - black_terracotta
        - blue_terracotta
        - purple_terracotta
        - magenta_terracotta
        - pink_terracotta

    # snowy=true/false, x 0, y 0/90/180/270
      snowy:
        - grass_block
        - mycelium
        - podzol

    # x 0, y 0/90/180/270
      set_2:
        - dirt_path
        - sandstone
        - red_sandstone

    # axis=x/y/z
      set_3:
        - oak_log
        - spruce_log
        - birch_log
        - jungle_log
        - acacia_log
        - dark_oak_log
        - mangrove_log
        - mangrove_roots
        - muddy_mangrove_roots
        - cherry_log

        - stripped_oak_log
        - stripped_spruce_log
        - stripped_birch_log
        - stripped_jungle_log
        - stripped_acacia_log
        - stripped_dark_oak_log
        - stripped_mangrove_log
        - stripped_cherry_log

      set_5:
        - stripped_oak_wood
        - stripped_spruce_wood
        - stripped_birch_wood
        - stripped_jungle_wood
        - stripped_acacia_wood
        - stripped_dark_oak_wood
        - stripped_mangrove_wood
        - stripped_cherry_wood

      set_7:
        - white_carpet
        - light_gray_carpet
        - gray_carpet
        - black_carpet
        - brown_carpet
        - red_carpet
        - orange_carpet
        - yellow_carpet
        - lime_carpet
        - green_carpet
        - cyan_carpet
        - light_blue_carpet
        - blue_carpet
        - purple_carpet
        - magenta_carpet
        - pink_carpet
      set_8:
        - candle
        - white_candle
        - light_gray_candle
        - gray_candle
        - black_candle
        - brown_candle
        - red_candle
        - orange_candle
        - yellow_candle
        - lime_candle
        - green_candle
        - cyan_candle
        - light_blue_candle
        - blue_candle
        - purple_candle
        - magenta_candle
        - pink_candle
    basic_0_90_180_270_x_y:
      - <&lc>
      -   <&dq>variants<&dq><&co> <&lc>
      -     <&dq.repeat[2]><&co> <&lb>
      -       <&lc> <&dq>model<&dq><&co> <&dq>block/<[block]><&dq>, <&dq>x<&dq><&co> 0,   <&dq>y<&dq><&co> 0   <&rc>,
      -       <&lc> <&dq>model<&dq><&co> <&dq>block/<[block]><&dq>, <&dq>x<&dq><&co> 0,   <&dq>y<&dq><&co> 90  <&rc>,
      -       <&lc> <&dq>model<&dq><&co> <&dq>block/<[block]><&dq>, <&dq>x<&dq><&co> 0,   <&dq>y<&dq><&co> 180 <&rc>,
      -       <&lc> <&dq>model<&dq><&co> <&dq>block/<[block]><&dq>, <&dq>x<&dq><&co> 0,   <&dq>y<&dq><&co> 270 <&rc>,
      -       <&lc> <&dq>model<&dq><&co> <&dq>block/<[block]><&dq>, <&dq>x<&dq><&co> 90,  <&dq>y<&dq><&co> 0   <&rc>,
      -       <&lc> <&dq>model<&dq><&co> <&dq>block/<[block]><&dq>, <&dq>x<&dq><&co> 90,  <&dq>y<&dq><&co> 90  <&rc>,
      -       <&lc> <&dq>model<&dq><&co> <&dq>block/<[block]><&dq>, <&dq>x<&dq><&co> 90,  <&dq>y<&dq><&co> 180 <&rc>,
      -       <&lc> <&dq>model<&dq><&co> <&dq>block/<[block]><&dq>, <&dq>x<&dq><&co> 90,  <&dq>y<&dq><&co> 270 <&rc>,
      -       <&lc> <&dq>model<&dq><&co> <&dq>block/<[block]><&dq>, <&dq>x<&dq><&co> 180, <&dq>y<&dq><&co> 0   <&rc>,
      -       <&lc> <&dq>model<&dq><&co> <&dq>block/<[block]><&dq>, <&dq>x<&dq><&co> 180, <&dq>y<&dq><&co> 90  <&rc>,
      -       <&lc> <&dq>model<&dq><&co> <&dq>block/<[block]><&dq>, <&dq>x<&dq><&co> 180, <&dq>y<&dq><&co> 180 <&rc>,
      -       <&lc> <&dq>model<&dq><&co> <&dq>block/<[block]><&dq>, <&dq>x<&dq><&co> 180, <&dq>y<&dq><&co> 270 <&rc>,
      -       <&lc> <&dq>model<&dq><&co> <&dq>block/<[block]><&dq>, <&dq>x<&dq><&co> 270, <&dq>y<&dq><&co> 0   <&rc>,
      -       <&lc> <&dq>model<&dq><&co> <&dq>block/<[block]><&dq>, <&dq>x<&dq><&co> 270, <&dq>y<&dq><&co> 90  <&rc>,
      -       <&lc> <&dq>model<&dq><&co> <&dq>block/<[block]><&dq>, <&dq>x<&dq><&co> 270, <&dq>y<&dq><&co> 180 <&rc>,
      -       <&lc> <&dq>model<&dq><&co> <&dq>block/<[block]><&dq>, <&dq>x<&dq><&co> 270, <&dq>y<&dq><&co> 270 <&rc>
      -     <&rb>
      -   <&rc>
      - <&rc><n>
    basic_0_180_x_y:
      - <&lc>
      -   <&dq>variants<&dq><&co> <&lc>
      -     <&dq.repeat[2]><&co> <&lb>
      -       <&lc> <&dq>model<&dq><&co> <&dq>block/<[block]><&dq>, <&dq>x<&dq><&co> 0,   <&dq>y<&dq><&co> 0   <&rc>,
      -       <&lc> <&dq>model<&dq><&co> <&dq>block/<[block]><&dq>, <&dq>x<&dq><&co> 0,   <&dq>y<&dq><&co> 180 <&rc>,
      -       <&lc> <&dq>model<&dq><&co> <&dq>block/<[block]><&dq>, <&dq>x<&dq><&co> 180, <&dq>y<&dq><&co> 0   <&rc>,
      -       <&lc> <&dq>model<&dq><&co> <&dq>block/<[block]><&dq>, <&dq>x<&dq><&co> 180, <&dq>y<&dq><&co> 180 <&rc>
      -     <&rb>
      -   <&rc>
      - <&rc><n>
    basic_0_180_x_y_2:
      - <&lc>
      -   <&dq>variants<&dq><&co> <&lc>
      -     <&dq.repeat[2]><&co> <&lb>
      -       <&lc> <&dq>model<&dq><&co> <&dq>block/<[block]><&dq>, <&dq>x<&dq><&co> 0, <&dq>y<&dq><&co> 0   <&rc>,
      -       <&lc> <&dq>model<&dq><&co> <&dq>block/<[block]><&dq>, <&dq>x<&dq><&co> 0, <&dq>y<&dq><&co> 180 <&rc>
      -     <&rb>
      -   <&rc>
      - <&rc><n>
    basic_x_0_y_0_90_180_270:
      - <&lc>
      -   <&dq>variants<&dq><&co> <&lc>
      -     <&dq.repeat[2]><&co> <&lb>
      -       <&lc> <&dq>model<&dq><&co> <&dq>block/<[block]><&dq>, <&dq>x<&dq><&co> 0, <&dq>y<&dq><&co> 0   <&rc>,
      -       <&lc> <&dq>model<&dq><&co> <&dq>block/<[block]><&dq>, <&dq>x<&dq><&co> 0, <&dq>y<&dq><&co> 90  <&rc>,
      -       <&lc> <&dq>model<&dq><&co> <&dq>block/<[block]><&dq>, <&dq>x<&dq><&co> 0, <&dq>y<&dq><&co> 180 <&rc>,
      -       <&lc> <&dq>model<&dq><&co> <&dq>block/<[block]><&dq>, <&dq>x<&dq><&co> 0, <&dq>y<&dq><&co> 270 <&rc>
      -     <&rb>
      -   <&rc>
      - <&rc><n>
    snowy:
      - <&lc>
      -   <&dq>variants<&dq><&co> <&lc>
      -     <&dq>snowy=false<&dq><&co> <&lb>
      -       <&lc> <&dq>model<&dq><&co> <&dq>block/<[block]><&dq>, <&dq>x<&dq><&co> 0, <&dq>y<&dq><&co> 0   <&rc>,
      -       <&lc> <&dq>model<&dq><&co> <&dq>block/<[block]><&dq>, <&dq>x<&dq><&co> 0, <&dq>y<&dq><&co> 90  <&rc>,
      -       <&lc> <&dq>model<&dq><&co> <&dq>block/<[block]><&dq>, <&dq>x<&dq><&co> 0, <&dq>y<&dq><&co> 180 <&rc>,
      -       <&lc> <&dq>model<&dq><&co> <&dq>block/<[block]><&dq>, <&dq>x<&dq><&co> 0, <&dq>y<&dq><&co> 270 <&rc>
      -     <&rb>,
      -     <&dq>snowy=true<&dq><&co> <&lb>
      -       <&lc> <&dq>model<&dq><&co> <&dq>block/grass_block_snow<&dq>, <&dq>x<&dq><&co> 0, <&dq>y<&dq><&co> 0   <&rc>,
      -       <&lc> <&dq>model<&dq><&co> <&dq>block/grass_block_snow<&dq>, <&dq>x<&dq><&co> 0, <&dq>y<&dq><&co> 90  <&rc>,
      -       <&lc> <&dq>model<&dq><&co> <&dq>block/grass_block_snow<&dq>, <&dq>x<&dq><&co> 0, <&dq>y<&dq><&co> 180 <&rc>,
      -       <&lc> <&dq>model<&dq><&co> <&dq>block/grass_block_snow<&dq>, <&dq>x<&dq><&co> 0, <&dq>y<&dq><&co> 270 <&rc>
      -     <&rb>
      -   <&rc>
      - <&rc><n>

    adv_axis_xyz_1_LOG:
      - <&lc>
      -   <&dq>variants<&dq><&co> <&lc>
      -     <&dq>axis=x<&dq><&co> <&lb>
      -       <&lc> <&dq>model<&dq><&co> <&dq>block/<[block]>_horizontal<&dq>, <&dq>x<&dq><&co> 90,  <&dq>y<&dq><&co> 90  <&rc>,
      -       <&lc> <&dq>model<&dq><&co> <&dq>block/<[block]>_horizontal<&dq>, <&dq>x<&dq><&co> 90,  <&dq>y<&dq><&co> 270 <&rc>,
      -       <&lc> <&dq>model<&dq><&co> <&dq>block/<[block]>_horizontal<&dq>, <&dq>x<&dq><&co> 270, <&dq>y<&dq><&co> 90  <&rc>,
      -       <&lc> <&dq>model<&dq><&co> <&dq>block/<[block]>_horizontal<&dq>, <&dq>x<&dq><&co> 270, <&dq>y<&dq><&co> 270 <&rc>
      -     <&rb>,
      -     <&dq>axis=y<&dq><&co> <&lb>
      -       <&lc> <&dq>model<&dq><&co> <&dq>block/<[block]><&dq>,            <&dq>x<&dq><&co> 0,   <&dq>y<&dq><&co> 0    <&rc>,
      -       <&lc> <&dq>model<&dq><&co> <&dq>block/<[block]><&dq>,            <&dq>x<&dq><&co> 0,   <&dq>y<&dq><&co> 180  <&rc>,
      -       <&lc> <&dq>model<&dq><&co> <&dq>block/<[block]><&dq>,            <&dq>x<&dq><&co> 180, <&dq>y<&dq><&co> 0    <&rc>,
      -       <&lc> <&dq>model<&dq><&co> <&dq>block/<[block]><&dq>,            <&dq>x<&dq><&co> 180, <&dq>y<&dq><&co> 180  <&rc>
      -     <&rb>,
      -     <&dq>axis=z<&dq><&co> <&lb>
      -       <&lc> <&dq>model<&dq><&co> <&dq>block/<[block]>_horizontal<&dq>, <&dq>x<&dq><&co> 90,  <&dq>y<&dq><&co> 0    <&rc>,
      -       <&lc> <&dq>model<&dq><&co> <&dq>block/<[block]>_horizontal<&dq>, <&dq>x<&dq><&co> 90,  <&dq>y<&dq><&co> 180  <&rc>,
      -       <&lc> <&dq>model<&dq><&co> <&dq>block/<[block]>_horizontal<&dq>, <&dq>x<&dq><&co> 270, <&dq>y<&dq><&co> 0    <&rc>,
      -       <&lc> <&dq>model<&dq><&co> <&dq>block/<[block]>_horizontal<&dq>, <&dq>x<&dq><&co> 270, <&dq>y<&dq><&co> 180  <&rc>
      -     <&rb>
      -   <&rc>
      - <&rc>
    adv_axis_xyz_1:
      - <&lc>
      -   <&dq>variants<&dq><&co> <&lc>
      -     <&dq>axis=x<&dq><&co> <&lb>
      -       <&lc> <&dq>model<&dq><&co> <&dq>block/<[block]><&dq>, <&dq>x<&dq><&co> 90,  <&dq>y<&dq><&co> 90  <&rc>,
      -       <&lc> <&dq>model<&dq><&co> <&dq>block/<[block]><&dq>, <&dq>x<&dq><&co> 90,  <&dq>y<&dq><&co> 270 <&rc>,
      -       <&lc> <&dq>model<&dq><&co> <&dq>block/<[block]><&dq>, <&dq>x<&dq><&co> 270, <&dq>y<&dq><&co> 90  <&rc>,
      -       <&lc> <&dq>model<&dq><&co> <&dq>block/<[block]><&dq>, <&dq>x<&dq><&co> 270, <&dq>y<&dq><&co> 270 <&rc>
      -     <&rb>,
      -     <&dq>axis=y<&dq><&co> <&lb>
      -       <&lc> <&dq>model<&dq><&co> <&dq>block/<[block]><&dq>, <&dq>x<&dq><&co> 0,   <&dq>y<&dq><&co> 0    <&rc>,
      -       <&lc> <&dq>model<&dq><&co> <&dq>block/<[block]><&dq>, <&dq>x<&dq><&co> 0,   <&dq>y<&dq><&co> 180  <&rc>,
      -       <&lc> <&dq>model<&dq><&co> <&dq>block/<[block]><&dq>, <&dq>x<&dq><&co> 180, <&dq>y<&dq><&co> 0    <&rc>,
      -       <&lc> <&dq>model<&dq><&co> <&dq>block/<[block]><&dq>, <&dq>x<&dq><&co> 180, <&dq>y<&dq><&co> 180  <&rc>
      -     <&rb>,
      -     <&dq>axis=z<&dq><&co> <&lb>
      -       <&lc> <&dq>model<&dq><&co> <&dq>block/<[block]><&dq>, <&dq>x<&dq><&co> 90,  <&dq>y<&dq><&co> 0    <&rc>,
      -       <&lc> <&dq>model<&dq><&co> <&dq>block/<[block]><&dq>, <&dq>x<&dq><&co> 90,  <&dq>y<&dq><&co> 180  <&rc>,
      -       <&lc> <&dq>model<&dq><&co> <&dq>block/<[block]><&dq>, <&dq>x<&dq><&co> 270, <&dq>y<&dq><&co> 0    <&rc>,
      -       <&lc> <&dq>model<&dq><&co> <&dq>block/<[block]><&dq>, <&dq>x<&dq><&co> 270, <&dq>y<&dq><&co> 180  <&rc>
      -     <&rb>
      -   <&rc>
      - <&rc>
    candles:
      - <&lc>
      -   <&dq>variants<&dq><&co> <&lc>
      -     <&dq>candles=1,lit=false<&dq><&co> <&lc> <&dq>model<&dq><&co> <&dq>block/<[block]>_one_candle<&dq>     <&rc>,
      -     <&dq>candles=1,lit=true<&dq><&co>  <&lc> <&dq>model<&dq><&co> <&dq>block/<[block]>_one_candle_lit<&dq> <&rc>,
      -     <&dq>candles=2,lit=false<&dq><&co> <&lb>
      -       <&lc> <&dq>model<&dq><&co> <&dq>block/<[block]>_two_candles<&dq>,       <&dq>x<&dq><&co> 0, <&dq>y<&dq><&co> 0   <&rc>,
      -       <&lc> <&dq>model<&dq><&co> <&dq>block/<[block]>_two_candles<&dq>,       <&dq>x<&dq><&co> 0, <&dq>y<&dq><&co> 90  <&rc>,
      -       <&lc> <&dq>model<&dq><&co> <&dq>block/<[block]>_two_candles<&dq>,       <&dq>x<&dq><&co> 0, <&dq>y<&dq><&co> 180 <&rc>,
      -       <&lc> <&dq>model<&dq><&co> <&dq>block/<[block]>_two_candles<&dq>,       <&dq>x<&dq><&co> 0, <&dq>y<&dq><&co> 270 <&rc>
      -     <&rb>,
      -     <&dq>candles=2,lit=true<&dq><&co>  <&lb>
      -       <&lc> <&dq>model<&dq><&co> <&dq>block/<[block]>_two_candles_lit<&dq>,   <&dq>x<&dq><&co> 0, <&dq>y<&dq><&co> 0   <&rc>,
      -       <&lc> <&dq>model<&dq><&co> <&dq>block/<[block]>_two_candles_lit<&dq>,   <&dq>x<&dq><&co> 0, <&dq>y<&dq><&co> 90  <&rc>,
      -       <&lc> <&dq>model<&dq><&co> <&dq>block/<[block]>_two_candles_lit<&dq>,   <&dq>x<&dq><&co> 0, <&dq>y<&dq><&co> 180 <&rc>,
      -       <&lc> <&dq>model<&dq><&co> <&dq>block/<[block]>_two_candles_lit<&dq>,   <&dq>x<&dq><&co> 0, <&dq>y<&dq><&co> 270 <&rc>
      -     <&rb>,
      -     <&dq>candles=3,lit=false<&dq><&co> <&lb>
      -       <&lc> <&dq>model<&dq><&co> <&dq>block/<[block]>_three_candles<&dq>,     <&dq>x<&dq><&co> 0, <&dq>y<&dq><&co> 0   <&rc>,
      -       <&lc> <&dq>model<&dq><&co> <&dq>block/<[block]>_three_candles<&dq>,     <&dq>x<&dq><&co> 0, <&dq>y<&dq><&co> 90  <&rc>,
      -       <&lc> <&dq>model<&dq><&co> <&dq>block/<[block]>_three_candles<&dq>,     <&dq>x<&dq><&co> 0, <&dq>y<&dq><&co> 180 <&rc>,
      -       <&lc> <&dq>model<&dq><&co> <&dq>block/<[block]>_three_candles<&dq>,     <&dq>x<&dq><&co> 0, <&dq>y<&dq><&co> 270 <&rc>
      -     <&rb>,
      -     <&dq>candles=3,lit=true<&dq><&co>  <&lb>
      -       <&lc> <&dq>model<&dq><&co> <&dq>block/<[block]>_three_candles_lit<&dq>, <&dq>x<&dq><&co> 0, <&dq>y<&dq><&co> 0   <&rc>,
      -       <&lc> <&dq>model<&dq><&co> <&dq>block/<[block]>_three_candles_lit<&dq>, <&dq>x<&dq><&co> 0, <&dq>y<&dq><&co> 90  <&rc>,
      -       <&lc> <&dq>model<&dq><&co> <&dq>block/<[block]>_three_candles_lit<&dq>, <&dq>x<&dq><&co> 0, <&dq>y<&dq><&co> 180 <&rc>,
      -       <&lc> <&dq>model<&dq><&co> <&dq>block/<[block]>_three_candles_lit<&dq>, <&dq>x<&dq><&co> 0, <&dq>y<&dq><&co> 270 <&rc>
      -     <&rb>,
      -     <&dq>candles=4,lit=false<&dq><&co> <&lb>
      -       <&lc> <&dq>model<&dq><&co> <&dq>block/<[block]>_four_candles<&dq>,      <&dq>x<&dq><&co> 0, <&dq>y<&dq><&co> 0   <&rc>,
      -       <&lc> <&dq>model<&dq><&co> <&dq>block/<[block]>_four_candles<&dq>,      <&dq>x<&dq><&co> 0, <&dq>y<&dq><&co> 90  <&rc>,
      -       <&lc> <&dq>model<&dq><&co> <&dq>block/<[block]>_four_candles<&dq>,      <&dq>x<&dq><&co> 0, <&dq>y<&dq><&co> 180 <&rc>,
      -       <&lc> <&dq>model<&dq><&co> <&dq>block/<[block]>_four_candles<&dq>,      <&dq>x<&dq><&co> 0, <&dq>y<&dq><&co> 270 <&rc>
      -     <&rb>,
      -     <&dq>candles=4,lit=true<&dq><&co>  <&lb>
      -       <&lc> <&dq>model<&dq><&co> <&dq>block/<[block]>_four_candles_lit<&dq>,  <&dq>x<&dq><&co> 0, <&dq>y<&dq><&co> 0   <&rc>,
      -       <&lc> <&dq>model<&dq><&co> <&dq>block/<[block]>_four_candles_lit<&dq>,  <&dq>x<&dq><&co> 0, <&dq>y<&dq><&co> 90  <&rc>,
      -       <&lc> <&dq>model<&dq><&co> <&dq>block/<[block]>_four_candles_lit<&dq>,  <&dq>x<&dq><&co> 0, <&dq>y<&dq><&co> 180 <&rc>,
      -       <&lc> <&dq>model<&dq><&co> <&dq>block/<[block]>_four_candles_lit<&dq>,  <&dq>x<&dq><&co> 0, <&dq>y<&dq><&co> 270 <&rc>
      -     <&rb>
      -   <&rc>
      - <&rc>
    bookshelf:
      1:
        - <&lc>
        -  <&dq>parent<&dq><&co> <&dq>block/cube_column<&dq>,
        -  <&dq>textures<&dq><&co> <&lc>
        -     <&dq>end<&dq><&co> <&dq>block/oak_planks<&dq>,
        -     <&dq>side<&dq><&co> <&dq>block/bookshelf<&dq>
        -  <&rc>,
        -  <&dq>elements<&dq><&co> <&lb>
      axis:
        1:   0,  8,  0<&rb>|<&lb> 0,  0,  0
        2:  16, 16, 16<&rb>|<&lb>16,  8, 16
      uv:
        1:  0,  0, 16,  8
        2:  0,  8, 16, 16
        3: 16,  0,  0,  8
        4: 16,  8,  0, 16
      2:
        1:
          -    <&lc>
          -      <&dq>from<&dq><&co> <&lb> 0,  8,  0<&rb>,
          -      <&dq>to<&dq><&co>   <&lb>16, 16, 16<&rb>,
          -      <&dq>faces<&dq><&co> <&lc>
        2:
          -    <&lc>
          -      <&dq>from<&dq><&co> <&lb> 0,  0,  0<&rb>,
          -      <&dq>to<&dq><&co>   <&lb>16,  8, 16<&rb>,
          -      <&dq>faces<&dq><&co> <&lc>
      3:
        -        <&dq>north<&dq><&co> <&lc><&dq>uv<&dq><&co> <&lb><[mhmvshsv1]><&rb>, <&dq>texture<&dq><&co> <&dq><&ns>side<&dq><&rc>,
        -        <&dq>south<&dq><&co> <&lc><&dq>uv<&dq><&co> <&lb><[mhmvshsv2]><&rb>, <&dq>texture<&dq><&co> <&dq><&ns>side<&dq><&rc>,
        -        <&dq>east<&dq><&co>  <&lc><&dq>uv<&dq><&co> <&lb><[mhmvshsv3]><&rb>, <&dq>texture<&dq><&co> <&dq><&ns>side<&dq><&rc>,
        -        <&dq>west<&dq><&co>  <&lc><&dq>uv<&dq><&co> <&lb><[mhmvshsv4]><&rb>, <&dq>texture<&dq><&co> <&dq><&ns>side<&dq><&rc>,
      4:
        -        <&dq>up<&dq><&co>    <&lc><&dq>uv<&dq><&co> <&lb> 0,  0, 16, 16<&rb>, <&dq>texture<&dq><&co> <&dq><&ns>end<&dq><&rc>,
        -        <&dq>down<&dq><&co>  <&lc><&dq>uv<&dq><&co> <&lb> 0,  0, 16, 16<&rb>, <&dq>texture<&dq><&co> <&dq><&ns>end<&dq><&rc>
        -      <&rc>
        -    <&rc>
      5:
        -   <&rb>
        - <&rc>
  script:
    - choose <[input].if_null[0]>:
      - case 0:
        - foreach <script.data_key[data.blocks.set_0]> as:block:
          - define text <script.parsed_key[data.basic_0_90_180_270_x_y].separated_by[<n>]>
          - ~filewrite path:resource_generated_data/blockstates/<[block]>.json data:<[text].utf8_encode>

        - foreach <script.data_key[data.blocks.set_1]> as:block:
          - define text <script.parsed_key[data.basic_0_180_x_y].separated_by[<n>]>
          - ~filewrite path:resource_generated_data/blockstates/<[block]>.json data:<[text].utf8_encode>

        - foreach <script.data_key[data.blocks.snowy]> as:block:
          - define text <script.parsed_key[data.snowy].separated_by[<n>]>
          - ~filewrite path:resource_generated_data/blockstates/<[block]>.json data:<[text].utf8_encode>
        - foreach <script.data_key[data.blocks.set_2]> as:block:
          - define text <script.parsed_key[data.basic_x_0_y_0_90_180_270].separated_by[<n>]>
          - ~filewrite path:resource_generated_data/blockstates/<[block]>.json data:<[text].utf8_encode>
        - foreach <script.data_key[data.blocks.set_3]> as:block:
          - define text <script.parsed_key[data.adv_axis_xyz_1_LOG].separated_by[<n>]>
          - ~filewrite path:resource_generated_data/blockstates/<[block]>.json data:<[text].utf8_encode>

        - foreach <script.data_key[data.blocks.set_5]> as:block:
          - define text <script.parsed_key[data.adv_axis_xyz_1].separated_by[<n>]>
          - ~filewrite path:resource_generated_data/blockstates/<[block]>.json data:<[text].utf8_encode>

        - foreach <script.data_key[data.blocks.set_7]> as:block:
          - define text <script.parsed_key[data.basic_0_180_x_y_2].separated_by[<n>]>
          - ~filewrite path:resource_generated_data/blockstates/<[block]>.json data:<[text].utf8_encode>
        - foreach <script.data_key[data.blocks.set_8]> as:block:
          - define text <script.parsed_key[data.candles].separated_by[<n>]>
          - ~filewrite path:resource_generated_data/blockstates/<[block]>.json data:<[text].utf8_encode>
      - case 1:

        - define elements <list>
        - foreach <list_single[<list[0|0|16|8]>].include_single[<list[0|8|16|16]>].include_single[<list[16|0|0|8]>].include_single[<list[16|8|0|16]>]> as:mhmvshsv1:
          - foreach <list_single[<list[0|0|16|8]>].include_single[<list[0|8|16|16]>].include_single[<list[16|0|0|8]>].include_single[<list[16|8|0|16]>]> as:mhmvshsv2:
            - foreach <list_single[<list[0|0|16|8]>].include_single[<list[0|8|16|16]>].include_single[<list[16|0|0|8]>].include_single[<list[16|8|0|16]>]> as:mhmvshsv3:
              - foreach <list_single[<list[0|0|16|8]>].include_single[<list[0|8|16|16]>].include_single[<list[16|0|0|8]>].include_single[<list[16|8|0|16]>]> as:mhmvshsv4:
                - definemap element:
                    from: <list[0|0|0]>
                    to: <list[16|8|16]>
                    faces:
                      north:
                        uv: <[mhmvshsv1]>
                        texture: <&ns>side
                      south:
                        uv: <[mhmvshsv2]>
                        texture: <&ns>side
                      east:
                        uv: <[mhmvshsv3]>
                        texture: <&ns>side
                      west:
                        uv: <[mhmvshsv4]>
                        texture: <&ns>side
                      up:
                        uv: <list[0|0|16|16]>
                        texture: <&ns>side
                      down:
                        uv: <list[0|0|16|16]>
                        texture: <&ns>side
                - define elements <[elements].include_single[<[element]>]>
                - definemap element:
                    from: <list[0|8|0]>
                    to: <list[16|16|16]>
                    faces:
                      north:
                        uv: <[mhmvshsv1]>
                        texture: <&ns>side
                      south:
                        uv: <[mhmvshsv2]>
                        texture: <&ns>side
                      east:
                        uv: <[mhmvshsv3]>
                        texture: <&ns>side
                      west:
                        uv: <[mhmvshsv4]>
                        texture: <&ns>side
                      up:
                        uv: <list[0|0|16|16]>
                        texture: <&ns>side
                      down:
                        uv: <list[0|0|16|16]>
                        texture: <&ns>side
                - define elements <[elements].include_single[<[element]>]>
        - definemap root:
            parent: block/cube_column
            textures:
              end: block/oak_planks
              side: block/bookshelf
            elements: <[elements]>
        - define text <[root].to_json[native_types=true]>
        - ~filewrite path:resource_generated_data/block/bookshelf.json data:<[text].utf8_encode>
      - case 2:
        - narrate ok
