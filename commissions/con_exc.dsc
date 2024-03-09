construction_command:
  type: command
  debug: false
  name: con
  usage: /con
  description: makes blocks
  tab completions:
    8:  inventory|destroy|drop
    11:  inventory|destroy|drop
  script:
    - stop if:!<player.has_flag[test]>
    - define args <context.args>
    - if <[args].size> !in 7|8|10|11:
      - narrate "<&c>Invalid usage"
      - playsound <player> sound:block_fire_extinguish
      - stop

    - define player_xyz <player.location.xyz.split[,]>
    - if <[args].size> in 7|8:
      - define coordinates <[args].get[1].to[6]>
    - else <[args].size> in 10|11:
      - define coordinates <[args].get[1].to[9]>
    - foreach <[coordinates]> as:arg:
      - if !<[arg].is_decimal>:
        - if <[arg]> != ~:
          - narrate "<&e><[arg]> <&c>is an invalid number"
          - playsound <player> sound:block_fire_extinguish
          - stop
        - define args <[args].set[<[player_xyz].get[<[loop_index].sub[1].mod[3].add[1]>]>].at[<[loop_index]>]>

    - if <[args].size> in 7|8:
      - define material_name <[args].get[7]>
    - else:
      - define material_name <[args].get[10]>
    - if !<material[<[material_name]>].exists>:
      - narrate "<&c>Invalid material"
      - playsound <player> sound:block_fire_extinguish
      - stop

    - if <[material_name]> in <script[construction_materials].data_key[blacklist]>:
      - narrate "<&c>Blacklisted material"
      - playsound <player> sound:block_fire_extinguish
      - stop

    - if <[material_name]> in <script[construction_materials].list_keys[swap]>:
      - define material_name <script[construction_materials].data_key[swap.<[material_name]>]>

    - define location_1 <[args].get[1|2|3].comma_separated.as[location].with_world[<player.world>]>
    - define location_2 <[args].get[4|5|6].comma_separated.as[location].with_world[<player.world>]>

    - if <[location_1].distance[<player.location>]> > 50 || <[location_2].distance[<player.location>]> > 50 :
      - narrate "<&c>Selection too far"
      - playsound <player> sound:block_fire_extinguish
      - stop

    - if <[args].size> in 10|11:
      - define expand_size <[args].get[7|8|9].comma_separated>
      - if <[args].size> == 11:
        - if <[args].last> == inventory:
          - define item_location inventory
        - else if <[args].last> == destroy:
          - define item_location destroy
        - else:
          - define item_location drop
      - else:
        - define item_location drop
    - else:
      - if <[args].size> == 8:
        - if <[args].last> == inventory:
          - define item_location inventory
        - else if <[args].last> == destroy:
          - define item_location destroy
        - else:
          - define item_location drop
      - else:
        - define item_location drop
      - define expand_size 0,0,0
    - define cuboid <[location_1].to_cuboid[<[location_2]>].expand[<[expand_size]>]>

    - define size <[cuboid].size>
    - define volume <[size].x.mul[<[size].y>].mul[<[size].z>]>
    - if <[volume]> > 10000:
      - narrate "<&c>Size too big"
      - playsound <player> sound:block_fire_extinguish
      - stop

    - if !<player.inventory.contains_item[<[material_name]>].quantity[<[volume]>]>:
      - if !<player.has_flag[behr.essentials.ratelimits.construct_pay_warning]>:
        - narrate "<&e><[size]> <&c>Not enough <&e><[material_name]><&c>. This costs <&e><[volume]><&c>, run again to pay?"
        - flag player behr.essentials.ratelimits.construct_pay_warning expire:5m
        - playsound <player> sound:block_fire_extinguish
        - stop
      - else:
        - if <player.money> < <[volume]>:
          - narrate "<&e><[size]> <&c>Not enough money. This costs <&e><[volume]>"
          - playsound <player> sound:block_fire_extinguish
          - stop
      - flag player behr.essentials.ratelimits.construct_pay_warning:!
      - money take quantity:<[volume]>

    - take item:<[material_name]> quantity:<[volume]>
    - foreach <[cuboid].blocks> as:block:
      - if <[block].material> !matches air && <[block].material> !matches <[material_name]>:
        - if <[item_location]> == inventory:
          - give <[block].material.item> to:<player.inventory>
        - else if <[item_location]> == drop:
          - drop <[block].material.item> <[block]>
      - modifyblock <[block]> <[material_name]>
      - playsound <[block]> sound:<material[<[material_name]>].block_sound_data.get[place_sound]>
      - playeffect at:<[block]> effect:block_dust offset:0.25 quantity:5 special_data:<material[<[material_name]>]>
      - wait 1t

construction_materials:
  type: data
  blacklist:
    - tnt
    - bedrock
  swap:
    grass: grass_block



excavate_command:
  type: command
  name: exc
  debug: false
  usage: /exc
  description: breaks blocks
  script:
    - define args <context.args>
    - if <[args].size> !in 3|4|6|7:
      - narrate "<&c>Invalid number of arguments"
      - playsound <player> sound:block_fire_extinguish
      - stop

    - define player_xyz <player.location.xyz.split[,]>
    - if <[args].size> in 3|4:
      - define coordinates <[args].get[1].to[3]>
    #      if <[args].size> in 6|7:
    - else:
      - define coordinates <[args].get[1].to[6]>
    - repeat <[args].size> as:loop_index:
      - define arg <[args].get[<[loop_index]>]>
      - if !<[arg].is_decimal>:
        - if <[arg]> != ~:
          - narrate "<&e><[arg]> <&c>is an invalid number"
          - playsound <player> sound:block_fire_extinguish
          - stop
        - define args <[args].set[<[player_xyz].get[<[loop_index].sub[1].mod[3].add[1]>]>].at[<[loop_index]>]>

    - if <[args].size> in 3|4:
      - define location_origin <player.location>
      - define location_destintion <[args].get[1|2|3].comma_separated.as[location].with_world[<player.world>]>
    - else:
      - define location_origin <[args].get[1|2|3].comma_separated.as[location].with_world[<player.world>]>
      - define location_destintion <[args].get[4|5|6].comma_separated.as[location].with_world[<player.world>]>

    - if <[location_origin].distance[<player.location>]> > 50 || <[location_destintion].distance[<player.location>]> > 50 :
      - narrate "<&c>Selection too far"
      - playsound <player> sound:block_fire_extinguish
      - stop

    - if <[args].last> == inventory:
      - define item_location inventory
    - else if <[args].last> == destroy:
      - define item_location destroy
    - else:
      - define item_location drop

    - define cuboid <[location_origin].to_cuboid[<[location_destintion]>]>

    - define size <[cuboid].size>
    - define volume <[size].x.mul[<[size].y>].mul[<[size].z>]>
    - if <[volume]> > 10000:
      - narrate "<&e><[size].xyz> <&c>is too big"
      - playsound <player> sound:block_fire_extinguish
      - stop

    - define pickaxe_slots <player.inventory.find_all_items[*pickaxe]>
    - define available_durability <[pickaxe_slots].parse_tag[<player.inventory.slot[<[parse_value]>].max_durability.sub[<player.inventory.slot[<[parse_value]>].durability>]>].sum>
    - if <[available_durability]> < <[volume]> && !<player.has_flag[behr.essentials.ratelimits.excavate_pay_warning]>:
      - narrate "<&c>Not enough pickaxe durability. Run again to pay <&e><[volume].sub[<[available_durability]>]> <&c>instead?"
      - flag player behr.essentials.ratelimits.excavate_pay_warning expire:5m
      - playsound <player> sound:block_fire_extinguish
      - stop
    - flag player behr.essentials.ratelimits.excavate_pay_warning:!

    - foreach <[pickaxe_slots]> as:pickaxe_slot:
      - define item_durability <player.inventory.slot[<[pickaxe_slot]>].durability>
      - define item_max_durability <player.inventory.slot[<[pickaxe_slot]>].max_durability>
      - define durability_use <[item_max_durability].sub[<[item_durability]>]>
      - if <[volume]> >= <[durability_use]>:
        - define volume <[volume].sub[<[durability_use]>]>
        - define available_durability:-:<[durability_use]>
        - take slot:<[pickaxe_slot]>
        - playsound <player> sound:block_anvil_break
      - else:
        - inventory adjust slot:<[pickaxe_slot]> durability:<[item_durability].add[<[volume]>]>
        - define volume <[volume].sub[<[available_durability]>]>

    - if <player.money.if_null[1000]> < <[volume]>:
      - narrate "<&e><[size]> <&c>Not enough money. This costs <&e><[volume]>"
      - playsound <player> sound:block_fire_extinguish
      - stop

    - if <[volume]> > 0:
      - money take quantity:<[volume]>
    - foreach <[cuboid].blocks.filter[advanced_matches[!*air]].sort_by_value[distance[<player.location>]]> as:block:
      - if <[block].material> !matches air:
        - if <[item_location]> == inventory:
          - give <[block].material.item> to:<player.inventory>
        - else if <[item_location]> == drop:
          - drop <[block].material.item> <[block]>
      - playsound <[block]> sound:<[block].material.block_sound_data.get[break_sound]>
      - playeffect <[block].center> effect:block_dust special_data:<[block].material> offset:0.25 quantity:5
      - modifyblock <[block]> air
      - wait 1t
