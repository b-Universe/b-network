##IgnoreWarning tag_trace_failure
##IgnoreWarning bad_tag_part
# lerp: Lerp between first and second location, at a certain percentage
# ease: ease between first and second location, at a certain percentage, with a specified type and direction
# cross_product: Get the cross product between two locations.
# plane_normal: Get a location that is a perpendicular normal vector formed from 3 points forming a plane.
# midpoint: Get the midpoint between two locations.
# perpendicular: Get a perpendicular point of any arbitrary length from three points.
# rotate_a_around_b: Rotate point a around point b a certain percentage. 1 == a full rotation, 0.5 is half a rotation. Rotates clockwise.
# slerp: Denizen style slerp between two points. Percentage is how much rotation there is, and tension is how close to a flat line it is. 0 is no tension, which is just a circle where it rotates about the midpoint, and as tension approaches infinity, it gets flatter and flatter. angle is the rotation of rotation, which informs on which plane we are rotating about.
# to_pitch_yaw: Takes a vector, normalizes it, and calculates the pitch/yaw, then reapplies it to the passed vector. This allows you to take a vector with no direction and give it a "forward" direction, so that you can use direction tags.
# rotate_around: Provide a point, and a direction vector that has a pitch/yaw, and rotate around. 0 == 1, and 0.5 is a half rotation around the center.
# rotation_range: Take a location, and return the same location with the pitch and yaw snapped to a offset. For example, if the you passed a yaw of 90, and the rotation was 92, then it would snap to 90. Pass a value of zero if you don't want it to snap.
# adjacent_blocks: Helper function that gets all the blocks adjacent to a location. Faster than using a .find function, since it's just doing some basic vector math. Does NOT return the location itself.
# surrounding_blocks: Helper function that gets all the blocks that surround a location, including corners. Does NOT return the location itself.

lib_cross_product:
    type: procedure
    debug: false
    definitions: a|b
    script:
        - determine <[a].with_x[<[a].y.*[<[b].z>].-[<[a].z.*[<[b].y>]>]>].with_y[<[a].z.*[<[b].x>].-[<[a].x.*[<[b].z>]>]>].with_z[<[a].x.*[<[b].y>].-[<[a].y.*[<[b].x>]>]>]>

lib_dot_product:
    type: procedure
    debug: false
    definitions: a|b
    script:
        - determine <[a].x.*[<[b].x>].+[<[a].y.*[<[b].y>]>].+[<[a].z.*[<[b].z>]>]>

lib_plane_normal:
    type: procedure
    debug: false
    definitions: a|b|c
    script:
        - define direction <[b].sub[<[a]>].proc[lib_cross_product].context[<[c].sub[<[a]>]>]>
        - determine <[direction].div[<[direction].length>].normalize>

lib_midpoint:
    type: procedure
    debug: false
    definitions: a|b
    script:
        - determine <[a].with_x[<[a].x.+[<[b].x>].*[0.5]>].with_y[<[a].y.+[<[b].y>].*[0.5]>].with_z[<[a].z.+[<[b].z>].*[0.5]>]>

lib_perpendicular:
    type: procedure
    debug: false
    definitions: a|b|c|length
    script:
        - determine <[a].proc[lib_midpoint].context[<[b]>].add[<[a].proc[lib_plane_normal].context[<[b]>|<[c]>].mul[<[length]>]>]>

lib_nlerp:
    type: procedure
    debug: false
    definitions: a|b|percent
    script:
        - determine <[a].proc[lib_lerp].context[<[b]>|<[percent]>].normalize>

lib_slerp:
    type: procedure
    debug: false
    definitions: a|b|center|percent
    script:
        - define c <[a].sub[<[center]>]>
        - define d <[b].sub[<[center]>]>
        - define omega <[c].proc[lib_dot_product].context[<[d]>].div[<[a].distance[<[center]>].power[2]>].acos>
        - define sin <[omega].sin>
        - determine <[center].add[<[c].mul[<element[1].-[<[percent]>].*[<[omega]>].sin./[<[sin]>]>]>].add[<[d].mul[<[percent].*[<[omega]>].sin./[<[sin]>]>]>]>

lib_lerp:
    type: procedure
    debug: false
    definitions: a|b|percent
    script:
        - determine <[a].mul[<[percent]>].add[<[b].mul[<element[1].sub[<[percent]>]>]>]>

lib_rotate_around:
    type: procedure
    debug: false
    definitions: center|axis|size|percent
    script:
        - determine <[center].with_pitch[<[axis].pitch>].with_yaw[<[axis].yaw>].left[<util.tau.mul[<[percent]>].cos.mul[<[size]>]>].up[<util.tau.mul[<[percent]>].sin.mul[<[size]>]>]>

lib_get_some_rotation_points:
    type: procedure
    debug: false
    definitions: value|start|end|axis|size|density|rate
    script:
        - repeat <[density].sub[1]> as:i:
            - define progress <[i].div[<[density]>]>
            - define points:->:<[start].proc[lib_lerp].context[<[end]>|<[progress]>].proc[lib_rotate_around].context[<[axis]>|<[size]>|<[value].sub[<[progress]>].div[<[rate]>]>]>
        - define points:->:<[start].proc[lib_rotate_around].context[<[axis]>|<[size]>|<[value].div[<[rate]>]>]>
        - determine <[points]>

lib_ease_location:
    type: procedure
    debug: false
    definitions: percent|a|b|type|dir
    script:
        - determine <[a]> if:<[percent].is_less_than_or_equal_to[0]>
        - determine <[b]> if:<[percent].is_more_than_or_equal_to[1]>
        - determine <[a].with_x[<proc[lib_ease].context[<[percent]>|<[type]>|<[dir]>|<[a].x>|<[b].x>]>].with_y[<proc[lib_ease].context[<[percent]>|<[type]>|<[dir]>|<[a].y>|<[b].y>]>].with_z[<proc[lib_ease].context[<[percent]>|<[type]>|<[dir]>|<[a].z>|<[b].z>]>]>

lib_to_pitch_yaw:
    type: procedure
    debug: false
    definitions: dir
    script:
        - define n <[dir].normalize>
        - determine <[dir].with_pitch[<[n].y.asin.to_degrees.mul[-1]>].with_yaw[<[n].z.atan2[<[n].x>].to_degrees.sub[90]>]>

lib_loc_in_box:
    type: procedure
    debug: false
    definitions: a|low|high
    script:
        - determine false if:<[low].x.is_less_than_or_equal_to[<[a].x>].and[<[high].x.is_more_than_or_equal_to[<[a].x>]>].not>
        - determine false if:<[low].y.is_less_than_or_equal_to[<[a].y>].and[<[high].y.is_more_than_or_equal_to[<[a].y>]>].not>
        - determine false if:<[low].z.is_less_than_or_equal_to[<[a].z>].and[<[high].z.is_more_than_or_equal_to[<[a].z>]>].not>
        - determine true

lib_rotation_snap:
    type: procedure
    debug: false
    definitions: a|pitch|yaw
    script:
        - determine <[a].with_pitch[<proc[lib_round_to].context[input=<[a].pitch>;to=<[pitch]>].if_null[<[a].pitch>]>].with_yaw[<proc[lib_round_to].context[input=<[a].yaw>;to=<[yaw]>].if_null[<[a].yaw>]>]>

lib_adjacent_blocks:
    type: procedure
    debug: false
    definitions: location
    script:
        - foreach <list[1,0,0|0,1,0|0,0,1|-1,0,0|0,-1,0|0,0,-1]>:
            - define result:->:<[location].add[<[value]>]>
        - determine <[result]>

lib_surrounding_blocks:
    type: procedure
    debug: false
    definitions: location
    script:
        - determine <[location].add[-1,-1,-1].to_cuboid[<[location].add[1,1,1]>].blocks.exclude[<[location]>]>


# map_range: Maps one range to another range, then returns a value based on the input provided. For example, if the starting range is 0 - 4, and the ending range is 0 - 100, and the input value was 2, the output value would return 50, as 2 is equidistant min it's starting and ending value as 50 is min it's starting and end value.
# cycle_value: Using a range, determines where the input should be, numerically cycles the value. For example, if you had a range of 0 - 360, and the input was 450, you'd recieve 90 back. as 450 is 360 + 90. Cycle value works no matter how many "cycles" have been made.
# numeric_list:  Returns a numeric list with a starting value of size 'size', counting up by 1 each time. For example, a list of 'start == 4' and 'size == 9' would be the list [4|5|6|7|8|9|10|11|12].
# farthest_from_zero: Returns a list containing the index and value of the value in the list that is farthestmin zero. If there is both a highest and lowest value that are equidistant (abs(x) == abs(y)), then bothvalues will be passed in the list, along with their respective indexes.
# normalize: Returns the list normalized. (ie, takes the farthest min zero in the list, makes that 1, thensquishes everything towards zero.)
# clamp: Clamps a value between a minimum and maximum value.
# sine_wave: Outputs a sine wave. Offset will offset the starting point of the wave, amplitude is the height of the wave, and frequency how often the wave oscilates. Input technically takes radians, meaning that inputting integer values will most likely move the sine wave too fast to be useful.
# sine_wave_increment: Outputs a sine wave in increments. Returns the amount the value will need to beincreased by for the sine wave, compared to the previous amount. Useful for the rotate command. Inputtechnically takes radians, meaning that inputting integer values will most likely move the sine wave too fastto be useful.
# ease: Ease script takes an ease type, direction, input, as well as an optional speed, range_min, and range_max. Input goes min 0 to 1, as well as speed, and range_min and range_max is a range in which you want the result to be mapped to. Both values must be passed for range to work. If no range is passed, output value goes min 0 to 1. When the ease has reached it's maximum value, returns false.
# romanize: Turn a decimal number into a roman numeral
# between: Helper function for when you want to create a random int between 1 and x. With the new proc syntax, you can use this very consicely; <[my_value].proc[between]>
# ordinal: Takes a number, like 5 or 104, and adds the st/nd/rd/th that would follow it. 5 -> 5th
# vanilla_breaking_time: Pass an item in, as well as the location of the block to determine how long it would take to break that item with the tool in hand.
# custom_breaking_time: Calculate a custom breaking time following Minecraft block breaking logic, based on the passed item, hardness of the block, and a map of valid tool_types. The map of valid tool_types should be formatted with the tool type as the key name, and the multiplier as the value.
# round_to: round to a specific number

lib_map_range:
    type: procedure
    debug: false
    definitions: input|in_start|in_end|out_start|out_end
    script:
        - determine <[input].sub[<[in_start]>].div[<[in_end].sub[<[in_start]>]>].mul[<[out_end].sub[<[out_start]>]>].add[<[out_start]>]>

lib_cycle_value:
    type: procedure
    debug: false
    definitions: input|min|max
    script:
        - if <[input]> < <[min]> || <[input]> > <[max]>:
            - define is_more <[input].is[MORE].than[<[max]>]>
            - define delta_1 <[max].sub[<[min]>].add[1]>
            - define delta_2 <[input].sub[<[is_more].if_true[<[max]>].if_false[<[min]>]>].div[<[delta_1]>].abs.round_up.mul[<[delta_1]>]>
            - determine <tern[<[is_more]>].pass[<[input].sub[<[delta_2]>]>].fail[<[input].add[<[delta_2]>]>]>
        - else:
            - determine <[input]>

lib_numeric_list:
    type: procedure
    debug: false
    definitions: min|max
    script:
        - if <[max]> < 0:
            #! -x -> -y
            - determine <util.list_numbers_to[<[min].mul[-1]>].get[<[max].mul[-1]>].to[last].reverse.parse[mul[-1]]>
        - else if <[max]> == 0 && <[min]> < 0:
            #! -x -> 0
            - determine <util.list_numbers_to[<[min].mul[-1]>].reverse.include[0].parse[mul[-1]]>
        - else if <[max]> > 0 && <[min]> < 0:
            #! -x -> +y
            - determine <util.list_numbers_to[<[min].mul[-1]>].reverse.include[0].parse[mul[-1]].include[<util.list_numbers_to[<[max]>]>]>
        - else if <[max]> == 0 && <[min]> == 0:
            #! 0 -> 0
            - determine <list[0]>
        - else if <[min]> == 0:
            #! 0 -> +y
            - determine <list[0].include[<util.list_numbers_to[<[max]>]>]>
        - else:
            #! +x -> +y
            - determine <util.list_numbers_to[<[max]>].get[<[min]>].to[<[max]>]>

lib_farthest_from_zero:
    type: procedure
    debug: false
    definitions: list_single
    script:
        - define list <[list_single].as_list>
        - define highest <[list].highest>
        - define lowest <[list].lowest>
        - define highest_abs <[highest].abs>
        - define lowest_abs <[lowest].abs>
        - determine <tern[<[highest_abs].is[==].to[<[lowest_abs]>]>].pass[<list[<[highest]>|<[lowest]>]>].fail[<tern[<[highest_abs].is[MORE].than[<[lowest_abs]>]>].pass[<list[<[highest]>|false]>].fail[<list[false|<[lowest]>]>]>]>

lib_normalize:
    type: procedure
    debug: false
    definitions: list_single
    script:
        - define list <[list_single].as_list>
        - define farthest_list <proc[lib_farthest_from_zero].context[<[list]>]>
        - determine <[list].parse[div[<[farthest_list].first.abs>]]>

lib_clamp:
    type: procedure
    debug: false
    definitions: input|min|max
    script:
        - determine <[input].min[<[max]>].max[<[min]>]>

lib_sine_wave:
    type: procedure
    debug: false
    definitions: input|offset|amplitude|frequency
    script:
        - define offset <tern[<[offset]||true>].pass[0].fail[<[offset]>]>
        - define amplitude <tern[<[amplitude]||true>].pass[1].fail[<[amplitude]>]>
        - define frequency <tern[<[frequency]||true>].pass[1].fail[<[frequency]>]>
        - determine <[input].add[<[offset]>].mul[<[frequency]>].sin.mul[<[amplitude]>]>

lib_sine_wave_increment:
    type: procedure
    debug: false
    definitions: input|offset|amplitude|frequency
    script:
        - define offset <tern[<[offset]||true>].pass[0].fail[<[offset]>]>
        - define amplitude <tern[<[amplitude]||true>].pass[1].fail[<[amplitude]>]>
        - define frequency <tern[<[frequency]||true>].pass[1].fail[<[frequency]>]>
        - determine <proc[sine_wave].context[<[input]>|<[offset]>|<[amplitude]>|<[frequency]>].sub[<proc[sine_wave].context[<[input].sub[<[frequency]>]>|<[offset]>|<[amplitude]>|<[frequency]>]>]>

lib_ease:
    type: procedure
    debug: false
    definitions: input|type|dir|range_min|range_max
    script:
        - define range_min <tern[<[range_min]||true>].pass[0].fail[<[range_min]>]>
        - define range_max <tern[<[range_max]||true>].pass[1].fail[<[range_max]>]>
        - if <[input]> < 1:
            - define result <proc[lib_core_ease].context[<[type].to_lowercase>|<[dir].to_lowercase>|<proc[lib_clamp].context[<[input]>|0|1]>]>
            - if <[range_min]> != 0 || <[range_max]> != 1:
                - define result <[result].proc[lib_map_range].context[0|1|<[range_min]>|<[range_max]>]>
        - else:
            - define result <[range_max].if_null[1]>
        - determine <[result]>

lib_catmull_rom_spline:
    type: procedure
    debug: false
    definitions: points|density|tension
    script:
        - define density 100 if:<[density].exists.not>
        - define tension 0.5 if:<[tension].exists.not>
        - if !<[density].is_integer>:
            - debug error "Density must be an integer."
        - else if !<[tension].is_decimal>:
            - debug error "Constant must be a number."
        #- else if <[tension]> > 1:
        #    - debug error "Constant must be less than or equal to 1."
        #- else if <[tension]> < 0:
        #    - debug error "Constant must be greater than or equal to 0."
        - else if !<[points].exists>:
            - debug error "There must be a list of points for a catmull spline."
        - else if <[points].filter[object_type.equals[location].not].size> > 0:
            - debug error "Your list of points must contain only location tags."
        - else if <[points].filter[world.equals[<[points].first.world>].not].size> > 0:
            - debug error "Your list of points must contain only locations from the same world."
        - else if <[points].size> < 2:
            - debug error "There must be at least 2 points for a catmull spline."
        - else if <[points].size> == 2:
            - determine <[points].first.points_between[<[points].last>].distance[<[points].first.distance[<[points].last>].div[<[density]>]>]>
        - else:
            # Pad spline with an extra point if there's only three points, since a catmull spline requires at least 4 points.
            - define points:->:<[points].last.add[0.000001,0.000001,0.000001]> if:<[points].size.equals[3]>
            # Pad beginning and end of spline with an extra point so that all points passed in by player are included.
            - define points    <[points].insert[<[points].first.sub[0.000001,0.000001,0.000001]>].at[1]>
            - define points:->:<[points].last.add[0.000001,0.000001,0.000001]>
            # Amount of times we need to run the catmull proc
            - define size      <[points].size.sub[3]>
            # Density per run of the catmull proc, based on the amount of runs, and the total amount of points requested.
            - define density   <[density].div[<[size]>].round>
            - repeat <[size]>:
                - define result:|:<proc[lib_core_catmull_rom_spline].context[<[points].get[<[value]>]>|<[points].get[<[value].add[1]>]>|<[points].get[<[value].add[2]>]>|<[points].get[<[value].add[3]>]>|<[density]>|<[tension]>]>
            - determine <[result]>

lib_romanize:
    type: procedure
    debug: false
    definitions: number
    script:
        - foreach <script[lib_generic_data].data_key[roman].to_map>:
            - while <[number]> >= <[value]>:
                - define number:-:<[value]>
                - define result <[result].if_null[]><[key]>
        - determine <[result]>

lib_lerp_numeric:
    type: procedure
    debug: false
    definitions: from|to|percentage
    script:
        - determine <[percentage].mul[<[to].sub[<[from]>]>].add[<[from]>]>

lib_ordinal:
    type: procedure
    debug: false
    definitions: number
    script:
        - determine <[number]><[number].is_more_than[10].and[<[number].is_less_than[20]>].if_true[th].if_false[<[number].char_at[<[number].length>].equals[1].if_true[st].if_false[<[number].char_at[<[number].length>].equals[2].if_true[nd].if_false[<[number].char_at[<[number].length>].equals[3].if_true[rd].if_false[th]>]>]>]>

lib_vanilla_breaking_time:
    type: procedure
    debug: false
    definitions: item|location
    script:
        - define loc_material <[location].material>
        - define hardness     <[loc_material].hardness>
        - if <[hardness]> == -1:
            - determine <util.int_max>
        - else if <[hardness]> == 0:
            - determine 0
        - else:
            - define mat_name <[item].material.name>
            - if <[mat_name]> == air:
                - define speed 1
            - else:
                - define tool_type <[mat_name].after_last[_]>
                - define tool_type <[mat_name]> if:<[tool_type].equals[<empty>]>
                - if <[tool_type]> == sword:
                    - if <[loc_material].name> == cobweb:
                        - define speed 15
                        - define can_harvest true
                    - else:
                        - define speed 1.5
                - else if <[tool_type]> == shears:
                    - if <[loc_material].advanced_matches[cobweb|*leaves]>:
                        - define speed 15
                        - define can_harvest true
                    - else if <[loc_material].advanced_matches[*wool]>:
                        - define speed 5
                        - define can_harvest true
                    - else:
                        - define speed 1.5
                - else if <[loc_material]> in <server.vanilla_tagged_materials[mineable/<[tool_type]>].if_null[<list>]>:
                    - define speed <script[lib_generic_data].data_key[tool_speed.<[mat_name].before[_]>]>
                    - define can_harvest true
                - else:
                    - define speed 1
            - define can_harvest <[location].drops[<[item]>].is_empty.not> if:<[can_harvest].exists.not>
            - define efficiency_lvl <[item].enchantment_map.get[efficiency].if_null[0]>
            - if <[can_harvest]> and <[efficiency_lvl]> > 0:
                - define speed:+:<[efficiency_lvl].mul[<[efficiency_lvl]>].add[1]>
            - if <player.has_effect[fast_digging]>:
                - define speed:*:<player.list_effects.filter[starts_with[fast_digging]].first.after[,].before[,].mul[0.2].add[1]>
            - if <player.has_effect[slow_digging]>:
                - define level <player.list_effects.filter[starts_with[slow_digging]].first.after[,].before[,]>
                - define speed:*:<[level].equals[0].if_true[0.3].if_false[<[level].equals[1].if_true[0.09].if_false[<[level].equals[2].if_true[0.0027].if_false[0.00081]>]>]>
            - if <player.eye_location.material.advanced_matches[*water]> and !<player.equipment_map.get[helmet].if_null[false].enchantment_map.get[aqua_affinity].exists>:
                - define speed:/:5
            - if !<player.is_on_ground>:
                - define speed:/:5
            - define damage <[speed].div[<[loc_material].hardness>].mul[<[can_harvest].if_true[0.0333333].if_false[0.01]>]>
            - determine 0 if:<[damage].is_more_than[1]>
            - determine <element[1].div[<[damage]>].round_up.div[20]>

# [input=#,to=#]
lib_round_to:
    type: procedure
    debug: false
    definitions: map
    script:
        - define map <[map].as_map>
        - determine <[map.input].div[<[map.to]>].round.mul[<[map.to]>]>

#all the eases used for the front facing easing proc. Math is kept here for simplicity
lib_core_ease:
    type: procedure
    debug: false
    definitions: type|dir|dt
    script:
        # ~ ~ ~ Eases; based on work from https://easings.net/ ~ ~ ~ #
        - define ease_conf <script[lib_generic_data].data_key[ease]>
        - if <[ease_conf].get[type].contains[<[type]>]> && <[ease_conf].get[dir].contains[<[dir]>]>:
            - define concat <[type]>_<[dir]>
        - choose <[concat]>:
            - case sine_in:
                - determine <element[1].sub[<[dt].mul[<util.pi>].div[2].cos>]>
            - case sine_out:
                - determine <[dt].mul[<util.pi>].div[2].sin>
            - case sine_inout sine_in-out sine_in_out:
                - determine <[dt].mul[<util.pi>].cos.sub[1].div[2].mul[-1]>
            - case quad_in:
                - determine <[dt].power[2]>
            - case quad_out:
                - determine <element[1].sub[<element[1].sub[<[dt]>].power[2]>]>
            - case quad_inout quad_in-out quad_in_out:
                - determine <tern[<[dt].is[LESS].than[.5]>].pass[<element[2].mul[<[dt]>].mul[<[dt]>]>].fail[<element[1].sub[<[dt].mul[-2].add[2].power[2].div[2]>]>]>
            - case cubic_in:
                - determine <[dt].power[3]>
            - case cubic_out:
                - determine <element[1].sub[<element[1].sub[<[dt]>].power[3]>]>
            - case cubic_inout cubic_in-out cubic_in_out:
                - determine <[dt].is_less_than[0.5].if_true[<element[4].mul[<[dt]>].mul[<[dt]>].mul[<[dt]>]>].if_false[<element[1].sub[<[dt].mul[-2].add[2].power[3].div[2]>]>]>
            - case quart_in:
                - determine <[dt].power[4]>
            - case quart_out:
                - determine <element[1].sub[<element[1].sub[<[dt]>].power[4]>]>
            - case quart_inout quart_in-out quart_in_out:
                - determine <tern[<[dt].is[LESS].than[.5]>].pass[<element[8].mul[<[dt]>].mul[<[dt]>].mul[<[dt]>].mul[<[dt]>]>].fail[<element[1].sub[<[dt].mul[-2].add[2].power[4].div[2]>]>]>
            - case quint_in:
                - determine <[dt].power[5]>
            - case quint_out:
                - determine <element[1].sub[<element[1].sub[<[dt]>].power[5]>]>
            - case quint_inout quint_in-out quint_in_out:
                - determine <tern[<[dt].is[LESS].than[.5]>].pass[<element[16].mul[<[dt]>].mul[<[dt]>].mul[<[dt]>].mul[<[dt]>].mul[<[dt]>]>].fail[<element[1].sub[<[dt].mul[-2].add[2].power[5].div[2]>]>]>
            - case exp_in:
                - determine <tern[<[dt].is[==].to[0]>].pass[0].fail[<element[2].power[<[dt].mul[10].sub[10]>]>]>
            - case exp_out:
                - determine <tern[<[dt].is[==].to[1]>].pass[1].fail[<element[1].sub[<element[2].power[<[dt].mul[-10]>]>]>]>
            - case exp_inout exp_in-out exp_in_out:
                - determine <tern[<[dt].is[==].to[0]>].pass[0].fail[<tern[<[dt].is[==].to[1]>].pass[1].fail[<tern[<[dt].is[LESS].than[.5]>].pass[<element[2].power[<[dt].mul[20].sub[10]>].div[2]>].fail[<element[2].sub[<element[2].power[<[dt].mul[-20].add[10]>]>].div[2]>]>]>]>
            - case circ_in:
                - determine <element[1].sub[<element[1].sub[<[dt].power[2]>].sqrt>]>
            - case circ_out:
                - determine <element[1].sub[<[dt].sub[1].power[2]>].sqrt>
            - case circ_inout circ_in-out circ_in_out:
                - determine <[dt].is_less_than[0.5].if_true[<element[1].sub[<element[1].sub[<[dt].mul[2].power[2]>].sqrt>].div[2]>].if_false[<element[1].sub[<[dt].mul[-2].add[2].power[2]>].sqrt.add[1].div[2]>]>
            - case back_in:
                - determine <[ease_conf].get[C3].mul[<[dt]>].mul[<[dt]>].mul[<[dt]>].sub[<[ease_conf].get[C1].mul[<[dt]>].mul[<[dt]>]>]>
            - case back_out:
                - determine <[dt].sub[1].power[3].mul[<[ease_conf].get[C3]>].add[1].add[<[dt].sub[1].power[2].mul[<[ease_conf].get[C1]>]>]>
            - case back_inout back_in-out back_in_out:
                - determine <tern[<[dt].is[LESS].than[.5]>].pass[<[dt].mul[2].power[2].mul[<[ease_conf].get[C2A].mul[2].mul[<[dt]>].sub[<[ease_conf].get[C2]>]>].div[2]>].fail[<[dt].mul[2].sub[2].power[2].mul[<[ease_conf].get[C2A].mul[<[dt].mul[2].sub[2]>].add[<[ease_conf].get[C2]>]>].add[2].div[2]>]>
            - case elastic_in:
                - determine <tern[<[dt].is[==].to[0]>].pass[0].fail[<tern[<[dt].is[==].to[1]>].pass[1].fail[<element[2].power[<[dt].mul[10].sub[10]>].mul[-1].mul[<[dt].mul[10].sub[10.75].mul[<[ease_conf].get[C4]>].sin>]>]>]>
            - case elastic_out:
                - determine <tern[<[dt].is[==].to[0]>].pass[0].fail[<tern[<[dt].is[==].to[1]>].pass[1].fail[<element[2].power[<[dt].mul[-10]>].mul[<[dt].mul[10].sub[.75].mul[<[ease_conf].get[C4]>].sin>].add[1]>]>]>
            - case elastic_inout elastic_in-out elastic_in_out:
                - determine <tern[<[dt].is[==].to[0]>].pass[0].fail[<tern[<[dt].is[==].to[1]>].pass[1].fail[<tern[<[dt].is[LESS].than[.5]>].pass[<element[2].power[<[dt].mul[20].sub[10]>].mul[<[dt].mul[20].sub[11.125].mul[<[ease_conf].get[C5]>].sin>].mul[-1].div[2]>].fail[<element[2].power[<[dt].mul[-20].add[10]>].mul[<[dt].mul[20].sub[-11.125].mul[<[ease_conf].get[C5]>].sin>].div[2].add[1]>]>]>]>
            - case bounce_in:
                - determine <element[1].sub[<proc[lib_core_bo].context[<element[1].sub[<[dt]>]>]>]>
            - case bounce_out:
                - determine <proc[lib_core_bo].context[<[dt]>]>
            - case bounce_inout bounce_in-out bounce_in_out:
                - determine <tern[<[dt].is[LESS].than[.5]>].pass[<element[1].sub[<proc[lib_core_bo].context[<element[1].sub[<[dt].mul[2]>]>]>].div[2]>].fail[<proc[lib_core_bo].context[<[dt].mul[2].sub[1]>].add[1].div[2]>]>
            - case default:
                - debug error "An error occurred!"
                - determine false

lib_core_catmull_rom_spline:
    type: procedure
    debug: false
    definitions: p1|p2|p3|p4|density|constant
    script:
        - define constant <[constant].mul[0.5]>
        - define t1 <[p2].x.sub[<[p1].x>].power[2].add[<[p2].y.sub[<[p1].y>].power[2]>].add[<[p2].z.sub[<[p1].z>].power[2]>].sqrt.power[<[constant]>]>
        - define t2 <[p3].x.sub[<[p2].x>].power[2].add[<[p3].y.sub[<[p2].y>].power[2]>].add[<[p3].z.sub[<[p2].z>].power[2]>].sqrt.power[<[constant]>].add[<[t1]>]>
        - define t3 <[p4].x.sub[<[p3].x>].power[2].add[<[p4].y.sub[<[p3].y>].power[2]>].add[<[p4].z.sub[<[p3].z>].power[2]>].sqrt.power[<[constant]>].add[<[t2]>]>
        - define c <[t2].sub[<[t1]>].div[<[density]>]>
        - repeat <[density]>:
            - define t:->:<[t1].add[<[c].mul[<[value]>]>]>
        - define c <[t1]>
        - foreach <[t]>:
            - define A1:->:<[p1].mul[<[t1].sub[<[value]>].div[<[c]>]>].add[<[p2].mul[<[value].div[<[c]>]>]>]>
        - define c <[t2].sub[<[t1]>]>
        - foreach <[t]>:
            - define A2:->:<[p2].mul[<[t2].sub[<[value]>].div[<[c]>]>].add[<[p3].mul[<[value].sub[<[t1]>].div[<[c]>]>]>]>
        - define c <[t3].sub[<[t2]>]>
        - foreach <[t]>:
            - define A3:->:<[p3].mul[<[t3].sub[<[value]>].div[<[c]>]>].add[<[p4].mul[<[value].sub[<[t2]>].div[<[c]>]>]>]>
        - define c <[t2]>
        - foreach <[t]>:
            - define B1:->:<[A1].get[<[loop_index]>].mul[<[t2].sub[<[value]>].div[<[c]>]>].add[<[A2].get[<[loop_index]>].mul[<[value].div[<[c]>]>]>]>
        - define c <[t3].sub[<[t1]>]>
        - foreach <[t]>:
            - define B2:->:<[A2].get[<[loop_index]>].mul[<[t3].sub[<[value]>].div[<[c]>]>].add[<[A3].get[<[loop_index]>].mul[<[value].sub[<[t1]>].div[<[c]>]>]>]>
        - define c <[t2].sub[<[t1]>]>
        - foreach <[t]>:
            - define C1:->:<[B1].get[<[loop_index]>].mul[<[t2].sub[<[value]>].div[<[c]>]>].add[<[B2].get[<[loop_index]>].mul[<[value].sub[<[t1]>].div[<[c]>]>]>]>
        - determine <[C1]>

#Used in the bounce in, out and inout of the easing script
lib_core_bo:
    type: procedure
    debug: false
    definitions: value
    script:
        - determine <tern[<[value].is[LESS].than[.363636363]>].pass[<element[7.5625].mul[<[value]>].mul[<[value]>]>].fail[<tern[<[value].is[LESS].than[.727272727]>].pass[<element[7.5625].mul[<[value].sub[.5454545]>].mul[<[value].sub[.5454545]>].add[.75]>].fail[<tern[<[value].is[LESS].than[.909090909]>].pass[<element[7.5625].mul[<[value].sub[.81818181]>].mul[<[value].sub[.81818181]>].add[0.9375]>].fail[<element[7.5625].mul[<[value].sub[.95454545]>].mul[<[value].sub[.95454545]>].add[0.984375]>]>]>]>

#Gets an error type from core/data, and the name of the script calling the proc
#so it can print out errors. Also takes unlisted arguments that are change depending
#on the error.
lib_core_command_error:
    type: procedure
    debug: false
    definitions: err_type|usage_name
    script:
        - define color <script[lib_config].parsed_key[color]>
        - define usage_loc <script[lib_generic_data].data_key[command.usage.<[usage_name]>].if_null[true].if_true[<proc[<[usage_name]>]>].if_false[<proc[lib_command_usage].context[lib_generic_data|command.usage.<[usage_name]>]>]>
        - determine <[color].get[error]><script[lib_generic_data].parsed_key[command.error.<[err_type]>]><list[permission|implicit|invalid_player].contains[<[err_type]>].not.if_true[<[color].get[error]><&nl>Usage<&co><&nl><[usage_loc]>].if_false[]>

#Like <ListTag.formatted> but it colors the text and commas.
lib_core_command_extra_keys:
    type: procedure
    debug: false
    definitions: list
    script:
        - define clr    <script[lib_config].parsed_key[color]>
        - define soft   <[clr].get[soft_server_notice]>
        - define hard   <[clr].get[hard_server_notice]>
        - define last   <[list].size>
        - define s_last <[list].size.sub[1]>
        - foreach <[list]>:
            - define result "<[result].if_null[]><[soft]><[value]><[loop_index].equals[<[s_last]>].if_true[ and ].if_false[<[loop_index].equals[<[last]>].if_true[<[hard]>.].if_false[<[hard]>, ]>]>"
        - determine <[result]>

# --------------------DATA SCRIPTS-------------------- #

lib_generic_data:
    type: data
    alphabet_set: abcdefghijklmnopqrstuvwxyz
    number_set: 0123456789
    phi: 1.618033988749895
    epsilon: 0.0000000000000000000000000000000000000000000000000000000000000001
    ease:
        dir:
            - in
            - out
            - inout
            - in_out
            - in-out
        type:
            - sine
            - quad
            - cubic
            - quart
            - quint
            - exp
            - circ
            - back
            - elastic
            - bounce
        C1: 1.70158
        C2: 2.5949095
        C2A: 3.5949095
        C3: 2.70158
        C4: 2.0943951
        C5: 1.3962634
    tool_speed:
        wooden: 2
        stone: 4
        iron: 6
        diamond: 8
        netherite: 9
        golden: 12
    note_to_color:
        - 0
        - 0.042
        - 0.083
        - 0.125
        - 0.167
        - 0.208
        - 0.250
        - 0.292
        - 0.333
        - 0.375
        - 0.417
        - 0.458
        - 0.5
        - 0.542
        - 0.583
        - 0.625
        - 0.667
        - 0.708
        - 0.750
        - 0.792
        - 0.833
        - 0.875
        - 0.917
        - 0.958
        - 1
    note_to_pitch:
        - 0.5
        - 0.529732
        - 0.561231
        - 0.594604
        - 0.629961
        - 0.667420
        - 0.707107
        - 0.749154
        - 0.793701
        - 0.840896
        - 0.890899
        - 0.943874
        - 1
        - 1.059463
        - 1.122462
        - 1.189207
        - 1.259921
        - 1.334840
        - 1.414214
        - 1.498307
        - 1.587401
        - 1.681793
        - 1.781797
        - 1.887749
        - 2
    instruments:
        - banjo
        - basedrum
        - bass
        - bell
        - bit
        - chime
        - cow_bell
        - didgeridoo
        - flute
        - guitar
        - harp
        - hat
        - iron_xylophone
        - pling
        - snare
        - xylophone
    roman:
        - M/1000
        - CM/900
        - D/500
        - CD/400
        - C/100
        - XC/90
        - L/50
        - XL/40
        - X/10
        - IX/9
        - V/5
        - IV/4
        - I/1
    attributes:
        wooden_sword:
            slot: hand
            attack_speed: 1.6
            attack_damage: 4
        stone_sword:
            slot: hand
            attack_speed: 1.6
            attack_damage: 5
        iron_sword:
            slot: hand
            attack_speed: 1.6
            attack_damage: 6
        golden_sword:
            slot: hand
            attack_speed: 1.6
            attack_damage: 4
        diamond_sword:
            slot: hand
            attack_speed: 1.6
            attack_damage: 7
        netherite_sword:
            slot: hand
            attack_speed: 1.6
            attack_damage: 8
        wooden_pickaxe:
            slot: hand
            attack_speed: 1.2
            attack_damage: 2
        stone_pickaxe:
            slot: hand
            attack_speed: 1.2
            attack_damage: 3
        iron_pickaxe:
            slot: hand
            attack_speed: 1.2
            attack_damage: 4
        golden_pickaxe:
            slot: hand
            attack_speed: 1.2
            attack_damage: 2
        diamond_pickaxe:
            slot: hand
            attack_speed: 1.2
            attack_damage: 5
        netherite_pickaxe:
            slot: hand
            attack_speed: 1.2
            attack_damage: 6
        wooden_hoe:
            slot: hand
            attack_speed: 1
            attack_damage: 1
        stone_hoe:
            slot: hand
            attack_speed: 2
            attack_damage: 1
        iron_hoe:
            slot: hand
            attack_speed: 3
            attack_damage: 1
        golden_hoe:
            slot: hand
            attack_speed: 1
            attack_damage: 1
        diamond_hoe:
            slot: hand
            attack_speed: 4
            attack_damage: 1
        netherite_hoe:
            slot: hand
            attack_speed: 4
            attack_damage: 1
        wooden_shovel:
            slot: hand
            attack_speed: 1
            attack_damage: 2.5
        stone_shovel:
            slot: hand
            attack_speed: 1
            attack_damage: 3.5
        iron_shovel:
            slot: hand
            attack_speed: 1
            attack_damage: 4.5
        golden_shovel:
            slot: hand
            attack_speed: 1
            attack_damage: 2.5
        diamond_shovel:
            slot: hand
            attack_speed: 1
            attack_damage: 5.5
        netherite_shovel:
            slot: hand
            attack_speed: 1
            attack_damage: 6.5
        wooden_axe:
            slot: hand
            attack_speed: 0.8
            attack_damage: 7
        stone_axe:
            slot: hand
            attack_speed: 0.8
            attack_damage: 9
        iron_axe:
            slot: hand
            attack_speed: 0.9
            attack_damage: 9
        golden_axe:
            slot: hand
            attack_speed: 1
            attack_damage: 7
        diamond_axe:
            slot: hand
            attack_speed: 1
            attack_damage: 9
        netherite_axe:
            slot: hand
            attack_speed: 1
            attack_damage: 10
        leather_helmet:
            slot: head
            armor: 1
        leather_chestplate:
            slot: chest
            armor: 2
        leather_leggings:
            slot: legs
            armor: 3
        leather_boots:
            slot: feet
            armor: 1
        chainmail_helmet:
            slot: head
            armor: 2
        chainmail_chestplate:
            slot: chest
            armor: 5
        chainmail_leggings:
            slot: legs
            armor: 4
        chainmail_boots:
            slot: feet
            armor: 2
        iron_helmet:
            slot: head
            armor: 2
        iron_chestplate:
            slot: chest
            armor: 6
        iron_leggings:
            slot: legs
            armor: 5
        iron_boots:
            slot: feet
            armor: 2
        golden_helmet:
            slot: head
            armor: 2
        golden_chestplate:
            slot: chest
            armor: 5
        golden_leggings:
            slot: legs
            armor: 3
        golden_boots:
            slot: feet
            armor: 1
        diamond_helmet:
            slot: head
            armor: 3
            armor_toughness: 2
        diamond_chestplate:
            slot: chest
            armor: 8
            armor_toughness: 2
        diamond_leggings:
            slot: legs
            armor: 6
            armor_toughness: 2
        diamond_boots:
            slot: feet
            armor: 3
            armor_toughness: 2
        netherite_helmet:
            slot: head
            armor: 3
            armor_toughness: 2
            knockback_resistance: 1
        netherite_chestplate:
            slot: chest
            armor: 8
            armor_toughness: 2
            knockback_resistance: 1
        netherite_leggings:
            slot: legs
            armor: 6
            armor_toughness: 2
            knockback_resistance: 1
        netherite_boots:
            slot: feet
            armor: 3
            armor_toughness: 2
            knockback_resistance: 1
    face_to_vec:
        up: 0,1,0
        down: 0,-1,0
        north: 0,0,-1
        south: 0,0,1
        east: 1,0,0
        west: -1,0,0
        southeast: 1,0,1
        southwest: -1,0,1
        northeast: 1,0,-1
        northwest: -1,0,-1
    mob_xp_rates:
        bat:
            min: 0
            max: 0
        snow_golem:
            min: 0
            max: 0
        villager:
            min: 0
            max: 0
        wandering_trader:
            min: 0
            max: 0
        axolotl:
            min: 1
            max: 3
        cat:
            min: 1
            max: 3
        chicken:
            min: 1
            max: 3
        cod:
            min: 1
            max: 3
        cow:
            min: 1
            max: 3
        donkey:
            min: 1
            max: 3
        fox:
            min: 1
            max: 3
        glow_squid:
            min: 1
            max: 3
        horse:
            min: 1
            max: 3
        mooshroom:
            min: 1
            max: 3
        ocelot:
            min: 1
            max: 3
        parrot:
            min: 1
            max: 3
        pig:
            min: 1
            max: 3
        pufferfish:
            min: 1
            max: 3
        rabbit:
            min: 1
            max: 3
        salmon:
            min: 1
            max: 3
        sheep:
            min: 1
            max: 3
        squid:
            min: 1
            max: 3
        tropical_fish:
            min: 1
            max: 3
        turtle:
            min: 1
            max: 3
        zombie_horse:
            min: 1
            max: 3
        strider:
            min: 1
            max: 2
        iron_golem:
            min: 0
            max: 0
        zombified_piglin:
            min: 5
            max: 5
        baby_zombified_piglin:
            min: 12
            max: 12
        bee:
            min: 1
            max: 3
        dolphin:
            min: 1
            max: 3
        goat:
            min: 1
            max: 3
        llama:
            min: 1
            max: 3
        panda:
            min: 1
            max: 3
        polar_bear:
            min: 1
            max: 3
        trader_llama:
            min: 1
            max: 3
        wolf:
            min: 1
            max: 3
        cave_spider:
            min: 5
            max: 5
        enderman:
            min: 5
            max: 5
        piglin:
            min: 5
            max: 5
        spider:
            min: 5
            max: 5
        baby_zombie:
            min: 12
            max: 12
        blaze:
            min: 10
            max: 10
        evoker:
            min: 10
            max: 10
        elder_guardian:
            min: 10
            max: 10
        guardian:
            min: 10
            max: 10
        ridden_chicken:
            min: 22
            max: 22
        creeper:
            min: 5
            max: 5
        drowned:
            min: 5
            max: 5
        baby_drowned:
            min: 12
            max: 12
        ghast:
            min: 5
            max: 5
        hoglin:
            min: 5
            max: 5
        husk:
            min: 5
            max: 5
        baby_husk:
            min: 12
            max: 12
        illusioner:
            min: 5
            max: 5
        phantom:
            min: 5
            max: 5
        pillager:
            min: 5
            max: 5
        shulker:
            min: 5
            max: 5
        silverfish:
            min: 5
            max: 5
        skeleton:
            min: 5
            max: 5
        stray:
            min: 5
            max: 5
        vex:
            min: 5
            max: 5
        vindicator:
            min: 5
            max: 5
        witch:
            min: 5
            max: 5
        wither_skeleton:
            min: 5
            max: 5
        zombie:
            min: 5
            max: 5
        zombie_villager:
            min: 5
            max: 5
        baby_zombie_villager:
            min: 12
            max: 12
        zoglin:
            min: 5
            max: 5
        ender_dragon:
            min: 12000
            max: 12000
        summoned_ender_dragon:
            min: 500
            max: 500
        endermite:
            min: 3
            max: 3
        skeleton_horse:
            min: 1
            max: 3
        ridden_skeleton_horse:
            min: 11
            max: 13
        large_slime:
            min: 4
            max: 4
        large_magma_cube:
            min: 4
            max: 4
        medium_slime:
            min: 2
            max: 2
        medium_magma_cube:
            min: 2
            max: 2
        small_slime:
            min: 1
            max: 1
        small_magma_cube:
            min: 1
            max: 1
        ridden_spider:
            min: 10
            max: 10
        ridden_cave_spider:
            min: 10
            max: 10
        ravager:
            min: 20
            max: 20
        piglin_brute:
            min: 20
            max: 20
        wither:
            min: 50
            max: 50
    command:
        usage:
            panic: /panic
            end_queues: /end_queues
            puppet: /puppet (<&lt>name<&gt>)
            simple_permissions: /perm [action:{set}/clear/view] [node:<&lt>permission_name<&gt>] (name:<&lt>player_name<&gt>)
            remove_flags: /remove_flags [action:{player}/server/all] (name:<&lt>player_name<&gt>)
            remove_notables: /remove_notables [type:{all}/location/cuboid/ellipsoid/inventory]
            random_placement: /random_placer (action:{set}/clear) (block:<&lt>name<&gt>) (weight:<&lt>amount<&gt>)
            notable_tool: /notable_tool (action:{save}/clear) (save:<&lt>name<&gt>)
            denchant: /denchant [<&lt>name<&gt>] ({1}/<&lt>amount<&gt>)
        error:
            permission: I<&sq>m sorry, but you do not have permission to perform this command. Please contact the server administrators if you believe that this is in error.
            wrong_args: Command was run with the incorrect amount of arguments! Expected<&co> <[color].get[soft_server_notice]><[3]><[color].get[error]>; Recieved<&co> <[color].get[soft_server_notice]><[4]>
            min_args: Too few arguments were passed! Expected at least<&co> <[color].get[soft_server_notice]><[3]><[color].get[error]>; Recieved<&co> <[color].get[soft_server_notice]><[4]>
            max_args: Too many arguments were passed! Expected at most<&co> <[color].get[soft_server_notice]><[3]><[color].get[error]>; Recieved<&co> <[color].get[soft_server_notice]><[4]>
            extra_keys: Found unrecogonized keys; <[3]>
            missing_keys: Found values with no keys; <[3]>
            implicit: Unable to use implicit player context. Are you running this through the server console or a command block?
            invalid_player: Unable to find player <[color].get[hard_server_notice]>'<[color].get[soft_server_notice]><[3]><[color].get[hard_server_notice]>'<[color].get[error]>.
            invalid_value: <[color].get[soft_server_notice]><[4]><[color].get[error]> is not a valid <[color].get[soft_server_notice]><[3]><[color].get[error]>!
    block_placing:
        - ancient_debris
        - anvil
        - bamboo
        - bamboo_sapling
        - basalt
        - bone_block
        - chain
        - coral_block
        - fungus
        - gilded_blackstone
        - glass
        - grass
        - gravel
        - honey_block
        - ladder
        - lantern
        - lily_pad
        - lodestone
        - metal
        - nether_bricks
        - gold_ore
        - nether_ore
        - netherite_block
        - netherrack
        - nylium
        - roots
        - sand
        - scaffolding
        - shroomlight
        - slime_block
        - snow
        - soul_sand
        - soul_soil
        - stem
        - stone
        - sweet_berry_bush
        - wart_block
        - wet_grass
        - wood
        - wool
    dye_hex_colors:
        black: 000000
        red: B02E26
        green: 5E7C16
        brown: 835432
        blue: 3C44AA
        purple: 8932B8
        cyan: 169C9C
        light_gray: 9D9D97
        gray: 474F52
        pink: F38BAA
        lime: 80C71F
        yellow: FED83D
        light_blue: 3AB3DA
        magenta: C74EBD
        orange: F9801D
        white: FFFFFF
    vanilla_enchantment_map:
        aqua_affinity: 1
        bane_of_arthropods: 5
        binding_curse: 1
        blast_protection: 4
        channeling: 1
        depth_strider: 3
        efficiency: 5
        feather_falling: 4
        fire_aspect: 2
        fire_protection: 4
        flame: 1
        fortune: 3
        frost_walker: 2
        impaling: 5
        infinity: 1
        knockback: 2
        looting: 3
        loyalty: 3
        luck_of_the_sea: 3
        lure: 3
        mending: 1
        multishot: 1
        piercing: 4
        power: 5
        projectile_protection: 4
        protection: 4
        punch: 2
        quick_charge: 3
        respiration: 3
        riptide: 3
        sharpness: 5
        silk_touch: 1
        smite: 5
        soul_speed: 3
        sweeping: 3
        thorns: 3
        unbreaking: 3
        vanishing_curse: 1
    duration:
        t: tick
        s: second
        m: minute
        h: hour
        d: day
        w: week
        y: year
