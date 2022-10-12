# Sorts chests by clicking buttons adjacent to them
# Made by Mergu
# This can probably be more efficient, but I don't care! This is optimized for readability and maintainability!
# Have a suggestion? Feel free to shoot me a ping!
# Make sure to update Denizen if you run into problems.

# First step is to merge everything into a list of unique exact-matching items
# This will return items with quantities potentially over 64, meant to be split up later
stack_items:
  type: procedure
  debug: false
  definitions: items
  script:
    - define item_map <map>
    - foreach <[items]> as:item:
      - if <[item].quantity> <= <[item].max_stack>:
        - define item_map.<[item].with[quantity=1].escaped>:+:<[item].quantity>
      - else:
        # Handle stacks of unstackable items... just in case
        # Make sure we do not combine stacks of unstackables into even bigger stacks
        - define item_map.<[item].with_flag[nostack_removeme:<util.random_uuid>].escaped> <[item].quantity>
    - define stacked_items <list>
    - foreach <[item_map]> key:esc_item as:quantity:
      - define stacked_items:->:<[esc_item].unescaped.as_item.with[quantity=<[quantity]>]>
    - determine <[stacked_items]>

# Do the sorting. Purely alphabetical is awful, so bucket like items together and then sort each bucket.
# The order here is very much up to the implementer, feel free to prioritize different things.
# Most buckets are sorted based on a reversed material name, since most similar items end with the same suffix (_door, _button, etc)
sort_items:
  type: procedure
  debug: false
  definitions: items
  script:
    - define buckets <map>
    - foreach <[items]> as:item:
      - define mat <[item].material>
      - if <[mat].name> == air:
        - foreach next
      - if <[mat].is_occluding>:
        - define buckets.occluding:->:<[item]>
      - else if <[mat].vanilla_tags.contains[slabs]>:
        - define buckets.slabs:->:<[item]>
      - else if <[mat].is_solid>:
        - define buckets.solid:->:<[item]>
      - else if <[mat].is_block>:
        - define buckets.placeable:->:<[item]>
      - else if <[mat].max_durability> > 0:
        - define buckets.durable:->:<[item]>
      - else if <[mat].is_edible>:
        - define buckets.edible:->:<[item]>
      - else if <[mat].vanilla_tags.contains[flowers]>:
        - define buckets.flowers:->:<[item]>
      - else:
        - define buckets.misc:->:<[item]>
    - define sorted <list>
    - foreach occluding|slabs|solid|placeable|durable|edible|flowers|misc as:category:
      - if !<[buckets].contains[<[category]>]>:
        - foreach next
      - define grouped_items <[buckets].get[<[category]>]>
      - if <[grouped_items].size> <= 1:
        - define sorted:|:<[grouped_items]>
      - else if <[category]> == durable:
        - define sorted:|:<[grouped_items].sort_by_value[material.name]>
      - else:
        - define sorted:|:<[grouped_items].sort_by_value[material.name.split[_].reverse.separated_by[_]]>
    - determine <[sorted]>

# Expand the stacks out, except for items that were identified as unstackably stacked
unstack_items:
  type: procedure
  debug: false
  definitions: items
  script:
    - define unstacked <list>
    - foreach <[items]> as:item:
      - if <[item].has_flag[nostack_removeme]>:
        - define unstacked:->:<[item].with_flag[nostack_removeme:!]>
        - foreach next
      - while <[item].quantity> > <[item].max_stack>:
        - define unstacked:->:<[item].with[quantity=<[item].max_stack>]>
        - define item <[item].with[quantity=<[item].quantity.sub[<[item].max_stack>]>]>
      - define unstacked:->:<[item]>
    - determine <[unstacked]>

sort_chest_events:
  type: world
  debug: false
  events:
    on player right clicks *_button:
      - stop if:<context.location.switched.if_null[false]>
      - wait 1t
      - define valid_invs:|:shulker_box|chest|barrel
      - define locs <context.location.center.find_blocks.within[1.1]>
      - define locs <[locs].include[<context.location.attached_to.center.find_blocks.within[1.1].if_null[<list>]>].deduplicate>
      - define do_sound false
      - foreach <[locs]> as:loc:
        - if <[loc].inventory.inventory_type.if_null[null]> in <[valid_invs]> && !<[loc].inventory.is_empty>:
          - define sorted <[loc].inventory.list_contents.proc[stack_items].proc[sort_items].proc[unstack_items].if_null[null]>
          - if <[sorted]> == null || <[sorted].is_empty>:
            - narrate "<&c>Unable to sort chest, this should not happen!"
            - foreach next
          - define do_sound true
          - inventory clear d:<[loc].inventory>
          - inventory set d:<[loc].inventory> o:<[sorted]>
          - playeffect effect:enchantment_table at:<[loc].center.above[0.5]> quantity:40 data:0.5 offset:0.2,0.2,0.2
          - if <[loc].other_block.exists>:
            - playeffect effect:enchantment_table at:<[loc].other_block.center.above[0.5]> quantity:40 data:0.5 offset:0.2,0.2,0.2
      - if <[do_sound]>:
        - define sound_loc <context.location.attached_to.center>
        - repeat 10:
          - playsound <[sound_loc]> sound:item_book_page_turn volume:1 pitch:1.5
          - wait 2t
