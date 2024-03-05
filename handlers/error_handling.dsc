error_handling:
  type: world
  debug: false
  events:
    after script generates error:
      - define script.name <context.script.name.if_null[null]>
      - define script.line <context.line.if_null[null]>
      - if <[script.name]> == error_handling:
        - stop
      - flag server behr.essentials.debug.error.<[script.name]>.count:->:<util.time_now> expire:1h
      - stop if:<server.flag[behr.essentials.debug.error.<[script.name]>.<[script.line]>].if_null[<list>].contains[<context.message.strip_color>]>
      - flag server behr.essentials.debug.error.<[script.name]>.<[script.line]>:->:<context.message.strip_color>
      - if <server.has_flag[behr.essentials.debug.error.<[script.name]>.lines.<[script.line]>]>:
        - flag server "behr.essentials.debug.error.<[script.name]>.errors:->:<&gt> <context.message.strip_color.proc[error_formatter]>" expire:3s
      - else:
        - flag server behr.essentials.debug.error.<[script.name]>.lines.<[script.line]> expire:3s
        - flag server "behr.essentials.debug.error.<[script.name]>.errors:->:⚠️ Line `<[script.line]>`<n><&gt> <context.message.strip_color.proc[error_formatter]>" expire:3s

      - if <server.has_flag[behr.essentials.debug.error.<[script.name]>.ratelimit]>:
        - stop
      - flag server behr.essentials.debug.error.<[script.name]>.ratelimit expire:1s

      - waituntil !<server.has_flag[behr.essentials.debug.error.<[script.name]>.ratelimit]> rate:1s

      - definemap embed:
          title: "`<&lb>Repo Link<&rb>` <[script.name]>"
          title_url: https://github.com/bUniverse/b-network/blob/master/<context.script.filename.after[/plugins/Denizen/scripts/].if_null[invalid]>.dsc
          description: <server.flag[behr.essentials.debug.error.<[script.name]>.errors].separated_by[<n>].substring[0,3000]>
          color: 0,254,255
          footer: Script error count (*/hr)<&co> <server.flag[behr.essentials.debug.error.<[script.name]>.count].filter[is_after[<util.time_now.sub[1h]>]].size>
      - define embed <discord_embed.with_map[<[embed]>]>
      - define embed <[embed].add_inline_field[**script**].value[`<[script.name]>`]>
      - define embed <[embed].add_inline_field[**Line**].value[`<[script.line]>`]>
      - if !<context.queue.definition_map.if_null[<map>].is_empty>:
        - define embed <[embed].add_field[**Definitions**].value[```yml<n><context.queue.definition_map.to_yaml.if_null[null]><n>```]>

      - definemap url:
          github_issue: https<&co>//github.com/b-Universe/b-network/issues/new?template=🐞-bug-report.md&title=<&rb>+🐞+Bork+<&rb>+<[script.name].url_encode>
          #localhost_logs: http://localhost:8069/<[script.name]>/<util.random.duuid>.txt

      - definemap buttons:
          1:
              #0: <discord_button.with[id].as[delete].with[emoji].as[❌].with[label].as[Delete].with[style].as[danger]>
              1: <discord_button.with[id].as[<[url.github_issue]>].with[emoji].as[📒].with[label].as[Create issue].with[style].as[link]>
              #2: <discord_button.with[id].as[<[url.localhost_logs]>].with[emoji].as[📒].with[label].as[Logs].with[style].as[link]>

      - if !<server.has_flag[behr.essentials.debug.error.<[script.name]>.thread]>:
        - ~discordcreatethread id:b "name:📒 <[script.name]>" parent:976029737094901760 save:thread
        - flag server behr.essentials.debug.error.<[script.name]>.thread:<entry[thread].created_thread.id>
      - define channel <server.flag[behr.essentials.debug.error.<[script.name]>.thread]>
      - discordmessage id:b channel:<[channel]> embed:<[embed]> rows:<[buttons]>


newline_paginator:
  type: procedure
  definitions: text|limit
  script:
    - define text_pages <list>
    - define page <list>
    - foreach <[text].split[<n>]> as:text_line:
      - if <[page].include_single[<[text_line]>].separated_by[<n>].length> > <[limit]>:
        - define text_pages <[text_pages].include[<[page]>]>
        - define page <list>
      - define page <[page].include_single[<[text_line]>]>
    - determine <[text_pages].include[<[page]>]>

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
      - define tag "<[text].after[fragment '].before[' was<&co> '].replace[`].with[']>"
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
