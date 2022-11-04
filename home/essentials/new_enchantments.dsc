# @ ideas
# todo: mobs dropping blood to be picked up if they have glass_bottle
# todo: picking up blood if:
# todo: - they have glass_bottles in their inventory
# todo: - they have enough inventory space for a new stack if they have no <64 stacky

new_enchantments:
  type: world
  debug: false
  events:
   # @ on loading the crossbow, the crossbow has charged_projectiles=arrow|*<[number of arrows left in inventory]>
   #on player loads crossbow:
   #  - announce to_console <player.item_in_hand>
   #  - stop if:!<player.item_in_hand.enchantment_map.contains[multishot]>
   #  #- define level <player.item_in_hand.enchantment_map.get[multishot]>
   #  - if !<player.inventory.contains_item[arrow]>:
   #    - actionbar "<&[red]>No more arrows!"
   #    - determine cancelled
   #  - wait 1t
   #  - announce to_console <player.item_in_hand>
   #  - inventory flag slot:hand quantity:<player.inventory.quantity_item[arrow]>
   #  - announce to_console <player.item_in_hand>
   # @ after shooting the crossbow, it somehow games charged_projectiles=arrow[quantity=<[arrows]>]|arrow[quantity=<[arrows]>]|arrow[quantity=<[arrows]>]|
   # @ where arrows is the number of arrows in my inventory - and it shoots that number instead of the quantity i specify below?
   #after player loads crossbow:
   #  - stop if:!<player.item_in_hand.enchantment_map.contains[multishot]>
   #  - define level <player.item_in_hand.enchantment_map.get[multishot]>
   #  - choose <[level]>:
   #    - case 1:
   #      - define arrows <element[arrow].repeat_as_list[<player.inventory.quantity_item[arrow].min[3]>]>
   #    - case 2:
   #      - define arrows <element[arrow].repeat_as_list[<player.inventory.quantity_item[arrow].min[5]>]>
   #    - case 3:
   #      - define arrows <element[arrow].repeat_as_list[<player.inventory.quantity_item[arrow].min[7]>]>
   #    - case 4:
   #      - define arrows <element[arrow].repeat_as_list[<player.inventory.quantity_item[arrow].min[10]>]>
   #    - case 5:
   #      - define arrows <element[arrow].repeat_as_list[<player.inventory.quantity_item[arrow].min[15]>]>
   #  - inventory adjust slot:hand charged_projectiles:<[arrows]>
    after player loads crossbow:
      - stop if:!<player.item_in_hand.enchantment_map.contains[quick_charge]>
      - define level <player.item_in_hand.enchantment_map.get[quick_charge]>
      - if <player.is_sneaking> && <[level]> > 3:
        - stop if:<player.has_flag[behr.essentials.combat.active_skills.rapid_fire_clutch.tick]>
        - if <player.has_flag[behr.essentials.combat.active_skills.rapid_fire_clutch.cooldown]>:
          - actionbar "<&[yellow]><player.flag_expiration[behr.essentials.combat.active_skills.rapid_fire_clutch.cooldown].from_now.formatted> <&[red]>cooldown on rapid fire clutch"
          - stop

        - narrate "<&[green]>Rapid fire clutch activated"
        - flag <player> behr.essentials.combat.active_skills.rapid_fire_clutch.tick expire:5s
        - wait 5s
        - define duration <duration[<[level].mul[3.8].round>s]>
        #- waituntil !<player.has_flag[behr.essentials.combat.active_skills.rapid_fire_clutch]> max:<[duration]> rate:1s
        # todo: fix the maximum duration
        - waituntil !<player.has_flag[behr.essentials.combat.active_skills.rapid_fire_clutch.tick]> max:20s rate:1s
        - narrate "<&[red]>Rapid fire clutch deactivated"

        - flag <player> behr.essentials.combat.active_skills.rapid_fire_clutch.tick:!
        - flag <player> behr.essentials.combat.active_skills.rapid_fire_clutch.cooldown expire:<[level].mul[-1].add[8].mul[40]>s

    on player shoots crossbow:
      - if <player.item_in_hand.enchantment_map.contains[multishot]>:
        - define level <player.item_in_hand.enchantment_map.get[multishot]>
        - announce to_console <player.item_in_hand>
        - determine passively cancelled
        - choose <[level]>:
          - case 1:
            - shoot <element[arrow].repeat_as_list[<player.inventory.quantity_item[arrow].min[3]>]> speed:3 spread:3 source:<player>
          - case 2:
            - shoot <element[arrow].repeat_as_list[<player.inventory.quantity_item[arrow].min[5]>]> speed:3 spread:5 source:<player>
          - case 3:
            - shoot <element[arrow].repeat_as_list[<player.inventory.quantity_item[arrow].min[7]>]> speed:4 spread:7 source:<player>
          - case 4:
            - shoot <element[arrow].repeat_as_list[<player.inventory.quantity_item[arrow].min[10]>]> speed:4 spread:10 source:<player>
          - case 5:
            - shoot <element[arrow].repeat_as_list[<player.inventory.quantity_item[arrow].min[15]>]> speed:5 spread:15 source:<player>

      - else if <player.item_in_hand.enchantment_map.contains[quick_charge]>:
        - define level <player.item_in_hand.enchantment_map.get[quick_charge]>
        - if <player.has_flag[behr.essentials.combat.active_skills.rapid_fire_clutch.tick]> && <[level]> > 3:
          - determine passively cancelled
          - flag player behr.essentials.combat.active_skills.rapid_fire_clutch.tick expire:5s
          - repeat <[level].mul[0.75].round>:
            - shoot arrow origin:<player> speed:<[level].mul[0.75].round> source:<player>

            - repeat 3:
              - playeffect at:<player.eye_location.below[0.4].random_offset[1,1,1]> effect:electric_spark visibility:100 quantity:15 offset:0
              - wait 1t
            #- playeffect at:<player.eye_location.add[<player.location.direction.vector.mul[2.5]>].points_between[<player.eye_location.add[<player.location.direction.vector.mul[]>]>].distance[0.5]> effect:electric_spark offset:0.2 quantity:10
            #- wait 3t

    after player shoots bow:
      - if <player.item_in_hand.enchantment_map.contains[flame]>:
        - define level <player.item_in_hand.enchantment_map.get[flame]>
        - wait 2t

        - define location <context.projectile.location.above[0.1]>
        - while <context.projectile.is_truthy> && !<context.projectile.is_on_ground>:
          - define location <context.projectile.location.above[0.1]>
          - playeffect at:<[location]> effect:flame visibility:100 quantity:<[level].mul[3]> offset:0.1
          - playeffect at:<[location]> effect:lava visibility:100 quantity:<[level].mul[2]> offset:0.1
          - wait 1t
        - playeffect at:<[location]> effect:lava visibility:100 quantity:<[level].mul[20]> offset:0.<[level]>

        - if <[level]> == 4 || <player.has_flag[behr.essentials.combat.cooldown.large_flame_explosion]>:
          - explode <[location]> power:1 fire source:<player>
        - else if <[level]> == 5:
          - flag <player> behr.essentials.combat.cooldown.large_flame_explosion expire:6s
          - explode <[location]> power:3 fire source:<player>

      - if <player.item_in_hand.enchantment_map.contains[smite]>:
        - define level <player.item_in_hand.enchantment_map.get[smite]>
        - wait 1t

        - while <context.projectile.is_truthy> && !<context.projectile.is_on_ground>:
          - define location <context.projectile.location.above[0.1]>
          - playeffect at:<[location]> effect:electric_spark visibility:100 quantity:<[level].mul[5]> offset:0.1
          - wait 1t

        - if <[level]> == 4:
          - strike <[location]>

        - else if <[level]> == 5:
          - repeat 3:
            - strike <[location].random_offset[1,0,1]>
            - wait 1t
          - repeat 3:
            - define entities <[location].find_entities[!armor_stand|arrow|lightning].within[3]>
            - hurt <[entities]> 2 source:<player> if:!<[entities].is_empty>
            - foreach <[entities]> as:entity:
              - if <[entity].is_truthy>:
                - adjust <[entity]> no_damage_duration:1t
            - repeat 8:
              - playeffect at:<[entities].filter[is_truthy].parse[location.above[0.2]]> effect:electric_spark visibility:100 quantity:20 offset:0.5,1,0.5
              - playeffect at:<[location]> effect:electric_spark visibility:100 quantity:75 offset:1,0.1,1
              - wait 1t
            - wait 5t

      - define enchanted_arrow_potion_effect_types <context.projectile.potion.effects_data.parse[get[type]].if_null[<list>]>
      - if <[enchanted_arrow_potion_effect_types].contains_any[poison|instant_damage]>:
        - if <[enchanted_arrow_potion_effect_types].contains[poison]>:
          - define effect sneeze
        - else if <[enchanted_arrow_potion_effect_types].contains[instant_damage]>:
          - define effect smoke
        - define last_location <context.projectile.location.backward[0.2]>
        - while <context.projectile.is_truthy> && !<context.projectile.is_on_ground>:
          - define locations <context.projectile.location.above[0.1].points_between[<[last_location]>].distance[0.4]>
          - playeffect at:<[locations]> effect:<[effect]> visibility:100 quantity:5 offset:0.1
          - define last_location <context.projectile.location.above[0.1]>
          - wait 1t

    on player prepares anvil craft bow|crossbow:
      - define item_one_enchantment_map <context.inventory.slot[1].enchantment_map>
      - define item_two_enchantment_map <context.inventory.slot[2].enchantment_map>

      - define unique_enchantments <list[infinity|flame|smite|multishot]>
      - define default_enchantments <list[quick_charge]>
      - define new_enchantments <map>
      - define combined_enchantments <[item_one_enchantment_map].include[<[item_two_enchantment_map]>].keys>
      - foreach <[unique_enchantments].shared_contents[<[combined_enchantments]>].include[<[default_enchantments]>]> as:enchantment:
        - determine air if:<[combined_enchantments].contains_any[<[unique_enchantments].exclude[<[enchantment]>]>]>
        - if <[item_one_enchantment_map].contains[<[enchantment]>]> || <[item_two_enchantment_map].contains[<[enchantment]>]>:
          - define level_one <[item_one_enchantment_map].get[<[enchantment]>].if_null[0]>
          - define level_two <[item_two_enchantment_map].get[<[enchantment]>].if_null[0]>
          - define min_level <[level_one].min[<[level_two]>]>
          - define max_level <[level_one].max[<[level_two]>]>
          - if <[level_one].sub[<[level_two]>].abs.is_more_than[1]> && <[max_level]> > 3:
            - determine air
          - if <[max_level]> == 0:
            - define experience 5
            - define new_enchantments <[new_enchantments].include[<[enchantment]>=1]>
          - else if <[level_one]> == <[level_two]>:
            - define experience <[min_level].mul[1.5].mul[12]>
            - define new_enchantments <[new_enchantments].include[<[enchantment]>=<[min_level].add[1]>]>
          - else if <[max_level]> != 5:
            - define experience <[min_level].max[1].mul[1.5].mul[12]>
            - define new_enchantments <[new_enchantments].include[<[enchantment]>=<[max_level]>]>
          - else if <[min_level]> < 4:
            - determine air
          - else:
            - define experience 69
            - define new_enchantments <[new_enchantments].include[<[enchantment]>=5]>
          - determine passively <[experience].if_null[1]>
      - define all_enchantments <[item_one_enchantment_map].include[<[new_enchantments]>]>
      - determine <context.inventory.slot[1].with[enchantments=<[all_enchantments]>]>

    on player prepares anvil craft enchanted_book:
      - define enhanced_enchantments <list[flame|unbreaking|quick_charge|piercing|multishot|fortune|projectile_protection|blast_protection|fire_protection|protection|swift_sneaking|fire_aspect]>
      - define item_one_enchantment_map <context.inventory.slot[1].enchantment_map>
      - define item_two_enchantment_map <context.inventory.slot[2].enchantment_map>

      - define unique_enchantments <list[infinity|flame|smite]>
      - define new_enchantments <map>
      - define combined_enchantments <[item_one_enchantment_map].include[<[item_two_enchantment_map]>].keys>
      - foreach <[unique_enchantments].shared_contents[<[combined_enchantments]>]> as:enchantment:
        - foreach next if:!<[combined_enchantments].contains_any[<[unique_enchantments].exclude[<[enchantment]>]>]>
        - determine air

      - stop if:!<[item_one_enchantment_map].keys.contains_any[<[enhanced_enchantments]>]>
      - stop if:!<[item_two_enchantment_map].keys.contains_any[<[enhanced_enchantments]>]>
      - foreach <[item_one_enchantment_map].get_subset[<[enhanced_enchantments]>]> key:enchantment:
        - define level_one <[item_one_enchantment_map].get[<[enchantment]>]>
        - define level_two <[item_two_enchantment_map].get[<[enchantment]>]>
        - define min_level <[level_one].min[<[level_two]>]>
        - define new_enchantments <map>
        - if <[level_one]> != <[level_two]>:
          - define experience 2
          - define new_enchantments <[new_enchantments].include[<[enchantment]>=<[min_level]>]>
        - else if <[min_level]> != 5:
          - define experience <[min_level].mul[1.5].mul[12]>
          - define new_enchantments <[new_enchantments].include[<[enchantment]>=<[min_level].add[1]>]>
        - else:
          - define experience 10
          - define new_enchantments <[new_enchantments].include[<[enchantment]>=5]>

      - determine passively <[experience].if_null[1]>
      - define all_enchantments <[item_one_enchantment_map].include[<[new_enchantments]>]>
      - determine <context.inventory.slot[1].with[enchantments=<[all_enchantments]>]>

poison_3_arrow:
  type: item
  debug: false
  material: tipped_arrow
  mechanisms:
    potion_effects:
      - [type=poison]
      - [type=poison;amplifier=2;duration=120;ambient=false;particles=true;icon=true]
  recipes:
    1:
      type: brewing
      input: tipped_arrow[potion_effects=[type=poison;upgraded=true;extended=false]]
      ingredient: crimson_morel

poison_4_arrow:
  type: item
  debug: false
  material: tipped_arrow
  mechanisms:
    potion_effects:
      - [type=poison;upgraded=true]
      - [type=poison;amplifier=3;duration=200;ambient=false;particles=true;icon=true]
  recipes:
    1:
      type: brewing
      input: poison_3_arrow
      ingredient: warped_morel

harming_3_arrow:
  type: item
  debug: false
  material: tipped_arrow
  mechanisms:
    potion_effects:
      - [type=instant_damage;upgraded=true]
      - [type=harm;amplifier=2]

harming_4_arrow:
  type: item
  debug: false
  material: tipped_arrow
  mechanisms:
    potion_effects:
      - [type=instant_damage;upgraded=true]
      - [type=harm;amplifier=3]


frost_aspect_enchantment:
    type: enchantment
#    # The ID is used as the internal registration key, and for lookups with things like the 'enchantments' mechanism.
#    # If unspecified, will use the script name.
#    # Limited to A-Z or _.
#    # | Most enchantment scripts should have this key!
    id: frost_aspect
#
#    # A list of slots this enchantment is valid in.
#    # | ALL enchantment scripts MUST have this key!
    slots:
#    # Can be any of: mainhand, offhand, feet, legs, chest, head
    - mainhand
#
#    # The rarity level of this enchantment. Can be any of: COMMON, UNCOMMON, RARE, VERY_RARE
#    # If unspecified, will use COMMON.
#    # | Most enchantment scripts should have this key!
#    rarity: common
#
#    # The category/type of this enchantment. Can be any of: ARMOR, ARMOR_FEET, ARMOR_LEGS, ARMOR_CHEST, ARMOR_HEAD,
#    # WEAPON, DIGGER, FISHING_ROD, TRIDENT, BREAKABLE, BOW, WEARABLE, CROSSBOW, VANISHABLE
#    # This is used internally by the enchanting table to determine which items to offer the enchantment for.
#    # If unspecified, will use WEAPON.
#    # | Most enchantment scripts should have this key!
    category: weapon
#
#    # The per-level full name of this enchantment. Does not appear in lore automatically (but might in the future?).
#    # Can make use of "<context.level>" for the applicable level.
#    # | Most enchantment scripts should have this key!
    full_name: Frost <context.level>
#
#    # The minimum level of this enchantment.
#    # If unspecified, will use 1.
#    # | Most enchantment scripts can exclude this key.
#    min_level: 1
#
#    # The maximum level of this enchantment.
#    # If unspecified, will use 1.
#    # | Some enchantment scripts should have this key.
    max_level: 5
#
#    # The per-level minimum XP cost of enchanting.
#    # Can make use of "<context.level>" for the applicable level.
#    # | Most enchantment scripts should have this key!
    min_cost: <context.level.mul[1.5].mul[12]>
#
#    # The per-level maximum XP cost of enchanting.
#    # Can make use of "<context.level>" for the applicable level.
#    # | Most enchantment scripts should have this key!
    max_cost: <context.level.mul[1.5].mul[12]>
#
#    # Whether this enchantment is only considered to be treasure. Treasure enchantments do not show in the enchanting table.
#    # If unspecified, will be false.
#    # | Most enchantment scripts can exclude this key.
#    treasure_only: false
#
#    # Whether this enchantment is only considered to be a curse. Curses are removed at grindstones, and spread from crafting table repairs.
#    # If unspecified, will be false.
#    # | Most enchantment scripts can exclude this key.
#    is_curse: false
#
#    # Whether this enchantment is only considered to be tradable. Villagers won't trade this enchantment if set to false.
#    # If unspecified, will be true.
#    # | Most enchantment scripts can exclude this key.
#    is_tradable: true
#
#    # Whether this enchantment is only considered to be discoverable.
#    # If true, this will spawn from vanilla sources like the enchanting table. If false, it can only be given directly by script.
#    # If unspecified, will be true.
#    # | Most enchantment scripts can exclude this key.
#    is_discoverable: true
#
#    # A tag that returns a boolean indicating whether this enchantment is compatible with another.
#    # Can make use of "<context.enchantment_key>" for the applicable enchantment's key, like "minecraft:sharpness".
#    # This is used internally by the enchanting table and the anvil to determine if this enchantment can be given alongside another.
#    # If unspecified, will default to always true.
#    # | Most enchantment scripts can exclude this key.
#    is_compatible: <context.enchantment_key.advanced_matches_text[minecraft:lure|minecraft:luck*]>
    is_compatible: <context.enchantment_key.advanced_matches_text[minecraft:flame*|minecraft:infinity*|minecraft:smite*|minecraft:multishot*]>
#
#    # A tag that returns a boolean indicating whether this enchantment can enchant a specific item.
#    # Can make use of "<context.item>" for the applicable ItemTag.
#    # This is used internally to decide whether survival players can copy the enchantment between items on an anvil, as well as for commands like "/enchant".
#    # If unspecified, will default to always true.
#    # | Most enchantment scripts can exclude this key.
#    can_enchant: <context.item.advanced_matches[*_sword|*_axe]>
#
#    # A tag that returns a decimal number indicating how much extra damage this item should deal.
#    # Can make use of "<context.level>" for the enchantment level,
#    # and "<context.type>" for the type of monster being fought: ARTHROPOD, ILLAGER, WATER, UNDEAD, or UNDEFINED
#    # If unspecified, will default to 0.0.
#    # | Most enchantment scripts can exclude this key.
#    damage_bonus: 0.0
#
#    # A tag that returns an integer number indicating how much this item should protection against damage.
#    # Can make use of "<context.level>" for the enchantment level, and "<context.cause>" for the applicable damage cause, using internal cause names (different from Spigot Damage Causes).
#    # Internal cause names: inFire, lightningBolt, onFire, lava, hotFloor, inWall, cramming, drown, starve, cactus, fall, flyIntoWall,
#    # outOfWorld, generic, magic, wither, anvil, fallingBlock, dragonBreath, dryout, sweetBerryBush, freeze, fallingStalactite, stalagmite
#    # Also "<context.attacker>" as an EntityTag if the cause has an attacker specified.
#    # If unspecified, will default to 0.
#    # | Most enchantment scripts can exclude this key.
#    damage_protection: 0
#
#    # Triggered after an enchanted weapon is used to attack an entity.
#    # Has <context.attacker> (EntityTag), <context.victim> (EntityTag), and <context.level>.
#    # May fire rapidly or multiple times per hit. Use a ratelimit to prevent this.
#    # | Some enchantment scripts should have this key.
#    after attack:
#    - narrate "You attacked <context.victim.name> with a <context.level> enchantment!"
#
#    # Triggered after an enchanted armor is used to defend against an attack.
#    # Also fires if an entity is holding a weapon with this enchantment while being hit.
#    # Has <context.attacker> (EntityTag), <context.victim> (EntityTag), and <context.level>.
#    # | Some enchantment scripts should have this key.
#    after hurt:
#    - narrate "You got hurt by <context.attacker.name> and protected by a level <context.level> enchantment!"
    after hurt:
    - adjust <context.victim> freeze_duration:<context.victim.freeze_duration.add[<context.level.mul[5]>]>
