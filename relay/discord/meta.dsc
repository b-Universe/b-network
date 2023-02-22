update_meta_data_task:
  type: task
  definitions: type
  data:
    commands: https://meta.denizenscript.com/Docs/Commands
    tag: https://meta.denizenscript.com/Docs/Tags/
    object_types: https://meta.denizenscript.com/Docs/ObjectTypes
    mechanisms: https://meta.denizenscript.com/Docs/Mechanisms
    events: https://meta.denizenscript.com/Docs/Events
    language: https://meta.denizenscript.com/Docs/Languages
    actions: https://meta.denizenscript.com/Docs/Actions
    format_tags:
      - script_normal
      - script_tag
      - script_tag_param
      - script_tag_param_bracket
      - script_tag_dot
      - script_comment_normal
      - script_command
      - script_quote_double
      - script_def_name
    strip_tags:
      - actionbar<&lt>td<&gt>
      - <&lt>/td<&gt>
      - <&lt>span class=<&dq>syntax_command<&dq><&gt>
      - <&lt>span class=<&dq>syntax_required<&dq><&gt>
      - <&lt>span class=<&dq>syntax_optional<&dq><&gt>
      - <&lt>span class=<&dq>syntax_fillable<&dq><&gt>
      - <&lt>span class=<&dq>syntax_list<&dq><&gt>
      - <&lt>span class=<&dq>syntax_colon<&dq><&gt>
      - <&lt>td<&gt>
      - <&lt>/span<&gt>
      - <&lt>ObjectTag<&gt>
      - <&lt>tr<&gt>
      - <&lt>/tr<&gt>
      - syntax
# Syntax<span class="syntax_command">adjust [<ObjectTag>/def:<name>|...] [<mechanism>](:<value>)</code></tr>


  debug: false
  script:
    - define url <script.parsed_key[data.<[type]>]>
    - ~webget <[url]> headers:User-Agent=b save:response
    - define result <entry[response].result>
    - flag server dbtest:<[result]>
  log:
    - log <server.flag[dbtest]> type:none file:save_<[type]>.html

  command_testing:
    successful_command_list_grab:
      # this returns every section successfully
      - define sections '<server.flag[dbtest].after[<&lt>table class="table table-hover"<&gt>].before_last[<&lt>/table<&gt>].split[<&lt>table class="table table-hover"<&gt>].get[1]>'

    successful_command_grab:
      # this gets the entire relevant table category
      - define section '<server.flag[dbtest].after[<&lt>table class="table table-hover"<&gt>].before[<&lt>/table<&gt>]>'
      - define name <[section].after[doc_name<&dq><&gt>].before[<&lt>/span<&gt>]>
      - narrate <[name]>

    full_tests:
      # ex run update_meta_data_task.command_testing.full_tests
      #| this successfully grabs all of the command sections
      - define sections '<server.flag[dbtest].after[<&lt>table class="table table-hover"<&gt>].before_last[<&lt>/table<&gt>].split[<&lt>table class="table table-hover"<&gt>]>'

      - foreach <[sections]> as:section:
        #| this successfully grabs all of the command names
        # we'd use <util.list_denizen_commands> but we want the sections to reference
        - define name <[section].after[doc_name<&dq><&gt>].before[<&lt>/span<&gt>]>
        - flag server behr.meta.command.<[name]>

        #| this successfully determines if it has a related guide page, or not
        #- if '<[section].after[<&lt>tr class="table-default"<&gt><&lt>td class="td-doc-key"<&gt>].starts_with[Related Guide Page]>':
        - flag server behr.meta.command.<[name]>.usage_examples:!
        - foreach "<[section].split[<&lt>tr class="table-default"<&gt><&lt>td class="td-doc-key"<&gt>].remove[first]>" as:sector:
          - define row <[sector].before[<&lt>/td<&gt>]>
          - choose <[row]>:
            - case "related guide page":
              - flag server behr.meta.command.<[name]>.related_guide_page:<[sector].after[<&dq>].before[<&dq>]>
            - case syntax:
              - foreach <script.parsed_key[data.strip_tags]> as:tag:
                - define sector <[sector].replace_text[<[tag]>]>
              - define sector <[sector].replace_text[&lt;].with[<&lt>].replace_text[&gt;].with[<&gt>].replace_text[<&lt>code<&gt>].with[`].replace_text[<&lt>/code<&gt>].with[`]>
              - flag server behr.meta.command.<[name]>.syntax:<[sector]>
            - case "short description":
              - flag server behr.meta.command.<[name]>.short_description:<[sector].after[<&lt>td<&gt>].replace_text[<&lt>/td<&gt><&lt>/tr<&gt>].replace_text[<n>]>
              #todo: <---------  kinda done ---------
            - case "full description":
              - define full_description <[sector].after[<&lt>td<&gt>].replace_text[<&lt>br<&gt>].with[<n>].replace_text[<n><n><n>].replace_text[<&lt>/td<&gt><&lt>/tr<&gt>]>
              - define full_description <[full_description].replace_text[&lt;].with[<&lt>].replace_text[&gt;].with[<&gt>]>
              - flag server behr.meta.command.<[name]>.full_description:<[full_description]>
            - case "related tags":
              - define sector <[sector].after[Related Tags<&lt>/td<&gt><&lt>td<&gt>]>
              - if <[sector].starts_with[None]>:
                - foreach next
              - define sector <[sector].replace_text[&lt;].with[<&lt>].replace_text[&gt;].with[<&gt>].replace_text[<&lt>/span<&gt>].replace_text[<&lt>/td<&gt><&lt>/tr<&gt>]>
              - define sector <[sector].replace_text[<&lt>code<&gt>].with[`].replace_text[<&lt>/code<&gt>].with[`].replace_text[<&lt>br<&gt>]>
              - foreach <script.data_key[data.format_tags]> as:class:
                - define sector '<[sector].replace_text[<&lt>span class="<[class]>"<&gt>]>'
              - narrate <[sector]>
              #todo: ---------  kinda done --------->
            - case "usage example":
              - define sector <[sector].replace_text[&lt;].with[<&lt>].replace_text[&gt;].with[<&gt>]>
              - define sector <[sector].after[Usage Example<&lt>/td<&gt><&lt>td<&gt>].replace_text[<&lt>pre<&gt><&lt>code<&gt>].with[```yml<n>].replace_text[<&lt>/code<&gt><&lt>/pre<&gt>].with[<n>```].replace_text[<&lt>/span<&gt>].before[<&lt>/td<&gt><&lt>/tr<&gt>]>
              - foreach <script.data_key[data.format_tags]> as:class:
                - define sector <[sector].replace_text[<&lt>span class=<&dq><[class]><&dq><&gt>]>
              - flag server behr.meta.command.<[name]>.usage_examples:->:<[sector]>


      #| returns the list of command names
      #- narrate <[meta.commands].keys.comma_separated>

discord_command_meta_search:
  type: world
  debug: false
  events:
    after discord message received message:*c*:
      - if !<context.new_message.text.before[ ].contains_any[!c|!cmd|!command]>:
        - stop
      - stop if:!<context.new_message.author.id.equals[194619362223718400]>

      - define criteria <context.new_message.text.after[ ].to_lowercase>
      # check if exact match exists first
      - if <server.has_flag[behr.meta.command.<[criteria]>]>:
        - define result_command <[criteria]>
        - define result_data <server.flag[behr.meta.command.<[result_command]>]>

      # check if any of them are just ooone letter off maybe?
      - else:
        - define commands <server.flag[behr.meta.command].keys.parse[to_lowercase]>
        - foreach <[commands]> as:command:
          - define difference <[command].difference[<[criteria]>]>
          - if <[difference]> == 1:
            - define result_command <[command]>
            - define result_data <server.flag[behr.meta.command.<[result_command]>]>
            - foreach stop

      # check if it's length is a large percentage of the word but also starts with most of it
      - if !<[result_data].exists>:
        - foreach <[commands]> as:command:
          - if <[command].length.div[<[criteria].length>]> > 0.7 && <[command].starts_with[<[criteria]>]>:
            - define result_command <[command]>
            - define result_data <server.flag[behr.meta.command.<[result_command]>]>
            - foreach stop

        # final attempt, see if there's at least one result that matches the best
        - if !<[result_data].exists>:
          - define final_search <[commands].parse_tag[<[parse_value]>/<[parse_value].difference[<[criteria]>]>]>
          - define lowest_score <[final_search].lowest[after[/]].after[/]>
          - if <[final_search].parse[after[/]].count[<[lowest_score]>]> == 1:
            - define result_command <[final_search].lowest[after[/]].before[/]>
            - define result_data <server.flag[behr.meta.command.<[result_command]>]>

      # return if absolutely failed
      - if !<[result_data].exists>:
        - definemap embed_data:
            color: <color[100,0,0]>
            description: No match found.
        - discordmessage id:c channel:<context.channel> <discord_embed.with_map[<[embed_data]>]>
        - stop

      - definemap embed_data:
          color: <color[0,254,255]>
          author_icon_url: https://cdn.discordapp.com/emojis/1058798229208170527.webp?size=240&quality=lossless
          title: "`[<[result_command].to_titlecase>]` Command"
          title_url: https://meta.denizenscript.com/Docs/Commands/<[result_command]>
          description: **Short Description**<n><[result_data.short_description]><n>**Syntax**<n> `<[result_data.syntax]>`
          #description: "**Full Description**<n><[result_data.full_description].replace_text[ <&sq>].with[ `].replace_text[<&sq> ].with[` ]>"
      - define embed <discord_embed.with_map[<[embed_data]>]>
      #- define embed <[embed].add_field[**Full Description**].value[<[result_data.full_description]>]>
      - define embed <[embed].add_field[**Related Tags**].value[<[result_data.related_tags]>]> if:<[result_data].contains[related_tags]>
      #- if <[result_data].contains[usage_examples]>:
      #  - foreach <[result_data.usage_examples]> as:example:
      #    - define embed <[embed].add_field[**Example**].value[<[result_data.usage_examples].get[<[loop_index]>]>]>

      # 📗 enabled
      # 📙 disabled
      - definemap buttons:
          1:
            1: <discord_button.with[id].as[change_meta_full_description_cmd].with[label].as[Full Description].with[emoji].as[📗].with[style].as[success]>
            2: <discord_button.with[id].as[meta_enble_example_usage_cmd].with[label].as[Example Usage].with[emoji].as[📗].with[style].as[success]>
            3: <discord_button.with[id].as[delete].with[emoji].as[❎].with[style].as[secondary]>

      - ~discordmessage id:c channel:<context.channel> <[embed]> rows:<[buttons]> save:message
      #- flag <context.new_message.author> testmessage:<entry[message].message.id> expire:10m

testing_button:
  type: world
  events:
    on discord button clicked id:change_meta_*_description_cmd:
      - ~discordinteraction defer interaction:<context.interaction>
      - discordinteraction delete interaction:<context.interaction>
      - define embed_data <context.message.embed.first.map>
      - define command <[embed_data].get[title].after[<&lb>].before[<&rb>]>
      - define command_data <server.flag[behr.meta.command.<[command]>]>
      - if !<[embed_data].contains[fields]> || <[embed_data].get[fields].filter[contains_any_text[Example]].is_empty>:
        - define example_button <discord_button.with[id].as[meta_enble_example_usage_cmd].with[label].as[Example Usage].with[emoji].as[📗].with[style].as[success]>
      - else:
        - if <[command_data].contains[usage_examples]>:
          - foreach <[command_data.usage_examples]> as:example:
            - define embed <[embed].add_field[**Example**].value[<[command_data.usage_examples].get[<[loop_index]>]>]>
        - define example_button <discord_button.with[id].as[meta_disable_example_usage_cmd].with[label].as[Example Usage].with[emoji].as[📙].with[style].as[secondary]>

      - choose <context.button.map.get[id]>:
        - case change_meta_full_description_cmd:
          - define embed_data.description "**Short Description**<n><[command_data.short_description]><n>**Syntax**<n> `<[command_data.syntax]>`<n>**Full Description**<n><[command_data.full_description]>"
          - define embed <discord_embed.with_map[<[embed_data]>]>
          - definemap buttons:
              1:
                1: <discord_button.with[id].as[change_meta_short_description_cmd].with[label].as[Full Description].with[emoji].as[📙].with[style].as[secondary]>
                2: <[example_button]>
                3: <discord_button.with[id].as[delete].with[emoji].as[❎].with[style].as[secondary]>

        - case change_meta_short_description_cmd:
          - define embed_data.description "**Short Description**<n><[command_data.short_description]><n>**Syntax**<n> `<[command_data.syntax]>`"
          - define embed <discord_embed.with_map[<[embed_data]>]>
          - definemap buttons:
              1:
                1: <discord_button.with[id].as[change_meta_full_description_cmd].with[label].as[Full Description].with[emoji].as[📗].with[style].as[success]>
                2: <[example_button]>
                3: <discord_button.with[id].as[delete].with[emoji].as[❎].with[style].as[secondary]>

      - discordmessage id:c edit:<context.message> channel:<context.channel> <[embed]> rows:<[buttons]>


    on discord button clicked id:meta_*_example_usage_cmd:
      - discordinteraction defer interaction:<context.interaction>
      - discordinteraction delete interaction:<context.interaction>
      - define embed_data <context.message.embed.first.map>
      - define command <[embed_data].get[title].after[<&lb>].before[<&rb>]>
      - define command_data <server.flag[behr.meta.command.<[command]>]>
      - if !<[embed_data].get[description].contains_text[**Full Description**]>:
        - define embed_data.description "**Short Description**<n><[command_data.short_description]><n>**Syntax**<n> `<[command_data.syntax]>`"
        - define description_button <discord_button.with[id].as[change_meta_full_description_cmd].with[label].as[Full Description].with[emoji].as[📗].with[style].as[success]>
      - else:
        - define embed_data.description "**Short Description**<n><[command_data.short_description]><n>**Syntax**<n> `<[command_data.syntax]>`<n>**Full Description**<n><[command_data.full_description]>"
        - define description_button <discord_button.with[id].as[change_meta_short_description_cmd].with[label].as[Full Description].with[emoji].as[📙].with[style].as[secondary]>

      - define buttons.1.1 <[description_button]>

      - if <[command_data].contains[usage_examples]>:
        - narrate <[embed_data.fields].parse[get[title]]>
        - if !<[embed_data].contains[fields]> || <[embed_data].get[fields].filter[get[title].contains[**Example**]].is_empty>:
          - define fields_list <list>
          - foreach <[command_data.usage_examples]> as:example:
            - define fields_list <[fields_list].include_single[<map.with[title].as[**Example**].with[value].as[<[command_data.usage_examples].get[<[loop_index]>]>]>]>
          - define example_button <discord_button.with[id].as[meta_disable_example_usage_cmd].with[label].as[Example Usage].with[emoji].as[📙].with[style].as[secondary]>
          - define embed_data.fields <[fields_list]>
        - else:
          - define embed_data.fields <[embed_data.fields].filter[get[title].equals[**Example**].not]>
          - define example_button <discord_button.with[id].as[meta_enble_example_usage_cmd].with[label].as[Example Usage].with[emoji].as[📗].with[style].as[success]>
        - define buttons.1.2 <[example_button]>

      - define buttons.1.3 <discord_button.with[id].as[delete].with[emoji].as[❎].with[style].as[secondary]>

      - define embed <discord_embed.with_map[<[embed_data]>]>

      - discordmessage id:c edit:<context.message> channel:<context.channel> <[embed]> rows:<[buttons]>

    on discord button clicked id:delete:
      - run discord_delete_message_api def:<context.channel.id>|<context.message.id>
