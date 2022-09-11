error_reporting:
  type: world
  debug: false
  events:
    after script generates error:
      # % ██ [ disable headless queues ] ██
      - define queue <context.queue.if_null[invalid]>
      - if <[queue]> == invalid:
        - stop

      # % ██ [ disable /ex reporting   ] ██
      - stop if:<[queue].id.starts_with[excommand]>

      # % ██ [ verify enabled          ] ██
      - stop if:!<server.has_flag[behr.essentials.error_reporting]>

      # % ██ [ save time ] ██
      - define context.time <util.time_now>

      # % ██ [ verify bungee connection ] ██
      - waituntil <bungee.connected> max:1m
      - stop if:!<bungee.connected>

      # % ██ [ collect basic context ] ██
      - define context.server <bungee.server>
      - define context.message <context.message.if_null[invalid]>
      - define context.queue.name <[queue].id>
      - define context.queue.definition_map:<[queue].definition_map> if:!<[queue].definition_map.is_empty.if_null[true]>

      # % ██ [ collect script context ] ██
      - if <context.script.exists>:
        - define context.script.name:<context.script.name.if_null[invalid]>
        - define context.script.line:<context.line.if_null[invalid]>
        - define context.script.file_path:<context.script.filename.after[/plugins/Denizen/scripts/].if_null[invalid]>

      # % ██ [ collect player context ] ██
      - if <player.exists>:
        - define context.player.uuid:<player.uuid>
        - define context.player.name:<player.name>

      # % ██ [ collect npc context ] ██
      - if <[queue].npc.exists>:
        - define context.npc.id:<[queue].npc.id>
        - define context.npc.name:<[queue].npc.name>

      # % ██ [ track errors ] ██
      - define flag behr.essentials.error_listening.<[queue].id>.<[context.script.name]>
      - flag server behr.essentials.error_listening.<[context.script.name]>:->:<util.time_now> expire:1h
      - flag server <[flag]>.<[context.script.line]>:->:<[context.message]> expire:15s
      - stop if:<server.has_flag[<[flag]>.runtime]>
      - flag server <[flag]>.runtime expire:15s
      - wait 1t
      - waituntil <[queue].state> != running rate:1s max:3s
      - flag server <[flag]>.runtime:!

      # % ██ [ track ratelimit ] ██
      - define context.rate <server.flag[behr.essentials.error_listening.<[context.script.name]>].filter[is_after[<util.time_now.sub[1h]>]].size>
      - if <[context.rate]> > 60:
        - define context.rate_limited true
        - flag server behr.essentials.error_listening.ratelimited_scripts.<[context.script.name]>:<[context.time]> expire:5m
        - stop

      # % ██ [ collect error information ] ██
      - define context.queue.errors <server.flag[behr.essentials.error_listening.<[queue].id>]>

      # % ██ [ submit errors ] ██
      - bungeerun server:home error_report def:<[context]>

error_report:
  type: task
  debug: false
  definitions: context
  script:
    # % ██ [ define base definitions ] ██
    - define guild <discord_group[b,901618453356630046]>
    - define embed <discord_embed>
    - definemap embed_data:
        title: __`<&lb>Click for log<&rb>`__ | `<&lb><[context.server]><&rb>` | Error response<&co>
        title_url: https://behr.dev/error_report_<util.random.duuid>
        color: <color[0,255,254]>

    # % ██ [ check if the channel exists if creating new ] ██
    - if <server.has_flag[behr.essentials.error_listening.settings.channel_specific]>:
      - if !<[guild].channels.parse[name].contains[📒<[context.server]>]>:
        - ~discordcreatechannel id:b group:<[guild]> name:📒<[context.server]> "description:Error reporting for <[context.server]>" type:text category:901618453746712660 save:new_channel
        - define channel <entry[new_channel].channel>
      - else:
        - define channel <[guild].channel[📒<[context.server]>]>
    - else:
      - define channel <discord_channel[b,976029737094901760]>

    # % ██ [ check if the thread exists ] ██
    - define date <util.time_now.format[MMMM-dd-u]>
    - if <[channel].active_threads.is_empty> || !<[channel].active_threads.parse[name].contains[📒<[date]>]>:
      - ~discordcreatethread id:b name:📒<[date]> parent:<[channel]> save:new_thread
      - define thread <entry[new_thread].created_thread>
    - else:
      - define thread <[channel].active_threads.highest[id]>

    # % ██ [ construct footer, check ratelimits ] ██
    - if !<[context.rate_limited].exists>:
      - define embed_data.footer "Script error count (*/hr)<&co> <[context.rate]>"
    - else:
      - define embed_data.footer "<&lb>Rate-limited<&rb> Script error count (*/hr)<&co> <[context.rate]>"
      - define embed_data.footer_icon https://cdn.discordapp.com/emojis/901634983867842610.gif?size=56&quality=lossless

    # % ██ [ construct player content ] ██
    - if <[context.player].exists>:
      - define embed_data.author_name "Player attached<&co> <[context.player.name]> (<[context.player.uuid]>)"
      - define embed_data.author_icon_url https://crafatar.com/avatars/<[context.player.uuid].replace_text[-]>

    # % ██ [ construct npc content ] ██
    - if <[context.npc].exists>:
      - if !<[embed_data.author_name].exists>:
        - define embed_data.author_name "npc attached<&co> <[context.npc.name]>" if:!<[embed_data.author_name].exists>
        - define embed_data.author_icon_url https://crafatar.com/avatars/<[context.player.uuid].replace_text[-]> if:!<[embed_data.author_icon_url].exists>
      - else:
        - define embed "<[embed].add_inline_field[npc name<&co>].value[`<[context.npc.name]>`]>"
        - define embed "<[embed].add_inline_field[npc id<&co>].value[`<[context.npc.id]>`]>"

    # % ██ [ construct error content ] ██
    - if <[context.queue.errors].exists>:
      - define description <list>
      - foreach <[context.queue.errors]> key:script as:content:
        # % ██ [ define the file and link ] ██
        - define context.script.file_link https://github.com/bGielinor/b-network/blob/main/<[context.server]>/<[context.script.file_path]>
        - define context.script.short_file_name <[context.script.file_path].after_last[/]>

        # % ██ [ format link if lines evident ] ██
        - if <[context.script.line]> != invalid:
          - define context.script.file_link <[context.script.file_link]><&ns>L<[context.script.line]>
        - define context.script.formatted_file **<&lb>`<&lb><[context.script.file_path]><&rb>`<&rb>(<[context.script.file_link]>)**

        # % ██ [ add error content ] ██
        - define description "<[description].include_single[**`<[context.script.name]>`** | <&lb><[context.script.formatted_file]><&rb>(<[context.script.file_link]>)<&co>]>"
        - foreach <[content]> key:line as:message:
          - define error_content "<list_single[<&co>warning<&co> `Line <[line]>`<&co>]>"
          - if !<[message].is_empty>:
            - define error_content "<[error_content].include_single[<&gt> <[message].parse[strip_color.replace_text[`].with[<&sq>].proc[error_formatter]].separated_by[<n><&gt> ]>]>"
          - else:
            - define error_content "<[error_content].include_single[<&co>warning<&co>**No error message** - Consider providing better context.]>"

          # % ██ [ check for description limit ] ██
          - if <[description].include_single[<[error_content].substring[0,3500]>].separated_by[<n>].length> < 4000:
            - define description <[description].include[<[error_content]>]>
          - else:
            - define description <[description].include_single[<[error_content].substring[0,<element[3500].sub[<[description].length>]>]>]>
            - define description "<[description].include_single[<&co>warning<&co>**Snipped error count** - consider minimizing erroneous output.]>"
            - foreach stop

    # % ██ [ construct description content ] ██
      - define embed_data.description <[description].separated_by[<n>]>
    - else:
      - define embed_data.description "<&co>warning<&co>**No error content** - Consider providing better context."

    # % ██ [ construct definitions content ] ██
    - if !<[context.queue.definition_map].is_empty.if_null[true]>:
      - define definition_content <[context.queue.definition_map].to_yaml.replace_text[`].with[<&sq>]>
      - if <[definition_content].length> < 950:
        - define definition_content ```yml<n><[definition_content]><n>```
      - else:
        - define definition_content "```yml<n><[definition_content].substring[0,950].before_last[<n>]><n>⚠<&co> **Snipped!**```"
      - define embed <[embed].add_field[Definitions<&co>].value[<[definition_content]>]>

    # % ██ [ construct embed ] ██
    - define embed <[embed].with_map[<[embed_data]>]>

    # % ██ [ send embed ] ██
    - ~discordmessage id:b channel:<[thread]> <[embed]>

error_formatter:
  type: procedure
  debug: false
  definitions: text
  script:
    - define text <[text].strip_color>

    # @ ██ [ ref from: https://github.com/DenizenScript/Denizen-Core/blob/master/src/main/java/com/denizenscript/denizencore/tags/TagManager.java ] ██
    # % ██ [ ie: Debug.echoError(context, "Tag " + tagStr + " is invalid!"); ] ██
    - if "<[text].starts_with[Tag <&lt>]>" && "<[text].ends_with[<&gt> is invalid!]>":
      - determine "Tag `<[text].after[Tag ].before_last[ is invalid!]>` returned invalid."

    # % ██ [ ie: Debug.echoError(event.getScriptEntry(), "Unfilled or unrecognized sub-tag(s) '<R>" + attribute.unfilledString() + "<W>' for tag <LG><" + attribute.origin + "<LG>><W>!"); ] ██
    - else if "<[text].starts_with[Unfilled or unrecognized sub-tag(s) ']>":
      - define string "<[text].after[sub-tag(s) '].before_last[' for tag <&lt>]>"
      - determine "Unfilled or borked sub-tag(s) `<[string]>` <[text].after[<[string]>].before[' for tag <&lt>]> for tag<&co> `<&lt><[text].after[<[string]>].after[<&lt>].before_last[!]>`."

    # % ██ [ ie: Debug.echoError(event.getScriptEntry(), "The returned value from initial tag fragment '<LG>" + attribute.filledString() + "<W>' was: '<LG>" + attribute.lastValid.debuggable() + "<W>'."); ] ██
    - else if "<[text].starts_with[The returned value from initial tag fragment]>":
      - define tag "<[text].after[fragment '].before[' was<&co> ']>"
      - define parse_value "<[text].after_last[' was<&co> '].before_last['.]>"
      - determine "The returned value from initial tag fragment<&co> `<&lt><[tag]><&gt>` returned<&co> `<[parse_value]>`"

    - else if "<[text].after[ ].starts_with[is an invalid command! Are you sure it loaded?]>":
      - define command "<[text].before[ ]>"
      - if <script[external_denizen_commands].data_key[commands].contains[<[command]>]>:
        - determine "`<[command]>` failed to register as a valid command. Verify that <script[external_denizen_commands].data_key[commands.<[command]>].parse_tag[`<[parse_value]>`].formatted> loaded properly."
      - else:
        - determine "`<[command]>` is an invalid command."

    # % ██ [ ie: Debug.echoError("No tag-base handler for '" + event.getName() + "'."); ] ██
    - if "<[text].starts_with[No tag-base handler for ']>":
      - define tag "<[text].after[no tag-base handler for '].before_last['.]>"
      - determine "No tag-base handler for `<[tag]>`."

    # % ██ [ ie: attribute.echoError("Tag-base '" + base + "' returned null."); ] ██
    - if "<[text].starts_with[Tag-base ']>" && "<[text].ends_with[' returned null.]>":
      - define tag "<[text].after[Tag-base '].before_last[' returned null.]>"
      - determine "Tag-base `<[tag]>` returned null."

    # % ██ [ ie: Debug.echoError(context, "'ObjectTag' notation is for documentation purposes, and not to be used literally." ] ██
    - else if "<[text].starts_with['ObjectTag' notation is for documentation purposes]>":
      - determine "<&co>warning<&co> **<[text]>**"

    # % ██ [ ie: Debug.echoError(event.getScriptEntry(), "Almost matched but failed (missing [context] parameter?): " + almost); ] ██
    # % ██ [ ie: Debug.echoError(event.getScriptEntry(), "Almost matched but failed (possibly bad input?): " + almost); ] ██

    # % ██ [ ie: Debug.echoError(context, "(Initial detection) Tag processing failed: " + ex.getMessage()); ] ██


    # % ██ [ ie: Debug.echoError("Tag filling was interrupted!"); ] ██
    # % ██ [ ie: Debug.echoError("Tag filling timed out!"); ] ██

    - else:
      - determine <[text]>

external_denizen_commands:
  type: data
  commands:
    bungee:
      - depenizen
      - depenizenbungee
      - bungeecord
    bungeeexecute:
      - depenizen
      - depenizenbungee
      - bungeecord
    bungeerun:
      - depenizen
      - depenizenbungee
      - bungeecord
    bungeetag:
      - depenizen
      - depenizenbungee
      - bungeecord

    mythicsignal:
      - depenizen
      - mythicmobs
    mythicskill:
      - depenizen
      - mythicmobs
    mythicspawn:
      - depenizen
      - mythicmobs
    mythicthreat:
      - depenizen
      - mythicmobs
    worldedit:
      - depenizen
      - worldedit

    discord:
      - dDiscordBot
    discordcommand:
      - dDiscordBot
    discordconnect:
      - dDiscordBot
    discordcreatechannel:
      - dDiscordBot
    discordcreatethread:
      - dDiscordBot
    discordinteraction:
      - dDiscordBot
    discordmessage:
      - dDiscordBot
    discordmodal:
      - dDiscordBot
    discordreact:
      - dDiscordBot
