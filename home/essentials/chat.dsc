#   @   ██ [ current features ] ██
#   %   ██ chat history loaded on join
#   %   ██ messages can be deleted
#   %   ██ admins can opt into seeing deleted message
#   %   ██ message delete button can be hidden/shown
#   %   ██ all players can dismiss specific event messages, like player join/quit/vote
#   %   ██ message dismiss button can be hidden/shown
#   %   ██ chat setting for hiding / showing channel buttons
#   %   ██ click player names to pre-type /msg <player.name>
#   %   ██ shift-click player names to insert a ping
#   %   ██ shift-click message text to pre-type into chat
#   %   ██ chat channels
#   %   ██ delete messages that are deleted in-game on discord
#   %   ██ discord relay
# todo: ██ - individualize system messages and dismissable messages
# todo: ██ - chat pings
# todo: ██ - nicknames
# todo: ██ - stacking duplicate text? "this is a spam message(6)" instead of the same message 6x in a row
# todo: ██ - discord pings
# todo: ██ - discord cross-over emojis?
# todo: ██ - /edit_message command that enables a one-time edit button for messages to be edited
# todo: ██ - chat settings gui
# todo: ██ - chat setting for ignoring pings
# todo: ██ - chat setting for disabling player event messages like join/quit/vote
# todo: ██ - chat channel gui
# todo: ██ - chat channel setting for the button colors
# todo: ██ - customizable channels like parties and private chat
# todo: ██ - for customizable channels- commands for creating the channel, deleting it, adding people / friends from friends list, channel listing for public channels, permissions, and the settings
# todo: ██ - for customizable channels- permissions for who can add/remove people, change settings, change player's permissions
# todo: ██ - for customizable channels- settings for changing name, color, who can talk, and if it's a public channel or not
# todo: ██ - separate admin chat from players lol
# todo: ██ - embed url links

chat_formatting:
  type: world
  debug: false
  data:
    debug_messages:
      - Denizen debugger is now recording. Use /denizen submit to finish.
      - Denizen debugger recording disabled.
      - Use /denizen debug -r  to record debug information to be submitted
      - Submitting...
      - Error while submitting.
      - Submit failed<&co> not recording.
      - Denizen debugger is now<&co> ENABLED.
      - Denizen debugger is now<&co> DISABLED.

  events:
    on server start:
      - yaml id:behr.essentials.chat.history create

    on player chats bukkit_priority:lowest:
      - determine cancelled passively
      - define message <context.message.proc[player_chat_format]>
      - define time <util.time_now>
      - define player_channel <player.flag[behr.essentials.chat.channel].if_null[all]>
      - define uuid <util.random.duuid>
      - if <[player_channel]> == system:
        - define player_channel <player.flag[behr.essentials.chat.last_channel]>
      - else if <[player_channel]> == all:
        - define player_channel player_chat

      - foreach <context.message.strip_color.split.filter[starts_with[@]]> as:ping:
        - if <[ping].after[@]> in <server.online_players.parse[name]>:
          - if !<player.has_flag[behr.essentials.chat.settings.pings_disabled]>:
            - toast "<player.name> pinged you" targets:<[ping]> icon:emerald

      - clickable delete_player_message def:<[time]> usages:1 save:delete_button until:<duration[1d]>
      - define delete_button "<element[<&4><&lb><&c>✖<&4><&rb>].on_click[<entry[delete_button].command>].on_hover[click to delete]> <&b>| <&r>"
      - definemap chat_history:
          channel: <[player_channel]>
          message: <[player_channel]>/<[message]>
          delete: <[delete_button]>
          time: <[time]>
          player_uuid: <player.uuid>

      - run discord_player_chat defmap:<[chat_history]>
      - if <[chat_history.player_uuid].if_null[invalid]> == <yaml[behr.essentials.chat.history].read[chat.<yaml[behr.essentials.chat.history].read[chat].keys.highest.if_null[invalid]>.player_uuid].if_null[invalid]>:
        - define chat_history.message <[player_channel]>/<[message].after[<&co>]>

      - yaml id:behr.essentials.chat.history set chat.<[time].epoch_millis>:<[chat_history]>
      - narrate <[chat_history.message]> targets:<server.online_players> from:<player.uuid>



    on player receives message:
      # % ██ [ create initial definitions ] ██
      - define raw_message <context.message>
      - define message_channel <[raw_message].before[/].strip_color>
      - define message <[raw_message].after[/]>
      - define time <util.time_now>
      - define player_channel <player.flag[behr.essentials.chat.channel].if_null[all]>

      # % ██ [ check for channel to use ] ██
      - if <[player_channel]> == all:
        - define content <yaml[behr.essentials.chat.history].read[chat].if_null[<list>]>
      - else:
        - define content <yaml[behr.essentials.chat.history].read[chat].filter_tag[<[filter_value].get[channel].strip_color.equals[<[player_channel]>].if_null[false]>].if_null[<list>]>

      # % ██ [ manage debugging tools                           ] ██
      - if <[message_channel]> == narrate:
        - define content <[content].include[<yaml[behr.essentials.chat.history].read[chat].filter_tag[<[filter_value].get[channel].equals[narrate]>].filter_tag[<[filter_value].get[targets].contains[<player>]>]>]>

      - else if <[raw_message].strip_color> in <script.parsed_key[data.debug_messages]> || "<[raw_message].strip_color.starts_with[Successfully submitted to https]>":
        - if <[raw_message].strip_color> == Submitting...:
          - determine cancelled
        - clickable dismiss_system_message def:<[time]>|<player.uuid> usages:1 save:dismiss_button
        - define dismiss_button "<element[<&4><&lb><&c>✖<&4><&rb>].on_click[<entry[dismiss_button].command>].on_hover[click to dismiss]> <&b>| <&r>"
        - choose <[raw_message].strip_color>:
          - case "Denizen debugger is now recording. Use /denizen submit to finish.":
            - define text "<&color[#ffb84d]><&lb><&e>Denizen Debug<&color[#ffb84d]><&rb> <&[green]>recording started"
            - define hover "<&[green]>Click to submit"
            - define message <[text].on_hover[<[hover]>].on_click[/denizen submit]>

          - case "denizen debugger recording disabled.":
            - define message "<&color[#ffb84d]><&lb><&e>Denizen Debug<&color[#ffb84d]><&rb> <&[green]>recording disabled"

          - case "Use /denizen debug -r  to record debug information to be submitted":
            - define text "<&color[#ffb84d]><&lb><&e>Denizen Debug<&color[#ffb84d]><&rb> <&[green]>recording not started"
            - define hover "<&[green]>Click to start recording"
            - define message <[text].on_hover[<[hover]>].on_click[/denizen debug -r]>

          - case "Error while submitting." "Submit failed<&co> not recording.":
            - define message "<&color[#ffb84d]><&lb><&e>Denizen Debug<&color[#ffb84d]><&rb> <&[red]>Error while submitting"

          - case "Denizen debugger is now<&co> ENABLED." "Denizen debugger is now<&co> ENABLED.":
            - define message "<&color[#ffb84d]><&lb><&e>Denizen Debug<&color[#ffb84d]><&rb> <&[red]>Enabled"

          - case "Denizen debugger is now<&co> ENABLED." "Denizen debugger is now<&co> DISABLED.":
            - define message "<&color[#ffb84d]><&lb><&e>Denizen Debug<&color[#ffb84d]><&rb> <&[red]>Disabled"

          - default:
            - define url https<[raw_message].strip_color.after[https]>
            - define text "<&color[#ffb84d]><&lb><&e>Denizen Debug<&color[#ffb84d]><&rb> <&[green]>Recording submitted to<&co><n><&e><underline><element[<&b><underline><[url]>].on_click[<[url]>].type[open_url]><&e><underline><&rb>"
            - define hover "<&[green]>Click to open url<&co><n><&b><underline><[url]>"
            - define message <[text].on_hover[<[hover]>].on_click[<[url]>]>

        - definemap chat_history:
            channel: system
            targets: <list_single[<player>]>
            message: system/<[message]>
            dismiss: <[dismiss_button]>
            time: <[time]>
            uuid: <util.random_uuid>

        # % ██ [ add message to system channel                  ] ██
        - yaml id:behr.essentials.chat.history set chat.<[time].epoch_millis>:<[chat_history]>
        - if <[chat_history.channel]> in <[player_channel]> || <[player_channel]> == all:
          - define content.<[time].epoch_millis>:<[chat_history]>

      # % ██ [ verify if a channel exists for incoming message  ] ██
      - else if !<list[player_chat|actions].contains[<[message_channel]>]> && !<[content].values.parse[get[message].strip_color].contains[<[raw_message].strip_color>].if_null[false]>:
        - clickable dismiss_system_message def:<[time]>|<player.uuid> usages:1 save:dismiss_button
        - define dismiss_button "<element[<&4><&lb><&c>✖<&4><&rb>].on_click[<entry[dismiss_button].command>].on_hover[click to dismiss]> <&b>| <&r>"
        #- define dismiss_button "<element[✖.].proc[unselected_button_maker].context[<&f>|<&c>].on_click[<entry[dismiss_button].command>].on_hover[click to dismiss]><&r> "
        - definemap chat_history:
            channel: system
            targets: <list_single[<player>]>
            message: system/<[raw_message]>
            dismiss: <[dismiss_button]>
            time: <[time]>
            uuid: <util.random_uuid>

      # % ██ [ add message to system channel                    ] ██
        - yaml id:behr.essentials.chat.history set chat.<[time].epoch_millis>:<[chat_history]>
        - if <[chat_history.channel]> in <[player_channel]> || <[player_channel]> == all:
          - define content.<[time].epoch_millis>:<[chat_history]>
      - if <yaml[behr.essentials.chat.history].read[chat].size.if_null[0]> > 30 && !<[content].is_empty>:
        - yaml id:behr.essentials.chat.history set chat.<[content].keys.lowest>:!
        - define content.<[content].keys.lowest>:!
      - define content <[content].values.if_null[<list>]>

    # % ██ [ hide messages without permissions to see           ] ██
      - define content <[content].filter_tag[<player.has_flag[behr.essentials.permissions.read_chat_channel.<[filter_value].get[channel].if_null[null]>]>]>
      - define content <[content].filter_tag[<[filter_value].get[targets].contains[<player>].if_null[true]>]>

    # % ██ [ show/hide deleted messages                         ] ██
      - if !<player.has_flag[behr.essentials.chat.settings.show_deleted_messages]> || !<player.has_flag[behr.essentials.permissions.admin]>:
        - define content <[content].filter_tag[<[filter_value].contains[deleted].not>]>

    # % ██ [ show/hide dismissed messages                       ] ██
      - define content <[content].filter_tag[<[filter_value].get[dismissed].contains[<player.uuid>].not.if_null[true]>]>

    # % ██ [ sort messages by time                              ] ██
      - define content <[content].sort_by_value[get[time].epoch_millis]>

    # % ██ [ insert delete and dismissable buttons              ] ██
      - if <player.has_flag[behr.essentials.chat.settings.show_delete_controls]> && <player.has_flag[behr.essentials.permissions.admin]>:
        - if <player.has_flag[behr.essentials.chat.settings.show_dismiss_controls]>:
          - define content <[content].parse_tag[<[parse_value].get[delete].if_null[<empty>]><[parse_value].get[dismiss].if_null[<empty>]><[parse_value].get[message].after[/]>]>
        - else:
          - define content <[content].parse_tag[<[parse_value].get[delete].if_null[<empty>]><[parse_value].get[message].after[/]>]>
      - else:
        - if <player.has_flag[behr.essentials.chat.settings.show_dismiss_controls]>:
          - define content <[content].parse_tag[<[parse_value].get[dismiss].if_null[<empty>]><[parse_value].get[message].after[/]>]>
        - else:
          - define content <[content].parse_tag[<[parse_value].get[message].after[/]>]>

    # % ██ [ create channel buttons                   ] ██
      - if !<player.has_flag[behr.essentials.chat.settings.hide_channel_buttons]>:
        - define channel_buttons <list>
        - foreach all|player_chat|system|admin as:channel:
          - if !<player.has_flag[behr.essentials.permissions.read_chat_channel.<[channel]>]>:
            - foreach next
          - if !<player.has_flag[behr.essentials.chat.settings.channel.<[channel]>.hide_button]>:
            - if <[player_channel]> == <[channel]>:
              - define text <[channel].proc[selected_button_maker].context[<&a>|<&2>]>
            - else:
              - define text <[channel].proc[unselected_button_maker].context[<black>|<white>]>
            - define hover "Click to change to channel<&co><n><[channel]>"
            - define command "/chat_channel <[channel]> quietly"
            - define channel_buttons <[channel_buttons].include_single[<[text].on_hover[<[hover]>].on_click[<[command]>]>]>
        - define channel_buttons "<n><&r><[channel_buttons].separated_by[ ]>"

      - determine message:<n.repeat[100]><[content].separated_by[<&r><n>]><[channel_buttons].if_null[<empty>]>
    on ex command:
      - stop if:<list[server|command_block|command_minecart].contains[<context.source_type>]>
      - stop if:!<context.args.first.equals[narrate]>
      - determine fulfilled passively

      - define time <util.time_now>

      - if <context.args.filter[starts_with[targets<&co>]].is_empty>:
        - define targets <list_single[<player>]>
      - else:
        - define targets <context.args.filter[starts_with[targets<&co>]].parse[after[targets<&co>].parsed].combine>

      - define message <context.raw_args.split_args.remove[first].filter[starts_with[targets<&co>].not].parse[parsed].space_separated>

      - clickable dismiss_system_message def:<[time]>|<player.uuid> usages:1 save:dismiss_button
      - define dismiss_button "<element[<&4><&lb><&c>✖<&4><&rb>].on_click[<entry[dismiss_button].command>].on_hover[click to dismiss]> <&b>| <&r>"
      - define command_text "<&color[#ffb84d]><&lb><&e>/ex narrate<&color[#ffb84d]><&rb>"
      - define command_hover "<&[green]>Click to re-parse<n>Shift-Click to insert<&co><n><&r><element[/ex <context.raw_args>].proc[command_syntax_format]>"
      - define command_command "ex <context.raw_args>"
      - define command_message <[command_text].on_hover[<[command_hover]>].with_insertion[/<[command_command]>].on_click[/<[command_command]>]>

      - define output_text <&r><[message]>
      - define output_message <[output_text]>
      - if !<[message].contains_case_sensitive_text[<&ss><&lb>hover=SHOW_TEXT;]>:
        - define output_hover "<&[green]>Click to copy<n>Shift-click to insert<&co><n><[output_text]>"
        - define output_message <[output_message].on_hover[<[output_hover]>]>
      - if !<[message].contains_case_sensitive_text[<&ss><&lb>insertion=]>:
        - define output_message <[output_message].with_insertion[<[output_text].after[r]>]>
      - if !<[message].contains_case_sensitive_text[<&ss><&lb>click=copy_to_clipboard;]>:
        - define output_message <[output_message].on_click[<[output_text].after[r]>].type[copy_to_clipboard]>

      - definemap chat_history:
          channel: narrate
          targets: <[targets]>
          message: narrate/<[command_message]> <[output_message]>
          dismiss: <[dismiss_button]>
          time: <[time]>

      # % ██ [ add message to system channel ] ██
      - yaml id:behr.essentials.chat.history set chat.<[time].epoch_millis>:<[chat_history]>
      #- if <[chat_history.channel]> in <[player_channel]> || <[player_channel]> == all:
      #  - define content.<[time].epoch_millis>:<[chat_history]>
      - narrate narrate/<[time].epoch_millis> targets:<[targets]>

delete_player_message:
  type: task
  debug: false
  definitions: time
  data:
    disabled_delete_button: <element[<&8><&lb><&7>✖<&8><&rb>].on_hover[<&[red]>Message was already deleted]>
  script:
    - define content <yaml[behr.essentials.chat.history].read[chat.<[time].epoch_millis>]>
    - define new_message <[content.message].before[/]>/<[content.message].after[/].strip_color.color[gray].on_hover[<&[red]>Deleted by <&e><player.name>]>

    - if <[content].contains[discord]>:
      - define message_id <[content.discord.message_id]>
      - define channel_id <[content.discord.channel_id]>
      - if <discord_message[b,<[channel_id]>,<[message_id]>].text.exists>:
        - define url <script[bdata].parsed_key[api.Discord.endpoint]>/channels/<[channel_id]>/messages/<[message_id]>
        - definemap headers:
            User-Agent: dDiscordBot
            Content-Type: application/json
            Authorization: <secret[bbot]>
            X-Audit-Log-Reason:
              reason: Message<&co> <&dq><[content.message].after[/].strip_color><&dq> Deleted by<&co> <&sq><player.name><&sq>
        - webget <[url]> headers:<[headers]> method:delete

    - yaml id:behr.essentials.chat.history set chat.<[time].epoch_millis>.deleted:<util.time_now>
    - yaml id:behr.essentials.chat.history set chat.<[time].epoch_millis>.message:<[new_message]>
    - announce actions/reload

dismiss_system_message:
  type: task
  debug: false
  definitions: time|player_uuid
  script:
    - define content <yaml[behr.essentials.chat.history].read[chat.<[time].epoch_millis>]>
    - yaml id:behr.essentials.chat.history set chat.<[time].epoch_millis>.dismissed:->:<[player_uuid]>
    - narrate actions/reload

discord_player_chat:
  type: task
  debug: false
  definitions: channel|message|time|player_uuid
  script:
    - if <[channel]> in all|player_chat:
      - define hook_url <secret[discord_test_webhook]>
    - else:
      - stop

    - definemap headers:
        User-Agent: b
        Content-Type: application/json

    - definemap data:
        username: <player[<[player_uuid]>].name>
        avatar_url: https://minotar.net/armor/bust/<[player_uuid].replace_text[-]>/100.png?date=<[time].format[MM-dd]>
        content: <[message].strip_color.after[/].proc[discord_escape_simple_proc].after[<&co>]>

    #- webget <secret[discord_chat_webhook]> headers:<[headers]> data:<[data].to_json> save:response
    - ~webget <[hook_url]> headers:<[headers]> data:<[data].to_json> save:response

    - stop if:<entry[response].failed.if_null[true]>

    - define message_id <util.parse_yaml[<entry[response].result.if_null[invalid]>].get[id].if_null[invalid]>
    - define channel_id <util.parse_yaml[<entry[response].result.if_null[invalid]>].get[channel_id].if_null[invalid]>
    - yaml id:behr.essentials.chat.history set chat.<[time].epoch_millis>.discord.message_id:<[message_id]>
    - yaml id:behr.essentials.chat.history set chat.<[time].epoch_millis>.discord.channel_id:<[channel_id]>

discord_escape_simple_proc:
  type: procedure
  debug: false
  definitions: message
  script:
    - determine <[message].replace_text[\].with[\\].replace_text[@].with[\@].replace_text[*].with[\*].replace_text[`].with[\`].replace_text[~].with[\~].replace_text[_].with[\_].replace_text[<&lt>].with[\<&lt>].replace_text[<&gt>].with[\<&gt>].replace_text[@ever].with[﹫ever].replace_text[@her].with[﹫her]>
#https://minotar.net/armor/bust/<player.uuid.replace_text[-]>/100.png?date=<util.time_now.format[MM-dd-hh]>

discord_markdown_format:
  type: procedure
  debug: false
  definitions: message
  script:
    - definemap markdown:
        bold_italic:
          color: <bold><italic>
          state: open
          open: ***
          close: ***
        bold:
          color: <bold>
          state: open
          open: **
          close: **
        italic:
          color: <italic>
          state: open
          open: *
          close: *
        underline:
          color: <underline>
          state: open
          open: __
          close: __
        strikethrough:
          color: <strikethrough>
          state: open
          open: ~~
          close: ~~
    - determine <[message].proc[prepend_text].context[<[markdown]>]>

prepend_text:
  type: procedure
  debug: false
  definitions: text|color_map
  script:
    - define color_list <[color_map].values>
    - define color <[text].last_color>
    - define color_stack:->:<[color].equals[<empty>].if_true[<white>].if_false[<[color]>]>
    - define result <list>
    - define toggle_map <map[open=close;close=open]>
    - while true:
      - define old_list <[color_list]>
      - define color_list:!
      - define closest 999999999
      #~-~-~- REMOVE NON RELEVANT MAPS FROM LIST; FIND CLOSEST OPEN/CLOSE DELIMETER ~-~-~-#
      - foreach <[old_list]> as:map:
        - define state <[map].get[state]>
        - define search <[map].get[<[state]>]>
        - define index_of <[text].index_of[<[search]>]>
        - define first_exists <[index_of].is_more_than[0]>
        - define second_exists <[text].after[<[search]>].contains_text[<[map].get[<[toggle_map].get[<[state]>]>]>]>
        - if ( <[state]> == open and <[first_exists]> and <[second_exists]> ) or ( <[state]> == close and <[first_exists]> ):
          - if <[index_of]> < <[closest]>:
            - define closest_search <[search]>
            - define closest <[index_of]>
          - define color_list:->:<[map]>
      - while stop if:<[color_list].exists.not>
      - define old_list <[color_list]>
      - define color_list:!
      #~-~-~- FIND RELEVANT MAP ENTRY AND ADD COLORING; ADD COLORS TO STACK ~-~-~-#
      - foreach <[old_list]> as:map:
        - define state <[map].get[state]>
        - if <[map].get[<[state]>]> == <[closest_search]>:
          - if <[state]> == open:
            - define color_stack:->:<[map].get[color]>
            - define map.state:close
          - else:
            - define color_stack <[color_stack].remove[last]>
            - define map.state:open
          - define result:->:<[text].before[<[closest_search]>]><[color_stack].get[<[color_stack].size>]>
          - define text <[text].after[<[closest_search]>]>
        - define color_list:->:<[map]>
    - determine <[result].include_single[<[color_stack].get[<[color_stack].size>]><[text]>].unseparated>

discord_player_join_task:
  type: task
  debug: false
  definitions: player_uuid|time
  script:
    - definemap headers:
        User-Agent: b
        Content-Type: application/json

    - definemap embed:
        color: <color[lime].rgb_integer>
        #-option 1
        #footer:
        #  text: <player.name> joined the server
        #  icon_url: https://minotar.net/helm/<[player_uuid].replace_text[-]>/100.png?date=<[time].format[MM-dd-hh]>
        #-option 2
        description: <player.name> joined the server
        thumbnail:
          url: https://minotar.net/armor/bust/<[player_uuid].replace_text[-]>/100.png?date=<[time].format[MM-dd-hh]>
        #-option 3
        #description: <player.name> joined the server
        #thumbnail:
        #  url: https://minotar.net/cube/<[player_uuid].replace_text[-]>/20.png?date=<[time].format[MM-dd-hh]
        #-option 4
        #description: <player.name> joined the server
        #thumbnail:
        #  url: https://minotar.net/cube/<[player_uuid].replace_text[-]>/20.png?date=<[time].format[MM-dd-hh]
        #-option 5
        #footer:
        #  text: <player.name> joined the server
        #  icon_url: https://minotar.net/armor/bust/<[player_uuid].replace_text[-]>/100.png?date=<[time].format[MM-dd-hh]>
        #-option 6
        #description: <player.name> joined the server
        #thumbnail:
        #  url: https://minotar.net/helm/<[player_uuid].replace_text[-]>/20.png?date=<[time].format[MM-dd-hh]

    - definemap data:
        username: Player Chat
        avatar_url: https://cdn.discordapp.com/avatars/905309299524382811/ec892d0ca61eb5023b7c1ce00d2fe10e.webp?size=100
        #avatar_url: https://minotar.net/armor/bust/<[player_uuid].replace_text[-]>/100.png?date=<[time].format[MM-dd-hh]>
        embeds:
          - <[embed]>

    - ~webget <secret[discord_test_webhook]> headers:<[headers]> data:<[data].to_json> save:response


chat_settings_command:
  type: command
  name: chat_settings
  description: adjusts your chat settings
  usage: /chat_settings
  tab completions:
    1: show_deleted_messages|show_delete_controls|show_dismiss_controls|hide_channel|show_channel|reset_chat|hide_channel_buttons|fix_perms
    2: all|chat|system|admin
  permission: behr.essentials.chat_settings
  script:
    - if <context.args.is_empty>:
      - inject command_syntax_error

    - choose <context.args.first>:
      - case hide_channel_buttons:
        - if <player.has_flag[behr.essentials.chat.settings.hide_channel_buttons]>:
          - flag <player> behr.essentials.chat.settings.hide_channel_buttons:!
          - narrate "<&[green]>Chat buttons will now be shown"
        - else:
          - flag <player> behr.essentials.chat.settings.hide_channel_buttons
          - narrate "<&[green]>Chat buttons will now be hidden"

      - case fix_perms:
        - if <player.has_flag[behr.essentials.permissions.admin]>:
          - foreach all|player_chat|chat|system|admin|narrate as:channel:
            - flag <server.online_players> behr.essentials.permissions.read_chat_channel.<[channel]>

      - case reset_chat:
        - if <player.has_flag[behr.essentials.permissions.admin]>:
          - yaml id:behr.essentials.chat.history create
          #- yaml id:behr.essentials.chat.history set chat

          - define time <util.time_now>

          - clickable dismiss_system_message def:<[time]> usages:1 save:dismiss_button
          - define dismiss_button "<element[<&4><&lb><&c>✖<&4><&rb>].on_click[<entry[dismiss_button].command>].on_hover[click to dismiss]> <&b>| <&r>"

          - definemap chat_history:
              channel: system
              message: system/<&[green]>Chat history cleared and reset
              dismiss: <[dismiss_button]>
              time: <[time]>
              uuid: <util.random_uuid>
          - yaml id:behr.essentials.chat.history set chat.<[time].epoch_millis>:<[chat_history]>
          - narrate "<&[green]>Chat history cleared and reset"

      # todo: replace hide/show for toggle, add _button to case name
      - case toggle_channel_button:
        - if <context.args.size> != 2:
          - define reason "You must specify a channel button to hide"
          - inject command_error
        - define channel <context.args.last>
        - if <player.has_flag[behr.essentials.chat.settings.channel.<[channel]>.hide_button]>:
          - narrate "<&[yellow]><[chanel]><&[green]> is already hidden"
        - else:
          - narrate "<&[yellow]><[channel]><&[green]>'s button will now be hidden"

      - case hide_channel:
        - if <context.args.size> != 2:
          - define reason "You must specify a channel button to hide"
          - inject command_error
        - define channel <context.args.last>
        - if <player.has_flag[behr.essentials.chat.settings.channel.<[channel]>.hide_button]>:
          - narrate "<&[yellow]><[chanel]><&[green]> is already hidden"
        - else:
          - narrate "<&[yellow]><[channel]><&[green]>'s button will now be hidden"
          - flag <player> behr.essentials.chat.settings.channel.<[channel]>.hide_button

      - case show_channel:
        - if <context.args.size> != 2:
          - define reason "You must specify a channel to show"
          - inject command_error
        - define channel <context.args.last>
        - if <player.has_flag[behr.essentials.chat.settings.channel.<[channel]>]>:
          - narrate "<&[yellow]><[chanel]> <&[green]>will now shown"
          - flag <player> behr.essentials.chat.settings.channel.<[channel]>.hide_button:!
        - else:
          - narrate "<&[yellow]><[channel]> <&[green]>'s button is already visible"

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
  usage: /chat_channel <&lt>channel<&gt>
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

    - if !<player.has_flag[behr.essentials.permissions.read_chat_channel.<[channel]>]>:
      - inject command_syntax_error

    - define last_channel <player.flag[behr.essentials.chat.channel].if_null[all]>
    - if <[last_channel]> == <[channel]>:
      - stop if:<context.args.last.equals[quietly]>
      - define reason "You're already in that channel"
      - inject command_error

    - define channel player_chat if:<[channel].equals[chat]>
    - flag player behr.essentials.chat.last_channel:<[last_channel]>
    - flag player behr.essentials.chat.channel:<[channel]>
    - if <context.args.last> == quietly:
      - narrate actions/reload
    - else:
      - narrate "<&[green]>You switched to the <&[yellow]><[channel]> <&[green]>channel"
