server_ping_handler:
  type: world
  debug: false
  events:
    on proxy server list ping:
      - determine passively "MOTD:<&sp.repeat[18]><element[Now available in plaid!].rainbow[ccaa]><n><&sp.repeat[18]><&b>yeah okay now log on"

    on server list ping:
      - determine passively "VERSION_NAME:<&a>The best chaotic live test server<&sp.repeat[10]>"
      #- determine passively ALTERNATE_PLAYER_TEXT:text
      - determine passively PROTOCOL_VERSION:999
      # width allowed: 270 ; <&sp> is 4, pad left and right with something like <element[270].sub[<[element].length>].div[2]>
      - determine "<&sp.repeat[18]><element[Now available in plaid!].rainbow[ccaa]><n><&sp.repeat[18]><&b>yeah okay now log on"

    #on script generates error priority:-1:
    #  - if <context.message.contains_any_text[chat_send_message].if_null[false]>:
    #    - determine cancelled
#	ElementTag(Number) to change the max player amount that will show.
# "ICON:" + ElementTag of a file path to an icon image, to change the icon that will display.
# "PROTOCOL_VERSION:" + ElementTag(Number) to change the protocol ID number of the server's version (only on Paper).
# "VERSION_NAME:" + ElementTag to change the server's version name (only on Paper).
# "EXCLUDE_PLAYERS:" + ListTag(PlayerTag) to exclude a set of players from showing in the player count or preview of online players (only on Paper).
# "ALTERNATE_PLAYER_TEXT:" + ListTag to set custom text for the player list section of the server status (only on Paper). (Requires "Allow restricted actions" in Denizen/config.yml). Usage of this to present lines that look like player names (but aren't) is forbidden.
# ElementTag to change the MOTD that will show.

pack_entity:
  type: entity
  entity_type: armor_stand
  mechanisms:
    armor_pose: left_arm=0,0,0|right_arm=0,0,0
    marker: true
    visible: false
    equipment:
      - air
      - air
      - air
      - leather_horse_armor[custom_model_data=1300008]
  flags:
    pack_entity: jump_pack

pack_entity_handler:
  type: world
  debug: false
  events:
    on entity_flagged:pack_entity exits vehicle:
      - if <context.entity.is_truthy>:
        - determine cancelled
    on player jumps flagged:pack_entity:
      - if !<player.passengers.filter[flag[pack_entity].equals[jump_pack]].is_empty>:
        - playsound sound:ENTITY_DRAGON_FIREBALL_EXPLODE <player.location>
        - playsound sound:ENTITY_GENERIC_EXTINGUISH_FIRE <player.location> pitch:1.5
        - adjust <player> velocity:<player.velocity.add[0,1,0].mul[4]>
        #@ cowboy mode
        #- adjust <player> velocity:<player.velocity.add[0,2,0].with_yaw[<player.location.yaw>].forward[0.75]>
#    after mythickeys key pressed id:minecraft:jump:
#      - if <player.is_on_ground> || ( <player.location.with_pose[90,90].precise_cursor_on.distance[<player.location>].is_less_than[0.6].if_null[true]> && <player.fall_distance> < 0.4 ):
#        - stop
#
#      - define velocity <location[0,0,0].with_pose[<player>]>
#      - if <player.is_sprinting>:
#        - define velocity <[velocity].above[0.25]>
#        - define forward 1.5
#      - else:
#        - define velocity <[velocity].above>
#        - define forward 1
#          #<player.velocity
#      - foreach <player.flag[velocity]> key:direction as:magnitude:
#        - define velocity <[velocity].add[<[magnitude]>]>
#
#      - adjust <player> velocity:<[velocity].mul[0.95].mul[<[forward]>]>
#      - playeffect effect:EXPLOSION_large at:<player.location> offset:0.1 quantity:3
#      - playeffect effect:lava at:<player.location.above[0.2]> offset:0.1 quantity:6
#      - playsound sound:ENTITY_DRAGON_FIREBALL_EXPLODE <player.location> volume:0.2
#      - playsound sound:ENTITY_GENERIC_EXTINGUISH_FIRE <player.location> pitch:1 volume:0.2
#      - repeat 14:
#        - playeffect effect:redstone at:<player.location.above[0.2]> offset:0.3 special_data:2|gray quantity:20
#        - playeffect effect:flame at:<player.location.above[0.2]> offset:0.3
#        - wait 1t
#      - repeat 8:
#        - playeffect effect:redstone at:<player.location.above[0.2]> offset:0.2 special_data:1|gray quantity:5
#        - wait 1t

repeat_menu:
  type: task
  debug: false
  script:
    - flag player testingmenu
    - while <player.has_flag[testingmenu]> && <player.is_online>:
      - sidebar set "title:Keys & Direction" "values:<list[<&e>yaw<&6><&co>|<&a><player.location.yaw.round_to[2]>|<&e>direction<&6><&co>|<&a><player.location.direction>|<empty>|<&e>key directions<&6><&co>].include[<player.flag[velocity].keys.parse_tag[<&a><[parse_value]>]>].include[<empty.repeat_as_list[<element[4].sub[<player.flag[velocity].keys.size>]>]>]>" players:<server.online_players>
      - wait 1t
    - sidebar remove


#test_flags:
#  type: world
#  debug: false
#  events:
#    #on mythickeys key pressed:
#    #  #- actionbar <context.id>
#    #  - actionbar <player.flag[velocity].keys.separated_by[<&sp.repeat[2]>|<&sp.repeat[2]>].if_null[<empty>]>
#    on mythickeys key pressed id:minecraft:left:
#      - flag player velocity.left:<location[0,0,0].with_yaw[<player.location.yaw>].left[2]>
#      - while <player.is_online> && <player.has_flag[velocity.left]>:
#        - if <player.has_flag[velocity.forward]> || <player.has_flag[velocity.back]>:
#          - flag player velocity.left:<location[0,0,0].with_yaw[<player.location.yaw>].left[0.5]>
#        - else:
#          - flag player velocity.left:<location[0,0,0].with_yaw[<player.location.yaw>].left[2]>
#        - wait 3t
#    on mythickeys key released id:minecraft:left:
#      - flag player velocity.left:!
#
#    on mythickeys key pressed id:minecraft:right:
#      - flag player velocity.right:<location[0,0,0].with_yaw[<player.location.yaw>].right[2]>
#      - while <player.is_online> && <player.has_flag[velocity.right]>:
#        - if <player.has_flag[velocity.forward]> || <player.has_flag[velocity.back]>:
#          - flag player velocity.right:<location[0,0,0].with_yaw[<player.location.yaw>].right[0.5]>
#        - else:
#          - flag player velocity.right:<location[0,0,0].with_yaw[<player.location.yaw>].right[2]>
#        - wait 3t
#    on mythickeys key released id:minecraft:right:
#      - flag player velocity.right:!
#
#    on mythickeys key pressed id:minecraft:back:
#      - flag player velocity.back:<location[0,0,0].with_yaw[<player.location.yaw>].backward_flat>
#      - while <player.is_online> && <player.has_flag[velocity.back]>:
#        - flag player velocity.back:<location[0,0,0].with_yaw[<player.location.yaw>].backward_flat>
#        - wait 3t
#    on mythickeys key released id:minecraft:back:
#      - flag player velocity.back:!
#
#    on mythickeys key pressed id:minecraft:forward:
#      - flag player velocity.forward:<location[0,0,0].with_yaw[<player.location.yaw>].forward_flat>
#      - while <player.is_online> && <player.has_flag[velocity.forward]>:
#        - flag player velocity.forward:<location[0,0,0].with_yaw[<player.location.yaw>].forward_flat>
#        - wait 3t
#    on mythickeys key released id:minecraft:forward:
#      - flag player velocity.forward:!
#
#
#    on player starts flying flagged:pack_entity:
#      - if !<player.passengers.filter[flag[pack_entity].equals[jump_pack]].is_empty>:
#        - determine passively cancelled
#        - playsound sound:ENTITY_GENERIC_EXTINGUISH_FIRE <player> pitch:1.5
#        #@cowboy mode
#        #- adjust <player> velocity:<player.velocity.add[0,1,0].with_yaw[<player.location.yaw>].forward[2]>
#        - define velocity <location[0,0.5,0]>
#        - if <player.velocity.x.abs> > <player.velocity.z.abs>:
#          - define velocity <[velocity].with_x[<element[2].div[<[velocity].x>]>]>
#          - define velocity <[velocity].with_z[<[velocity].z.mul[2]>]>
#        - else:
#          - define velocity <[velocity].with_z[<element[2].div[<[velocity].z>]>]>
#          - define velocity <[velocity].with_x[<[velocity].x.mul[2]>]>
#
#        - adjust <player> velocity:<[velocity]>


reset_thing:
  type: task
  script:
    - foreach <player.flag[pack_entity].filter[is_truthy]>:
      - remove <[value]>
    - flag player pack_entity:!

jump_pack:
  type: task
  debug: false
  script:
    - spawn pack_entity save:pack_entity
    - define entity <entry[pack_entity].spawned_entity>
    - mount <[entity]>|<player>
    - flag player pack_entity:->:<[entity]>
    - while <player.is_online> && <player.has_flag[pack_entity]>:
      - look <player.flag[pack_entity]> yaw:<player.location.yaw>
      - wait 1t
    - remove <player.flag[pack_entity].filter[is_truthy]>
    - flag player pack_entity:!


    #- define off_hand <[item_map].get[offhand].if_null[air]>
    #- define main_hand <[item_map].get[mainhand].if_null[air]>
    #- define pose <map[left_arm=0,0,0;right_arm=0,0,0]>
    #- spawn armor_stand[armor_pose=<[pose]>;marker=true;visible=false;equipment=<[item_map]>;item_in_offhand=<[off_hand]>;item_in_hand=<[main_hand]>]] <player.location> save:as
    #- mount <entry[as].spawned_entity>|<player>
    #- flag <entry[as].spawned_entity> on_dismount:cancel
    #- flag <entry[as].spawned_entity> on_entity_added:remove_this_entity
    #- determine <entry[as].spawned_entity>

# | Script is applied to NPC using:
# - /npc assignment --set my_npc_script
# | must be re-applied when making any adjustments after reloading with /ex reload
my_npc_script:
  type: assignment
  debug: false
  actions:
    on spawn:
      - wait 1s
      - if <server.has_flag[ender_dragon_spawn_ratelimit]>:
        - stop

      - flag server ender_dragon_spawn_ratelimit expire:1s
      - if <server.has_flag[ender_dragon_slayer.need_to_update]>:
        - run ender_dragon_npc_task.refresh def:<npc>

ender_dragon_listen:
  type: world
  debug: false
  events:
    on player kills ender_dragon:
      - run ender_dragon_npc_task.update
      - run ender_dragon_npc_task

ender_dragon_npc_task:
  type: task
  debug: false
  definitions: npc
  update:
    - flag server ender_dragon_slayer.player:<player.name>
    - flag server ender_dragon_slayer.skin_blob:<player.skin_blob>
    - flag server ender_dragon_slayer.need_to_update

  refresh:
    - adjust <[npc]> name:<server.flag[ender_dragon_slayer.player]>
    - adjust <[npc]> skin_blob:<server.flag[ender_dragon_slayer.skin_blob]>
    - adjust <[npc]> name_visible:true
    - flag <[npc]> ender_dragon_slayer.need_to_update:!

  script:
    - define ender_dragon_slayer_npc <server.npcs_assigned[my_npc_script].if_null[null]>

    - if <[ender_dragon_slayer_npc].is_empty>:
      - announce to_console "<&[error]>There is no NPC for the last slayer of the Ender Dragon!"
      - announce to_ops "<&[error]>There is no NPC for the last slayer of the Ender Dragon!"
      - stop

    - if <[ender_dragon_slayer_npc].first.is_truthy>:
      - run ender_dragon_npc_task.refresh def:<[ender_dragon_slayer_npc].first>


testing_events:
  type: world
  events:
    on block destroyed by explosion in:end_spawn:
      - determine cancelled

    on player steers minecart:
      - sidebar set_line scores:1 "values:<&e>Sideways<&6><&co> <&a><context.sideways.round_to_precision[0.0001]>"
      - sidebar set_line scores:2 "values:<&e>Forward<&6><&co> <&a><context.forward.round_to_precision[0.0001]>"
      - if <context.jump>:
        - sidebar set_line scores:3 "values:<&e>Jump<&6><&co> <&a><context.jump>"
      - else:
        - sidebar set_line scores:3 "values:<&e>Jump<&6><&co> <&c><context.jump>"
      - if <context.dismount>:
        - sidebar set_line scores:4 "values:<&e>Dismount<&6><&co> <&a><context.dismount>"
      - else:
        - sidebar set_line scores:4 "values:<&e>Dismount<&6><&co> <&c><context.dismount>"

minecart_connecting:
  type: task
  debug: false
  script:
    - remove <player.location.find_entities[minecart].within[10]>
    - spawn minecart <player.location.up[0.0625]> save:first
    - spawn minecart save:second
    - spawn minecart save:third
    - define first <entry[first].spawned_entity>
    - define second <entry[second].spawned_entity>
    - define third <entry[third].spawned_entity>
    - if <[first].location.direction> in north|south:
      - define offset <location[1,0,0]>
    - else:
      - define offset <location[0,0,1]>

    - adjust <[first]>|<[second]>|<[third]> collidable:false

    - attach <[second]> to:<[first]> offset:<[offset]> relative
    - attach <[third]> to:<[first]> offset:<[offset].mul[2]> relative

test_flamethrower_item:
  type: item
  material: crossbow
  mechanisms:
    custom_model_data: 8

test_flamethrower:
  type: world
  debug: false
  events:
    on player clicks block with:test_flamethrower_item:
      - determine passively cancelled
      - define me <player>

      - if <context.hand> == hand:
        - define hand right
      - else:
        - define hand left

      - repeat 10:
        - define hand_location <[me].vivecraft.position[<[hand]>]>
        #- playeffect at:<[hand_location].forward[0.3]> offset:0.1 quantity:3 effect:flame velocity:<[hand_location].direction.vector.div[2]>
        #- playeffect at:<[hand_location].forward[0.3]> offset:0.1 effect:smoke velocity:<[hand_location].direction.vector.div[2]>

        - repeat 10:
          - define vector <[hand_location].face[<[hand_location].forward[10].random_offset[1,1,1]>].direction.vector>
          - playeffect at:<[hand_location]> effect:flame velocity:<[vector].div[1.5]> offset:0.1 quantity:2
          - playeffect at:<[hand_location]> effect:smoke velocity:<[vector].div[1.5]> offset:0.2 quantity:3

        - wait 1t

    on player loads crossbow:
      - stop if:!<context.crossbow.script.exists>
      - stop if:!<context.crossbow.script.name.equals[test_flamethrower_item]>
      - determine passively cancelled
      - if <context.hand> == hand:
        - define hand right
      - else:
        - define hand left

      - define me <player>
      - repeat 10:
        - define hand_location <[me].vivecraft.position[<[hand]>]>
        # -

        - repeat 10:
          - define vector <[hand_location].face[<[hand_location].forward[10].random_offset[1,1,1]>].direction.vector.div[2]>
          - playeffect at:<[hand_location]> effect:flame velocity:<[vector]> offset:0.1 quantity:2
          - playeffect at:<[hand_location]> effect:smoke velocity:<[vector]> offset:0.2

        - wait 1t


flame_test:
  type: task
  script:
    - define me <server.match_player[_Behr__].if_null[<player>]>
    - repeat 1:
      #- define hand_location <[me].vivecraft.position[left]>
      - define hand_location <[me].eye_location>
      - repeat 10:
        - define vector <[hand_location].face[<[hand_location].forward[10].random_offset[1,1,1]>].direction.vector.div[2]>
        - playeffect at:<[hand_location]> effect:flame velocity:<[vector]> offset:0.1 quantity:2
        - playeffect at:<[hand_location]> effect:smoke velocity:<[vector]> offset:0.2
      - wait 1t

dance_for_me:
  type: task
  debug: false
  data:
    npcs:
      28: Hydroxycobalamin
      31: mcmonkey4eva
      32: Techjar
      33: ayalaandtal
      34: Wahrheit
      35: Mergu
      36: acikek
      37: Zozer_Firehood
      38: Eutherin
      39: Xeane
      40: Nimsy
      42: _Breadcrumb
      43: Jumpsplat120
      44: funky493
      47: Behrrance
      48: Behrry
      50: InquisitorOfGods
      51: Mwthorn
      52: calicokid
      53: Fullwall

  sneak_test:
    - define npcs <script[dance_for_me].data_key[data.npcs].keys.parse_tag[<npc[<[parse_value]>]>]>
    - repeat 10:
      - sneak <[npcs]> start
      - wait 5t
      - sneak <[npcs]> stop
      - wait 5t
  script:
  #  - flag server testing
  #  - while <server.has_flag[testing]>:

    - define me <server.match_player[_behr__]>
    - define npcs <script.data_key[data.npcs].keys>
    - repeat 400:
      - foreach <[npcs]> as:npc_id:
        - vivemirror <npc[<[npc_id]>]> mirror:<[me].vivecraft> targets:<[me]>
      - wait 1t

# /ex look <script[dance_for_me].data_key[data.npcs].keys.parse_tag[<npc[<[parse_value]>]>]> <player.cursor_on.center>
## press button to start recording
#waiting_for_dance_recital:
#  type: world
#  events:
#    after player clicks stone_button location_flagged:start_recorder:
#      - stop if:!<server.has_flag[recording_dance]>
# 
#    # | temp testing one dance "recording_dance" for now
#      - flag server recording_dance:dance_test
#      - repeat 3 as:loop_index:
#        - title title:<[loop_index]>
#        - wait 1s
#
#      - while <server.has_flag[recording_dance]>:
#        - foreach head|left|right as:controller:
#          - define poses.step.<[loop_index]>.<[controller]>:<player.position[<[controller]>]>
#        - wait 1t
#
#    # | temp testing one dance "recording_dance" for now
#      - flag server recording_dance:<[poses]>
#
#    after player clicks stone_button location_flagged:end_recorder:
#      - stop if:!<server.has_flag[recording_dance]>
#      - flag server recording_dance:!
#      - title "title:<&[red]>Dance Recital Stopped"
#
#play_dance:
#  type: task
#  script:
#    # | temp testing one dance"recording_dance" for now
#    - foreach <server.flag[recording_dance]> key:pose as:step:
#      - vivepose <npc> left_arm:<[pose.<[step]>.left_hand]> right_arm:<[pose.<[step]>.right_hand]> head:<[pose.<[step]>.head]>
#      - wait 1t

# This is a task script that defines multiple tags and plays particle effects

# This is a task script that defines multiple tags and plays particle effects
