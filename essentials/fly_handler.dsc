flight_handler:
  type: world
  debug: false
  enabled: false
  events:
    after player starts gliding flagged:!behr.essentials.airborne:
      - flag player behr.essentials.airborne
    after player stops gliding flagged:behr.essentials.airborne:
      - flag player behr.essentials.airborne:!
    after player starts sneaking flagged:behr.essentials.airborne:
      - stop if:<player.has_flag[behr.essentials.ratelimit.elytra_charge]>

      - wait 1s

      - stop if:<player.is_on_ground>
      - stop if:!<player.is_truthy>

      - itemcooldown elytra duration:10s
      - flag player behr.essentials.ratelimit.elytra_charge expire:10s
      #- playeffect effect:explosion_large at:<player.eye_location> quantity:5
      - adjust <player> is_using_riptide:true
      - actionbar "<&color[<proc[argb]>]>Flight charged!"
      - repeat 10 as:i:
        - if !<player.is_truthy> || <player.is_on_ground>:
          - adjust <player> is_using_riptide:false
          - stop
        - if <[i].mod[10]> == 0:
          - adjust <player> velocity:<location[0,0.3,0].with_pose[<player>].forward[2]>
        - define pitch <player.location.pitch.to_radians>
        - define yaw <player.location.yaw.mul[-1].to_radians>
        - define loc <location[0,1,1].rotate_around_z[<[i].to_radians.mul[170]>].rotate_around_x[<[pitch]>].rotate_around_y[<[yaw]>]>
        #- playeffect effect:firework at:<player.eye_location.forward[2].add[<[loc]>]> offset:0.1 quantity:2
        - wait 1t
      - adjust <player> is_using_riptide:false
