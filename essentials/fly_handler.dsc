flight_handler:
  type: world
  debug: false
  events:
    after player starts sneaking:
      - stop if:<player.is_on_ground>
      - wait 1t
      - define i 0
      - define sp <proc[negative_spacing].context[4].font[spaces]>
      - while <player.is_sneaking> && !<player.is_on_ground> && <[i]> < 40:
        - define i:+:6
        - define charge <element[●<[sp]>].repeat[<[i]>].color_gradient[from=#0000FF;to=#FF0000;style=hsb]>
        - define remainder <&7><element[●<[sp]>].repeat[<element[100].sub[<[i]>]>]>
        - actionbar <[charge]><[remainder]>
        - wait 6t

      - while <player.is_sneaking> && !<player.is_on_ground> && <[i]> < 80:
        - define i:+:6
        - define charge <element[●<[sp]>].repeat[<[i]>].color_gradient[from=#0000FF;to=#FF0000;style=hsb]>
        - define remainder <&7><element[●<[sp]>].repeat[<element[100].sub[<[i]>]>]>
        - actionbar <[charge]><[remainder]>
        - wait 3t

      - while <player.is_sneaking> && !<player.is_on_ground> && <[i]> < 100:
        - define i:+:3
        - define charge <element[●<[sp]>].repeat[<[i]>].color_gradient[from=#0000FF;to=#FF0000;style=hsb]>
        - define remainder <&7><element[●<[sp]>].repeat[<element[100].sub[<[i]>]>]>
        - actionbar <[charge]><[remainder]>
        - wait 1t

      - waituntil !<player.is_sneaking>
      - stop if:<player.is_on_ground>
      - stop if:!<player.is_truthy>

      - playeffect effect:explosion_large at:<player.eye_location> quantity:5
      - adjust <player> is_using_riptide:true
      - repeat <[i]> as:i:
        - if <player.is_on_ground> || !<player.is_truthy>:
          - adjust <player> is_using_riptide:false
          - stop
        - if <[i].mod[10]> == 0:
          - adjust <player> velocity:<location[0,0,0].with_pose[<player>].forward[2]>
        - define pitch <player.location.pitch.to_radians>
        - define yaw <player.location.yaw.mul[-1].to_radians>
        - define loc <location[0,1,1].rotate_around_z[<[i].to_radians.mul[170]>].rotate_around_x[<[pitch]>].rotate_around_y[<[yaw]>]>
        - playeffect effect:fireworks_spark at:<player.eye_location.forward[2].add[<[loc]>]> offset:0.1 quantity:2
        - wait 1t
      - adjust <player> is_using_riptide:false
