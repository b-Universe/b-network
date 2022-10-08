# % current features:
# + chat history loaded on join
# + messages can be deleted
# + admins can opt into seeing deleted message
# + message delete button can be hidden/shown
# + all players can dismiss specific event messages, like player join/quit/vote
# + message dismiss button can be hidden/shown
# + chat setting for hiding / showing channel buttons
# + click player names to pre-type /msg <player.name>
# + shift-click player names to insert a ping
# + shift-click message text to pre-type into chat
# + chat channels
# todo: - chat pings
# todo: - nicknames
# todo: - stacking duplicate text? "this is a spam message(6)" instead of the same message 6x in a row
# todo: - discord relay
# todo: - discord pings
# todo: - discord cross-over emojis?
# todo: - delete messages that are deleted in-game on discord
# todo: - chat settings gui
# todo: - chat setting for ignoring pings
# todo: - chat setting for disabling player event messages like join/quit/vote
# todo: - chat channel gui
# todo: - chat channel setting for the button colors
# todo: - customizable channels like parties and private chat
# todo: - for customizable channels- commands for creating the channel, deleting it, adding people / friends from friends list, channel listing for public channels, permissions, and the settings
# todo: - for customizable channels- permissions for who can add/remove people, change settings, change player's permissions
# todo: - for customizable channels- settings for changing name, color, who can talk, and if it's a public channel or not
# todo: - separate admin chat from players lol
# todo: - embed url links

chat_formatting:
  type: world
  debug: false
  events:
    on server start:
      - yaml id:behr.essentials.chat.history create
      - yaml id:behr.essentials.chat.history set chat

    on player chats:
      - determine cancelled passively
      - define message <context.message.proc[player_chat_format]>
      - define time <util.time_now>
      - clickable delete_player_message def:<[time]> usages:1 save:delete_button
      - define delete_button "<element[<&4><&lb><&c>✖<&4><&rb>].on_click[<entry[delete_button].command>].on_hover[click to delete]> <&b>| <&r>"
      - definemap chat_history:
          channel: player_chat
          message: player_chat/<[message]>
          delete: <[delete_button]>
          time: <[time]>
          user_uuid: <player.uuid>
      - yaml id:behr.essentials.chat.history set chat.<[time].epoch_millis>:<[chat_history]>
      - narrate <[chat_history.message]> targets:<server.online_players> from:<player.uuid>

      - run discord_player_chat defmap:<[chat_history]>


    on player receives message:
    # % ██ [ create initial definitions ] ██
      - define raw_message <context.message>
      - define message_channel <[raw_message].before[/]>
      - define message <[raw_message].after[/]>
      - define time <util.time_now>
      - define player_channel <player.flag[behr.essentials.chat.channel].if_null[all]>

    # % ██ [ check for channel to use ] ██
      - if <[player_channel]> == all:
        - define content <yaml[behr.essentials.chat.history].read[chat]>
      - else:
        - define content <yaml[behr.essentials.chat.history].read[chat].filter_tag[<[filter_value].get[channel].equals[<[player_channel]>]>]>

    # % ██ [ verify if a channel exists for incoming message ] ██
      - if !<list[player_chat|actions].contains[<[message_channel]>]> && !<[content].values.parse[get[message].strip_color].contains[<[raw_message].strip_color>]>:
        - clickable dismiss_system_message def:<[time]> usages:1 save:dismiss_button
        - define dismiss_button "<element[<&4><&lb><&c>✖<&4><&rb>].on_click[<entry[dismiss_button].command>].on_hover[click to dismiss]> <&b>| <&r>"
        #- define dismiss_button "<element[✖.].proc[unselected_button_maker].context[<&f>|<&c>].on_click[<entry[dismiss_button].command>].on_hover[click to dismiss]><&r> "
        - definemap chat_history:
            channel: system
            message: system/<[raw_message]>
            dismiss: <[dismiss_button]>
            time: <[time]>
            uuid: <util.random_uuid>

    # % ██ [ add message to system channel ] ██
        - yaml id:behr.essentials.chat.history set chat.<util.time_now.epoch_millis>:<[chat_history]>
      - if <yaml[behr.essentials.chat.history].read[chat].size> > 30:
        - yaml id:behr.essentials.chat.history set chat.<[content].keys.lowest>:!

    # % ██ [ redefine chat with changes ] ██
    # todo: instead of redefining, just insert the new data to the definition
      - if <[player_channel]> == all:
        - define content <yaml[behr.essentials.chat.history].read[chat]>
      - else:
        - define content <yaml[behr.essentials.chat.history].read[chat].filter_tag[<[filter_value].get[channel].equals[<[player_channel]>]>]>

      - define content <[content].values>

    # % ██ [ show/hide deleted messages ] ██
      - if !<player.has_flag[behr.essentials.chat.settings.show_deleted_messages]>:
                                                                            # todo: && <player.has_flag[behr.essentials.permissions.admin]>:
        - define content <[content].filter_tag[<[filter_value].contains[deleted].not>]>

    # % ██ [ sort messages by time ] ██
      - define content <[content].sort_by_value[get[time].epoch_millis]>

    # % ██ [ insert delete and dismissable buttons ] ██
      - if <player.has_flag[behr.essentials.chat.settings.show_delete_controls]>:
                                                                          # todo: && <player.has_flag[behr.essentials.permissions.admin]>:
        - if <player.has_flag[behr.essentials.chat.settings.show_dismiss_controls]>:
          - define content <[content].parse_tag[<[parse_value].get[delete].if_null[<empty>]><[parse_value].get[dismiss].if_null[<empty>]><[parse_value].get[message].after[/]>]>
        - else:
          - define content <[content].parse_tag[<[parse_value].get[delete].if_null[<empty>]><[parse_value].get[message].after[/]>]>
      - else:
        - if <player.has_flag[behr.essentials.chat.settings.show_dismiss_controls]>:
          - define content <[content].parse_tag[<[parse_value].get[dismiss].if_null[<empty>]><[parse_value].get[message].after[/]>]>
        - else:
          - define content <[content].parse_tag[<[parse_value].get[message].after[/]>]>

    # % ██ [ create channel buttons ] ██
      - if !<player.has_flag[behr.essentials.chat.settings.hide_channel_buttons]>:
        - define channel_buttons <list>
        - foreach all|player_chat|system|admin as:channel_button:
          - if !<player.has_flag[behr.essentials.chat.settings.channel.<[channel_button]>.hide]>:
            - if <[player_channel]> == <[channel_button]>:
              - define text <[channel_button].proc[selected_button_maker].context[<&a>|<&2>]>
            - else:
              - define text <[channel_button].proc[unselected_button_maker].context[<black>|<white>]>
            - define hover "Click to change to channel<&co><n><[channel_button]>"
            - define command "/chat_channel <[channel_button]> quietly"
            - define channel_buttons <[channel_buttons].include_single[<[text].on_hover[<[hover]>].on_click[<[command]>]>]>
        - define channel_buttons "<n><&r><[channel_buttons].separated_by[ ]>"

      - determine message:<n.repeat[100]><[content].separated_by[<&r><n>]><[channel_buttons].if_null[<empty>]>

delete_player_message:
  type: task
  definitions: time
  script:
    - define content <yaml[behr.essentials.chat.history].read[chat.<[time].epoch_millis>]>
    - define new_message <[content.message].before[/]>/<[content.message].after[/].strip_color.color[gray].on_hover[<&[red]>Deleted by <&e><player.name>]>
    - yaml id:behr.essentials.chat.history set chat.<[time].epoch_millis>.deleted:<util.time_now>
    - yaml id:behr.essentials.chat.history set chat.<[time].epoch_millis>.message:<[new_message]>
    - announce actions/reload

dismiss_system_message:
  type: task
  definitions: time
  script:
    - define content <yaml[behr.essentials.chat.history].read[chat.<[time].epoch_millis>]>
    - yaml id:behr.essentials.chat.history set chat.<[time].epoch_millis>.deleted:<util.time_now>
    - announce actions/reload

discord_player_chat:
  type: task
  definitions: channel|message|time|player_uuid
  script:
    - debug debug "copy discord shit over"

chat_settings_command:
  type: command
  name: chat_settings
  description: adjusts your chat settings
  usage: /chat_settings show_deleted_messages
  tab completions:
    1: show_deleted_messages|show_delete_controls|show_dismiss_controls|hide_channel|show_channel
    2: all|chat|system|admin
  script:
    - if <context.args.is_empty>:
      - inject command_syntax_error
    - choose <context.args.first>:

      - case hide_channel:
        - if <context.args.size> != 2:
          - define reason "You must specify a channel to hide"
          - inject command_error
        - define channel <context.args.last>
        - if <player.has_flag[behr.essentials.chat.settings.channel.<[channel]>]>:
          - narrate "<&[yellow]><[chanel]> <&[green]>will now shown"
        - else:
          - narrate "<&[yellow]><[channel]> <&[green]>will now be hidden"

      - case show_channel:
        - if <context.args.size> != 2:
          - define reason "You must specify a channel to show"
          - inject command_error
        - define channel <context.args.last>
        - if <player.has_flag[behr.essentials.chat.settings.channel.<[channel]>]>:
          - narrate "<&[yellow]><[chanel]> <&[green]>will now shown"
        - else:
          - narrate "<&[yellow]><[channel]> <&[green]>will now be hidden"

      - case show_dismiss_controls:
        - if <player.has_flag[behr.essentials.chat.settings.show_dismiss_controls]>:
          - flag player behr.essentials.chat.settings.show_dismiss_controls:!
          - narrate "<&[green]>Message dismiss buttons will now be hidden"
        - else:
          - flag player behr.essentials.chat.settings.show_dismiss_controls
          - narrate "<&[green]>Message dismiss buttons will now be shown"

      - case show_delete_controls:
        - if <player.has_flag[behr.essentials.chat.settings.show_delete_controls]>:
          - flag player behr.essentials.chat.settings.show_delete_controls:!
          - narrate "<&[green]>Message control buttons will now be hidden"
        - else:
          - flag player behr.essentials.chat.settings.show_delete_controls
          - narrate "<&[green]>Message control buttons will now be shown"

      - case show_deleted_messages:
        - if <player.has_flag[behr.essentials.chat.settings.show_deleted_messages]>:
          - flag player behr.essentials.chat.settings.show_deleted_messages:!
          - narrate "<&[green]>Deleted messages will now be hidden"
        - else:
          - flag player behr.essentials.chat.settings.show_deleted_messages
          - narrate "<&[green]>Deleted messages will now be shown"

list_of_maps_chat_saving:
  type: task
  definitions: channel|message
  script:
    - definemap chat_history:
        message: <[channel]>/<[message]>
        time: <util.time_now>
        uuid: <util.random_uuid>
        user: <player.uuid>
    - yaml id:behr.essentials.chat.history set <[channel]>:->:<[chat_history]>
  chats_task:
    - determine cancelled passively
    - define message <context.message.proc[player_chat_format]>
    - definemap chat_history:
        message: player_chat/<[message]>
        time: <util.time_now>
        uuid: <util.random_uuid>
        user: <player.uuid>
    - yaml id:behr.essentials.chat.history set player_chat:->:<[chat_history]>
    - narrate player_chat/<[message]> targets:<server.online_players> from:<player.uuid>
  receives_task:
    - define raw_message <context.message>
    - define message_channel <[raw_message].before[/]>
    - define message <[raw_message].after[/]>

    - define player_channel <player.flag[behr.essentials.chat.channel].if_null[all]>

    - if <[player_channel]> == all:
      - define content <yaml[behr.essentials.chat.history].read[]>

    - if !<[content].values.combine.parse[get[message].strip_color].contains[<[raw_message].strip_color>]>:
      - definemap chat_history:
          message: system/<[raw_message]>
          time: <util.time_now>
          uuid: <util.random_uuid>
      - yaml id:behr.essentials.chat.history set system:->:<[chat_history]>
    - if <yaml[behr.essentials.chat.history].read[<[message_channel]>].size> > 2:
      - yaml id:behr.essentials.chat.history set <[message_channel]>[1]:<-
      - define content <yaml[behr.essentials.chat.history].read[]>

    - determine message:<n.repeat[10]><[content].values.combine.sort_by_value[get[time].epoch_millis].parse[as[map].get[message].after[/]].separated_by[<&r><n>]>


player_chat_format:
  type: procedure
  debug: false
  definitions: message
  script:
    # % ██ [ Format nameplate ] ██
    - define name_click "/msg <player.name> "
    - define name_hover <list>
    - if <player.has_flag[behr.essentials.nickname]>:
      - define name <player.flag[behr.essentials.nickname]>
      - define name_hover "<[name_hover].include_single[<&color[#F3FFAD]>Real Name<&color[#26FFC9]><&co> <&color[#C1F2F7]><player.name>]>"
    - else:
      - define name <player.name>

    - define name_hover "<[name_hover].include_single[<&color[#F3FFAD]>Click to message].include_single[<&color[#F3FFAD]>Shift-Click to mention]>"
    - define nameplate "<[name].on_hover[<[name_hover].separated_by[<n>]>].on_click[<[name_click]>].type[SUGGEST_COMMAND].with_insertion[@<player.name> ]>"

    # % ██ [ Check for Discord connection ] ██
    - if <player.has_flag[behr.essentials.discord.connected]>:
      - define name_hover "<[name_hover].include_single[<&color[#F3FFAD]>Discord<&color[#26FFC9]><&co> <&color[#C1F2F7]><player.flag[behr.essentials.discord.username]>]>"

    - define text_hover "<&color[#F3FFAD]>Timestamp<&color[#26FFC9]><&co> <&color[#C1F2F7]><util.time_now.format[E, MMM d, y h:mm a].replace[,].with[<&color[#26FFC9]>,<&color[#C1F2F7]>]>"
    - define message <[message].proc[chat_color_format].on_hover[<[text_hover]>].with_insertion[<[message]>]>

    - determine "<[nameplate]><&color[#C1F2F7]><&co> <[message]>"

chat_color_format:
  type: procedure
  debug: false
  definitions: text
  script:
    - if <[text].contains_text[&]>:
      - if <[text].starts_with[&]>:
        - if <color[<[text].char_at[2]>].is_truthy>:
          - define new_text <list_single[<&color[<[text].char_at[2]>]><[text].split[&].first.substring[3,999]>]>
        - else:
          - define new_text <list_single[<[text].split[&].first>]>
      - else:
        - define new_text <list_single[<[text].split[&].first>]>

      - foreach <[text].split[&].remove[first]> as:string:
        # @ hex coloring via &# prefix, eg &#FFFFFFwhite
        - if <[string].starts_with[<&ns>]> && <[string].length> > 8 && <[string].substring[2,7].matches_character_set[ABCDEFabcdef0123456789]>:
          - if <color[<[string].substring[1,7]>].is_truthy>:
            - define new_text <[new_text].include_single[<[string].substring[8,999].color[<[new_text].last.last_color.if_null[#C1F2F7]>].color[<[string].substring[1,7]>]>]>
          - else:
            - define new_text <[new_text].include_single[<[string].substring[8,999].color[<[new_text].last.last_color.if_null[#C1F2F7]>]>]>

        - else:
          - define tag <[string].char_at[1]>
          - choose <[tag]>:

        # @ standard &color-tags
            - case 0 1 2 3 4 5 6 7 8 9 a b c d e:
              - define last_format <[new_text].unseparated.last_color.if_null[<empty>]>

              - define new_text <[new_text].include_single[<&color[<[tag]>]>]>
              - foreach <bold>|<italic>|<strikethrough>|<underline> as:format:
                - if <[last_format].contains_text[<[format]>]>:
                  - define new_text <[new_text].include_single[<[format]>]>
              - define new_text <[new_text].include_single[<[string].substring[2,999]>]>

        # @ standard &format-tags
            - case l m n o:
              - if <[new_text].last.from_secret_colors.ends_with[rainbow].if_null[false]>:
                - define new_text <[new_text].remove[last].include_single[<element[<[new_text].last><&color[<[tag]>]><[string].substring[2,999]>].hex_rainbow><element[rainbow].to_secret_colors>]>
              - else:
                - define new_text <[new_text].include_single[<&color[<[tag]>]><[string].substring[2,999]>]>

        # @ return to my own white color-tag
            - case r f:
              - define new_text <[new_text].include_single[<reset><&color[#C1F2F7]><[string].substring[2,999]>]>

        # @ custom &z rainbow color-tag
            - case z:
              - define new_text <[new_text].include_single[<[string].after[z].hex_rainbow><element[rainbow].to_secret_colors>]>

        # @ custom &k comic sans color-tag
            - case k:
              - if <[new_text].last.from_secret_colors.ends_with[rainbow].if_null[false]>:
                - define new_text <[new_text].remove[last].include_single[<element[<&font[utility:comic_sans]><[new_text].last><&color[<[tag]>]><[string].substring[2,999]>].hex_rainbow><element[rainbow].to_secret_colors>]>
              - else:
                - define new_text <[new_text].include_single[<&font[utility:comic_sans]><[string].substring[2,999]>]>

        # @ default text
            - default:
              - define new_text <[new_text].include_single[<[new_text].last.last_color.if_null[<empty>]><[string]>]>

      - determine <[new_text].unseparated>

    # @ no formatting
    - else:
      - determine <[text]>

#- narrate <context.message.proc[player_chat_format]> targets:<server.online_players> from:<player.uuid>

selected_button_maker:
  type: procedure
  debug: false
  definitions: text|text_color|background_color
  data:
    button:
      - <[background_color]><&chr[2009].font[gui]>
      - <element[<proc[negative_spacing].context[1].font[utility:spacing]><&chr[2010].font[gui]>].repeat[<[width]>]>
      - <proc[negative_spacing].context[1].font[utility:spacing]><&chr[2011].font[gui]>
      - <proc[negative_spacing].context[<[width].mul[2].add[2]>].font[utility:spacing]>
  script:
    - define width <[text].text_width.div[2].round_up.add[1]>
    - determine <script.parsed_key[data.button].unseparated><[text_color]><[text]><&r><proc[positive_spacing].context[1].font[utility:spacing]>

unselected_button_maker:
  type: procedure
  debug: false
  definitions: text|text_color|background_color
  data:
    button:
      - <[background_color]><&chr[2006].font[gui]>
      - <element[<proc[negative_spacing].context[1].font[utility:spacing]><&chr[2007].font[gui]>].repeat[<[width]>]>
      - <proc[negative_spacing].context[1].font[utility:spacing]><&chr[2008].font[gui]>
      - <proc[negative_spacing].context[<[width].mul[2].add[2]>].font[utility:spacing]>
  script:
    - define width <[text].text_width.div[2].round_up.add[1]>
    - determine <script.parsed_key[data.button].unseparated><[text_color]><[text]><&r><proc[positive_spacing].context[1].font[utility:spacing]>

chat_channel_command:
  type: command
  debug: false
  name: chat_channel
  description: changes chat channels
  usage: /chat_channel <&lt>channel<&gt> (quietly)
  tab completions:
    1: all|chat|system|admin
    2: quietly
  aliases:
    - cc
  script:
    - if <context.args.is_empty> || <context.args.size> > 2:
      - inject command_syntax_error

    - define channel <context.args.first>
    - if !<list[all|player_chat|chat|system|admin].contains[<[channel]>]>:
      - define reason "Invalid chat channel picked"
      - inject command_error

    - if <player.flag[behr.essentials.chat.channel].if_null[all]> == <[channel]>:
      - stop if:<context.args.last.equals[quietly]>
      - define reason "You're already in that channel"
      - inject command_error

    - define channel player_chat if:<[channel].equals[chat]>
    - flag player behr.essentials.chat.channel:<[channel]>
    - if <context.args.last> == quietly:
      - narrate actions/reload
    - else:
      - narrate "<&[green]>You switched to the <&[yellow]><[channel]> <&[green]>channel"
