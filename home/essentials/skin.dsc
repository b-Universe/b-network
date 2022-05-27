
# $ ██ [ [c]usage:
# - ██ | [c]/skin help                     | Shows this list in-game
# - ██ | [c]/skin set name                 | Sets a skin by the name you saved -
# - ██ |                                     if it doesn't exist, you'll get whatever that player's name's skin is!
# - ██ | [c]/skin reset                    | Resets your skin to your default skin
# - ██ | [c]/skin rename old_name new_name | Renames a skin from old_name to the new_name specified
# - ██ | [c]/skin save player_name         | Saves a skin by the player_name's skin
# - ██ | [c]/skin save name url (slim)     | Saves a skin by the URL pasted - optionally making
# - ██ |                                     it slim if specified - defaults to regular / nothing
# - ██ | [c]/skin list                     | Lists the skins you've saved
# - ██ | [c]/skin delete name              | Deletes a skin by the name you saved
skin_command:
  type: command
  name: skin
  debug: false
  description: Manages your player's skin.
  usage: /skin reset/set <&lt>name<&gt>/save <&lt>player_name<&gt>/save <&lt>name<&gt> <&lt>URL<&gt> (slim)/list/delete <&lt>name<&gt>/rename <&lt>old name<&gt> <&lt>new name<&gt>
  tab complete:
    - define commands <list[delete|help|list|rename|reset|save|set]>
    - if <context.args.is_empty>:
      - determine <[commands]>

    - define arg_count <context.args.size>
    - if "<context.raw_args.ends_with[ ]>":
      - define arg_count:++

    - if <[arg_count]> == 1:
      - determine <[commands].filter[starts_with[<context.args.first>]]>

    - else if <[arg_count]> == 2 && <context.args.first.advanced_matches[delete|rename|set]> && <player.has_flag[super_suit_saved_skins]>:
      - determine <player.flag[super_suit_saved_skins].keys.filter[starts_with[<context.args.get[2]||>]]>

    - else if <[arg_count]> == 4 && <context.args.first> == save:
      - determine <list[slim|regular].filter[starts_with[<context.args.get[4]||>]]>

  syntax:
    - narrate "<&[base]>Available skin commands: <&[emphasis]><list[delete|list|rename|reset|save|set].separated_by[<&[base]>, <&[emphasis]>]> <&b><strikethrough>  <&[base]>or <&6>/<&[emphasis]>skin help<&[base]> for help!"
    - stop

  script:
  # @ ██ [ Check for args ] ██
    - if <context.args.is_empty>:
      - inject skin_command.syntax

    - choose <context.args.first>:
    # @ ██ [ /skin help - Shows the list of /skin commands ] ██
      - case help:
        - narrate "<&b><&sp.repeat[20].strikethrough><&b>[ <&6>/<&[emphasis]>skin <&[base]>command help list <&b>]<&sp.repeat[20].strikethrough>"
        - narrate "<&[emphasis]>/skin help <&b><strikethrough>  <&[base]> Shows this list!"
        - narrate "<&[emphasis]>/skin set <&6><&lt><&[emphasis]>name<&6><&gt> <&b><strikethrough>  <&[base]> Sets a skin by the name you saved - if it doesn't exist, you'll get whatever that player's name's skin is!"
        - narrate "<&[emphasis]>/skin reset <&b><strikethrough>  <&[base]> Resets your skin to your default skin"
        - narrate "<&[emphasis]>/skin rename <&6><&lt><&[emphasis]>old_name<&6><&gt> <&lt><&[emphasis]>new_name<&6><&gt> <&b><strikethrough>  <&[base]> Renames a skin from old_name to the new_name specified"
        - narrate "<&[emphasis]>/skin save <&6><&lt><&[emphasis]>player_name<&6><&gt> <&b><strikethrough>  <&[base]> Saves a skin of the player_name's skin"
        - narrate "<&[emphasis]>/skin save <&6><&lt><&[emphasis]>name<&6><&gt> <&6><&lt><&[emphasis]>url<&6><&gt> <&6>(<&[emphasis]>slim/regular<&6>) <&b><strikethrough>   <&[base]> Saves a skin by the URL pasted - optionally making it slim if specified"
        - narrate "<&[emphasis]>/skin list <&b><strikethrough>  <&[base]> Lists the skins you've saved"
        - narrate "<&[emphasis]>/skin delete <&6><&lt><&[emphasis]>name<&6><&gt> <&b><strikethrough>  <&[base]> Deletes a skin by the name you saved"

    # @ ██ [ /skin reset - Resets the player's skin to their own ] ██
      - case reset:
        - adjust <player> skin:<player.name>
        - narrate "<&[base]>Skin reset."

    # @ ██ [ /skin set <name> - Sets the player's skin to the <name> they save their skin as ] ██
      - case set:
        - if <context.args.size> == 1:
          - narrate "<&[error]>You have to specify a name to set your skin to."
          - stop

        - if <context.args.size> != 2:
          - inject skin_command.syntax

      # @ ██ [ Check if player saved skin ] ██
        - define skin_name <context.args.last>
        - define original_skin <player.skin_blob>
        - if <player.has_flag[super_suit_saved_skins.<[skin_name]>]>:
          # @ ██ [ Skin the owner player's skin if skin name not saved ] ██
          - adjust <player> skin_blob:<player.flag[super_suit_saved_skins.<[skin_name]>]>
          - narrate "<&[base]>Skin set to: <&[emphasis]><[skin_name]><&[base]>."
          - stop
        - else if !<[skin_name].matches_character_set[abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ-_]>:
            - narrate "<&[emphasis]><[skin_name]> <&[error]>is not a valid player name."
            - stop
        - adjust <player> skin:<[skin_name]>
        - if <[original_skin]> == <player.skin_blob>:
          - narrate "<&[error]>An unexpected error occured using the player name <&[emphasis]><[skin_name]><&[error]>. Is it a valid player with a skin?"
        - else:
          - narrate "<&[base]>Skin set to: <&[emphasis]><[skin_name]><&[base]>."

    # @ ██ [ /skin save <player_name> - Saves a skin by the player_name's skin ] ██
    # @ ██ [ /Skin save name URL (slim) | Saves a skin by the URL pasted - optionally making it slim if specified ] ██
      - case save:
        - if <context.args.size> == 1:
          - narrate "<&[error]>You must specify either a player's name or a name and a URL of the skin you want to save."
          - stop
        - if <context.args.size> > 4:
          - inject skin_command.syntax

        - define skin_name <context.args.get[2]>

      # @ ██ [ Check if the player already has a skin saved as this name ] ██
        - if <player.has_flag[super_suit_saved_skins.<[skin_name]>]>:
          - narrate "<&[error]>You already have a skin saved under the name <&[emphasis]><[skin_name]><&[error]>."
          - stop

      # @ ██ [ Check if specifying a player's name instead of name&URL ] ██
        - if <context.args.size> == 2:
          - if !<[skin_name].matches_character_set[abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ-_]>:
            - narrate "<&[emphasis]><[skin_name]> <&[error]>is not a valid player name."
            - stop
          - define original_skin <player.skin_blob>
          - adjust <player> skin:<[skin_name]>
          - if <[original_skin]> == <player.skin_blob>:
            - narrate "<&[error]>An unexpected error occured using the player name <&[emphasis]><[skin_name]><&[error]>. Is it a valid player with a skin?"
          - else:
            - flag player super_suit_saved_skins.<[skin_name]>:<player.skin_blob>
            - narrate "<&[base]>Skin saved and set to: <&[emphasis]><[skin_name]><&[base]>."
          - stop

        - define skin_url <context.args.get[3]||null>
        - if <[skin_url]> == null:
          - narrate "<&[error]>You must specify a valid skin URL."
          - stop
        - define skin_model <context.args.get[4].to_lowercase||regular>

        - if !<[skin_url].before[?].ends_with[.png]>:
            - narrate "<&[error]>That URL isn't likely to be valid. Make sure you have a direct image URL, ending with <&[emphasis]>'.png'<&[error]>."

      # @ ██ [ Validate skin model ] ██
        - if !<[skin_model].advanced_matches[slim|regular]>:
          - narrate "<&[error]>You can only specify regular/nothing for the default model type, or the slim model type."
          - stop

      # @ ██ [ webget skin from api ] ██
        - narrate "<&[base]>Retrieving the requested skin..."
        - run skin_url_task def:<[skin_url]>|<[skin_model]> save:new_queue
        - while <entry[new_queue].created_queue.state> == running:
          - if <[loop_index]> > 120:
            - queue <entry[new_queue].created_queue> clear
            - narrate "<&[error]>The request timed out. Is the url valid?"
            - stop
          - wait 5t
        - if <entry[new_queue].created_queue.determination.first||null> == null:
            - narrate "<&[error]>Failed to retrieve the skin from the provided link. Is the url valid?"
            - stop
        - define result_data <util.parse_yaml[<entry[new_queue].created_queue.determination.first>]>
        - if !<[result_data].contains[data]>:
            - narrate "<&[error]>An unexpected error occurred while retrieving the skin data. Please try again."
            - stop

      # @ ██ [ Save & adjust the player's skin ] ██
        - define original_skin <player.skin_blob>
        - define skin_blob <[result_data].deep_get[data.texture.value]>;<[result_data].deep_get[data.texture.signature]>
        - adjust <player> skin_blob:<[skin_blob]>
        - if <[original_skin]> == <player.skin_blob>:
          - narrate "<&[error]>An unexpected error occured using the URL:<&[emphasis]><[skin_url]><&[error]>. Is it a valid URL?"
        - else:
          - flag player super_suit_saved_skins.<[skin_name]>:<[skin_blob]>
          - narrate "<&[base]>Skin saved and set to: <&[emphasis]><[skin_name]>"

    # @ ██ [ /delete <skin_name> -  Deletes the player's saved skin by this name ] ██
      - case delete:
        - if <context.args.size> == 1:
          - if <player.has_flag[super_suit_saved_skins]>:
            - narrate "<&[error]>You have to specify a skin name to delete."
          - else:
            - narrate "<&[error]>You have to specify a skin name to delete, but have no skins to delete anyways!"
          - stop
        - if <context.args.size> != 2:
          - inject skin_command.syntax

      # @ ██ [ Check if name to delete even exists ] ██
        - define skin_name <context.args.get[2]>
        - if <player.has_flag[super_suit_saved_skins]>:
          - if !<player.flag[super_suit_saved_skins].contains[<[skin_name]>]>:
            - narrate "<&[error]>There's no skin saved under the name <&[emphasis]><[skin_name]><&[error]>."
            - stop
        - else:
          - narrate "<&[error]>You have no skins saved."
          - stop

        - define skin_blob <player.flag[super_suit_saved_skins.<[skin_name]>]>
        - flag player super_suit_saved_skins.<[skin_name]>:!
        - narrate "<&[base]>Deleted the skin saved under the name: <&[emphasis]><[skin_name]>"

    # @ ██ [ /skin list - Shows you the list of saved skins ] ██
      - case list:
        - if <context.args.size> != 1:
          - inject skin_command.syntax

      # @ ██ [ Check if player even has skins ] ██
        - if !<player.has_flag[super_suit_saved_skins]>:
          - narrate "<&[error]>You have no saved skins."
          - stop

        - narrate "<&[base]>Available skins saved: <&[emphasis]><player.flag[super_suit_saved_skins].keys.separated_by[<&[base]>, <&[emphasis]>]>"

    # @ ██ [ /skin rename <old_name> <new_name> - Renames a skin from <old_name> to <new_name> ] ██
      - case rename:
        - if <context.args.size> != 3:
          - inject skin_command.syntax

      # @ ██ [ Check if player even has skins ] ██
        - if !<player.has_flag[super_suit_saved_skins]>:
          - narrate "<&[error]>You have no saved skins."
          - stop

      # @ ██ [ Check if old skin name is valid ] ██
        - define old_skin_name <context.args.get[2]>
        - if <player.has_flag[super_suit_saved_skins]>:
          - if !<player.flag[super_suit_saved_skins].contains[<[old_skin_name]>]>:
            - narrate "<&[error]>You don't have a skin saved under the name <&[emphasis]><[old_skin_name]><&[error]>"
            - stop

      # @ ██ [ Check if new skin name exists already ] ██
        - define new_skin_name <context.args.get[3]>
        - if <player.flag[super_suit_saved_skins].contains[<[new_skin_name]>]>:
          - narrate "<&[base]>The specified skin name already exists: <&[emphasis]><[new_skin_name]><&[base]>."
          - stop

      # @ ██ [ Swaperonies ] ██
        - define skin_blob <player.flag[super_suit_saved_skins.<[old_skin_name]>]>
        - flag player super_suit_saved_skins.<[new_skin_name]>:<[skin_blob]>
        - flag player super_suit_saved_skins.<[old_skin_name]>:!
        - narrate "<&[base]>Renamed the skin: <&[emphasis]><[old_skin_name]> <&[base]>to: <&[emphasis]><[new_skin_name]><&[base]>."

    # @ ██ [ /skin <anything else> - This is when a player types a skin command that doesn't exist, like /skin lasagna ] ██
      - default:
        - inject skin_command.syntax

# - Thanks mergu & mcmonkey
skin_url_task:
  type: task
  debug: false
  definitions: url|model
  script:
    - define req https://api.mineskin.org/generate/url
    - if <[model]> == slim:
      - define req <[req]>?model=slim
    - ~webget <[req]> post:url=<[url]> timeout:30s save:web_result
    - determine <entry[web_result].result.if_null[null]>
