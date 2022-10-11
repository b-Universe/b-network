# | <[target]> is the playertag/npctag to change the skin of
# |            (npctag only if it's a valid player's name)
# | <[default_name]> is the default skin name to use if the APIs fail to generate a new skin
# |            (this is saved in the default_skins data script below)
# | eg: run skin_overlayer def:<[target]>|<[default_name]>
# | eg: run skin_overlayer def:<player>|Pescetarian_Puffman
skin_overlayer:
    type: task
    debug: false
    definitions: target|default_name
    script:
      - if <server.has_flag[behr.essentials.saved_skins.<[target].name>.<[default_name]>.skin_blob]>:
        - adjust <[target]> skin_blob:<server.flag[behr.essentials.saved_skins.<[target].name>.<[default_name]>.skin_blob]>
        - stop

      - define combine_api_url https://image-merger.herokuapp.com/api/v1.0/merge-images/
      - define mineskin_api_url https://api.mineskin.org/generate/url
      - definemap data:
          #foreground_url: <script[default_skins].parsed_key[defaults.<[default_name]>.overlay_url]>
          foreground_url: <server.flag[behr.essentials.saved_skins.<[target].name>.url].if_null[<script[default_skins].parsed_key[defaults.<[default_name]>.overlay_url]>]>
          background_url: https://minotar.net/skin/<[target].name>.png
      - definemap headers:
          Content-Type: application/json
          User-Agent: B

      - repeat 4:
        - if !<server.has_flag[behr.essentials.saved_skins.<[target].name>.url]>:
          - ~webget <[combine_api_url]> data:<[data].to_json> headers:<[headers]> save:response
          - if !<entry[response].failed>:
            - flag server behr.essentials.saved_skins.<[target].name>.url:<util.parse_yaml[<entry[response].result>].deep_get[output_image.url]> expire:30d
          - else:
            - wait 3s
            - repeat next

        - define data.url <server.flag[behr.essentials.saved_skins.<[target].name>.url]>

        - if !<server.has_flag[behr.essentials.saved_skins.<[target].name>.<[default_name]>.skin_blob]>:
          - ~webget <[mineskin_api_url]> method:POST data:<[data].to_json> headers:<[headers]> timeout:5s save:response
          - if !<entry[response].failed>:
            - define skin_blob <util.parse_yaml[<entry[response].result>].deep_get[data.texture.value]>;<util.parse_yaml[<entry[response].result>].deep_get[data.texture.signature]>
            - flag server behr.essentials.saved_skins.<[target].name>.<[default_name]>.skin_blob:<[skin_blob]> expire:30d
          - else:
            - wait 3s
            - repeat next

        - else:
          - define skin_blob <server.flag[behr.essentials.saved_skins.<[target].name>.<[default_name]>.skin_blob]>

      - define skin_blob <script[default_skins].parsed_key[defaults.<[default_name]>.skin_blob]> if:!<[skin_blob].exists>
      - adjust <[target]> skin_blob:<[skin_blob]>

skin_overlay_collection_command:
  type: command
  debug: false
  name: skin_overlay_collection
  description: Manages skins for the skin overlaying system
  usage: /skin_overlay_collection add/edit/remove <&lt>overlay_name<&gt> <&lt>url<&gt>
  permission: behr.essentials.skin_overlay_collection
  tab completions:
    1: add|edit|remove
    2: <server.flag[behr.essentials.saved_skins].keys.if_null[<empty>]>
  script:
    - if <context.args.is_empty>:
      - narrate "<&c>You have to add, edit, or remove entries"
      - stop

    - if <context.args.size> > 4:
      - narrate "<&c>You only can add, edit, or remove overlay names by url"
      - narrate "<&6>/<&e>skin_overlay_collection <&6><&lt><&e>add<&6>/<&e>edit<&6>/<&e>remove<&6><&gt> <&lt><&e>overlay_name<&6><&gt> <&lt><&e>url<&6><&gt>"
      - stop

    - if !<context.args.first.advanced_matches[add|edit|remove]>:
      - narrate "<&c>You can only add, edit, or remove overlay entries"
      - stop

    - if <context.args.size> < 2:
      - narrate "<&c>You have to specify a skin overlay entry to manage"
      - stop

    - define overlay_name <context.args.get[2]>

    - if <context.args.size> < 3 && <context.args.first> != remove:
      - narrate "<&c>You have to specify a url for the skin to generate the skin blob for"
      - stop
    - else:
      - define skin_url <context.args.get[3]>
      - if !<[skin_url].before[?].ends_with[.png]>:
        - narrate "<&[error]>That URL isn't likely to be valid. Make sure you have a direct image URL, ending with <&[emphasis]>'.png'<&[error]>."

    - choose <context.args.first>:
      - case add:
        - if !<server.has_flag[behr.essentials.saved_skins.<[overlay_name]>]>:
          - inject skin_overlay_collection_command.sub_scripts.grab_skin
          - flag server behr.essentials.saved_skins.<[overlay_name]>.url:<[skin_url]>
          - flag server behr.essentials.saved_skins.<[overlay_name]>.skin_blob:<[skin_blob]>
          - narrate "<&a>Added <&e><[overlay_name]> <&a>to the saved skin overlays"
        - else:
          - narrate "<&c>That skin overlay entry already exists - did you mean to edit it?"

      - case edit:
        - if <server.has_flag[behr.essentials.saved_skins.<[overlay_name]>]>:
          - if <[skin_url]> == <server.flag[behr.essentials.saved_skins.<[overlay_name]>.url]>:
            - narrate "<&c>This is the same url already used - did you mean a different url?"
            - stop

          - inject skin_overlay_collection_command.sub_scripts.grab_skin
          - flag server behr.essentials.saved_skins.<[overlay_name]>.url:<[skin_url]>
          - flag server behr.essentials.saved_skins.<[overlay_name]>.skin_blob:<[skin_blob]>
          - narrate "<&a>Edited <&e><[overlay_name]><&a><&sq>s in the saved skin overlays"
        - else:
          - narrate "<&c>That skin overlay entry doesn't exist - did you mean  to add it?"

      - case remove:
        - if <server.has_flag[behr.essentials.saved_skins.<[overlay_name]>]>:
          - flag server behr.essentials.saved_skins.<[overlay_name]>:!
          - narrate "<&a>Removed <&e><[overlay_name]> <&a>from the saved skin overlays"
        - else:
          - narrate "<&c>That skin overlay entry doesn't exist"

  sub_scripts:
    grab_skin:
      - define mineskin_api_url https://api.mineskin.org/generate/url
      - definemap headers:
          Content-Type: application/json
          User-Agent: B
      - define data.url <[skin_url]>
      - ~webget <[mineskin_api_url]> method:POST data:<[data].to_json> headers:<[headers]> timeout:5s save:response

      - if !<entry[response].failed>:
        - define skin_blob <util.parse_yaml[<entry[response].result>].deep_get[data.texture.value]>;<util.parse_yaml[<entry[response].result>].deep_get[data.texture.signature]>
        - flag server behr.essentials.saved_skins.<[overlay_name]>.skin_blob:<[skin_blob]> expire:30d
      - else:
        - narrate "<&c>Something went wrong, is the link valid?"
        - stop


default_skins:
  type: data
  debug: false
  defaults:
    Pescetarian_Puffman:
      overlay_url: https://cdn.discordapp.com/attachments/980166207426670633/984184991128891492/puffer_overlay.png
      skin_blob: ewogICJ0aW1lc3RhbXAiIDogMTY1NDcxOTI4NDA2MiwKICAicHJvZmlsZUlkIiA6ICIxNmFkYTc5YjFjMDk0MjllOWEyOGQ5MjgwZDNjNjE5ZiIsCiAgInByb2ZpbGVOYW1lIiA6ICJMYXp1bGl0ZV9adG9uZSIsCiAgInNpZ25hdHVyZVJlcXVpcmVkIiA6IHRydWUsCiAgInRleHR1cmVzIiA6IHsKICAgICJTS0lOIiA6IHsKICAgICAgInVybCIgOiAiaHR0cDovL3RleHR1cmVzLm1pbmVjcmFmdC5uZXQvdGV4dHVyZS9hNTNjMTA2Mjc0ZTY4NWY3ZjUwMzU5MzNkYzhhNDMwM2IyZjhhYjNlYjFhYzY4YjcyNTEwNjA0ZjM4Mzg0ZjVkIgogICAgfQogIH0KfQ==;Bzw2pn0Xeq04thd5FUbe5UT4YYRbtbcAerPEjW/kfDECOV+wyB2VqyR3vYdIHz3Jz9PoM9LeqFc4fywQFWemC+vyXU273wO2+bUp8jmF6DYiQxpNH365Ln6dtnkYR0th1/WYINkLVUTZLwzy5QzSfRYQ08bi7C5PN2BUw14t+ulJmwtGbU4vSEJbRYm6x9HKQqoRA1VHD2W/BcLahcuERhYDrjBqlrJXMqx0gcPDk9h3gs46N/ERRY5Rok7YX+TcP4cZ4J2f9wc8MWO9Efsmev5UL9teBj7Y4r0suDjhyUr3suE4Yl9umXE3c/Rk7o/LmRd8oaE1a4tkdrJ1ec63/p0M1jh0JnAyGMfnH4+/2XQ8oAXvu6xngYBmtQw90eRLJnbsK/ABYH+nCnUnxsJAL+/wYgwdMClnH9mko7h7wiVLejtYgzNlCysVfb8qBv6f82yRAHRKbKPxJrsEyhOfWi6ow8mSHAD6N7nBxXHbj1zF1Y83AiKZ3moGJ6ZOs6VBDOcXqOkCeNuZEyANRNSRdyrrSkFgen0j/WSUHI3ta2lQ+RfXkgZ87FSED7HErgcPxAh06zUXJgkO0eJP8I7Bzu/mfKFJoLhghGqrcd5G7x+uXGnV3nzPllCt6C1D3r/6gwKatYs93xN2lvRsvokeTp/4KFz0xcxHc0gSnivbxwU=
