# credit to seb303 for inital script
# modifications made;
# original: https://github.com/seb303/DnBrowse
dnbrowse_task:
  type: task
  debug: false
  script:
  # % ██ [ Index page served from secret URL ] ██:
  - if <context.path.length> == 13 && <server.has_flag[dnbrowse.secret.<context.path.substring[2]>]>:
    - determine code:200 passively
    - definemap headers:
      Content-Type: text/html; charset=UTF-8
      Cache-Control: max-age=86400
    - determine headers:<[headers]> passively
    - determine file:/dnbrowse/index.html

  # % ██ [ Data requests                     ] ██:
  - if <context.path> == /ajax:
    - define dnbrowse.secret <context.query.get[secret]>
    - if <[dnbrowse.secret].length> != 12 || !<server.has_flag[dnbrowse.secret.<[dnbrowse.secret]>]>:
      - determine code:401 passively
      - determine headers:[Content-Type=text/plain] passively
      - determine "raw_text_content:Permission denied"

    # % ██ [ Get player (can have value "server" if started from console) ] ██:
    - define player <server.flag[dnbrowse.secret.<[dnbrowse.secret]>]>
    # % ██ [ Refresh secret expiry                                        ] ██:
    - flag server dnbrowse.secret.<[dnbrowse.secret]>:<[player]> expire:<script[dnbrowse_config].data_key[timeout]>
    - if <[player]> != server:
      - flag <[player]> dnbrowse.secret:<[dnbrowse.secret]> expire:<script[dnbrowse_config].data_key[timeout]>
      - definemap perms:
        tp: <[player].has_permission[custom.dnbrowse.tp].if_null[false]>
        edit: <[player].has_permission[custom.dnbrowse.edit].if_null[false]>
        secrets: <[player].has_permission[custom.dnbrowse.secrets].if_null[false]>
    - else:
      - definemap perms:
        tp: false
        edit: false
        secrets: false

    # % ██ [ Respond with JSON data                                       ] ██:
    - determine code:200 passively
    - definemap headers:
      Content-Type: application/json; charset=UTF-8
      Cache-Control: no-cache
    - determine headers:<[headers]> passively
    - choose <context.query.get[action]>:

      - case get_options:
        - definemap data:
          timeout: <duration[<script[dnbrowse_config].data_key[timeout]>].in_seconds>
          show_expired_flags: <script[dnbrowse_config].data_key[show_expired_flags]>
          tp: <[perms.tp]>
          edit: <[perms.edit]>
          time_now: <util.time_now>

      - case keep_alive:
        - define data <map>

      - case load_server:
        - define data <server.flag_map>
        - if !<[perms.secrets]>:
          - define data.dnbrowse.active:!
          - define data.dnbrowse.secret:!

      - case load_players:
        - definemap data:
          online: <map>
          offline: <map>
        - foreach <server.online_players> as:p:
          - definemap data.online.<[p]>:
            name: <[p].name>
            uuid: <[p].uuid>
        - foreach <server.offline_players> as:p:
          - definemap data.offline.<[p]>:
            name: <[p].name>
            uuid: <[p].uuid>

      - case get_player_name:
        - if <player[<context.query.get[player]>].exists>:
          - define data.name <player[<context.query.get[player]>].name>
        - else:
          - define data.name <empty>

      - case teleport:
        - define areaType null
        - if <[perms.tp]>:
          - if <location[<context.query.get[destination]>].exists>:
            - teleport <location[<context.query.get[destination]>]> player:<[player]>
            - define areaType location
          - else if <cuboid[<context.query.get[destination]>].exists>:
            - define area <cuboid[<context.query.get[destination]>]>
            - define center <[area].center>
            - define areaType cuboid
          - else if <ellipsoid[<context.query.get[destination]>].exists>:
            - define area <ellipsoid[<context.query.get[destination]>]>
            - define center <[area].location>
            - define areaType ellipsoid
          - else if <polygon[<context.query.get[destination]>].exists>:
            - define area <polygon[<context.query.get[destination]>]>
            - define center <[area].corners.first.with_x[<[area].corners.parse[x].average>].with_y[<[area].min_y.add[<[area].max_y>].div[2]>].with_z[<[area].corners.parse[z].average>]>
            - define areaType polygon

        - if <[areaType]> == null:
          - define data.success false
        - else:
          - if <[areaType]> != location:
            - teleport <[center]> player:<[player]>
            - if <script[seltool_command].exists>:
              - flag <[player]> seltool_selection:<[area]>
              - flag <[player]> seltool_type:<[areaType]>
              - execute as_player selshow player:<[player]>
            - if <plugin[Depenizen].exists> && <plugin[WorldEdit].exists>:
              - adjust <[player]> we_selection:<[area]>
          - define data.success true

      - case load_player:
        - define p <context.query.get[player]||>
        - if <player[<[p]>].is_player>:
          ## % ██ [ .flag_map is not an error in this case (ignore Denizen Script Checker) ] ██:
          - define data <player[<[p]>].flag_map>
          - if !<[perms.secrets]>:
            - define data.dnbrowse.secret:!
        - else:
          - definemap data:
            error: "Unknown player '<[p]>'"

      - case load_notes:
        - define data <map>
        - foreach locations|cuboids|ellipsoids|polygons|inventories as:type:
          - foreach <server.notes[<[type]>]> as:note:
            - define data.<[type]>.<[note]>.name <[note].note_name>
            - if <[note].flag_map.exists> && <[note].flag_map.size> > 0:
              - define data.<[type]>.<[note]>.flags:<[note].flag_map>
            - choose <[type]>:
              - case locations:
                - define data.<[type]>.<[note]>.xyz <[note].xyz>
                - define data.<[type]>.<[note]>.yaw <[note].yaw>
                - define data.<[type]>.<[note]>.pitch <[note].pitch>
                - define data.<[type]>.<[note]>.world <[note].world.name>
              - case cuboids:
                - define data.<[type]>.<[note]>.min <[note].min.xyz>
                - define data.<[type]>.<[note]>.max <[note].max.xyz>
                - define data.<[type]>.<[note]>.world <[note].world.name>
              - case ellipsoids:
                - define data.<[type]>.<[note]>.center <[note].location.xyz>
                - define data.<[type]>.<[note]>.size <[note].size.xyz>
                - define data.<[type]>.<[note]>.world <[note].world.name>
              - case polygons:
                - define data.<[type]>.<[note]>.corners <[note].corners.parse[xyz]>
                - define data.<[type]>.<[note]>.min_y <[note].min_y>
                - define data.<[type]>.<[note]>.max_y <[note].max_y>
                - define data.<[type]>.<[note]>.world <[note].world.name>
              - case inventories:
                - define data.<[type]>.<[note]>.slots <map>
                - define data.<[type]>.<[note]>.title <[note].title>
                - if <[note].script.exists>:
                  - define data.<[type]>.<[note]>.scriptname <[note].script.name>
                - foreach <[note].map_slots> key:slot as:item:
                  - definemap slotdata:
                    name: <[item].material.name>
                    material: <[item].material>
                  - if <[item].quantity> != 1:
                    - define slotdata.quantity:<[item].quantity>
                  - if <[item].effects_data.exists>:
                    - define slotdata.potion_effects:<[item].effects_data>
                  - if <[item].enchantment_map.size> > 0:
                    - define slotdata.enchantments:<[item].enchantment_map>
                  - if <[item].firework_data.exists> && <[item].firework_data.size> > 0:
                    - define slotdata.firework_data:<[item].firework_data>
                  - if <[item].has_display>:
                    - define slotdata.display:<[item].display>
                  - if <[item].has_lore>:
                    - define slotdata.lore:<[item].lore>
                  - if <[item].skull_skin.exists>:
                    - define slotdata.skull_skin:<[item].skull_skin>
                  - if <[item].hides.size> > 0:
                    - define slotdata.hides:<[item].hides>
                  - if <[item].script.exists>:
                    - define slotdata.scriptname:<[item].script.name>
                  - if <[item].flag_map.size> > 0:
                    - define slotdata.flags:<[item].flag_map>
                  # % ██ [ Check for any additional properties which have not been handled manually ] ██:
                  - foreach <[item].property_map> key:prop as:value:
                    - if <script[dnbrowse_events].data_key[data.properties].contains[<[prop]>]>:
                      - define prop <script[dnbrowse_events].data_key[data.properties].get[<[prop]>]>
                    - if !<[slotdata].contains[<[prop]>]>:
                      - define slotdata.<[prop]>:<[value]>
                  - define data.<[type]>.<[note]>.slots.<[slot]> <[slotdata]>

      - default:
        - definemap data:
          error: "Unrecognised action '<context.query.get[action]>'"
    - determine raw_text_content:<[data].to_json>

  # % ██ [ Static files                      ] ██:
  - define fileext <context.path.after_last[.]>
  - if <context.path.starts_with[/dnbrowse/]> && <context.path.after[/dnbrowse/].before_last[.].matches_character_set[abcdefghijklmnopqrstuvwxyz0123456789_-]> && <context.path.length> < 50 && <script[dnbrowse_events].data_key[data.content_types].contains[<[fileext]>]>:
    # % ██ [ File name is within /dnbrowse/ and has a supported fileext ] ██:
    - determine code:200 passively
    - definemap headers:
      Content-Type: <script[dnbrowse_events].data_key[data.content_types].get[<[fileext]>]>
      Cache-Control: max-age=86400
    - determine headers:<[headers]> passively
    - determine file:<context.path>

  # % ██ [ Deny everything else              ] ██:
  # todo: todo: replace 401 at end to 404
  # %%% : won't give the pleasure of letting people know it's a valid path
  - determine code:401 passively
  - determine headers:[Content-Type=text/plain] passively
  - determine "raw_text_content:Permission denied"
