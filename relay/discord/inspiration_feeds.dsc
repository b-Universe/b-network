inspiration_feeds_handler:
  type: world
  debug: true
  enabled: true
  data:
    categories:
      builds: Larger constructs of creations
      mechanical: Robotics, machinery, vehicles, etc
      equipment: hand-helds items, clothing, armor, etc
      weapons: Guns, Bows, etc
      entities: Mobs, monsters, critters, etc
      objects: Blocks, chests, furniture, etc
      christmas: Things based on Christmas
      halloween: Things based on Halloween
      easter: Things based on Easter
      trash: Discard
  events:
    after discord message received for:c channel:1072885969600127067:
      - define message <context.new_message>
      - define user <[message].author>

      #- stop if:!<[user].is_bot>
      #- stop if:!<[user].name.contains[<&ns>]>
      - stop if:<[user].advanced_matches[<context.bot.self_user>]>

# todo: ------ this is the proper way heh -------
#      - define options <map>
#      - foreach <script.parsed_key[data.categories]> key:category as:description:
#        - definemap option_item:
#            label: <[category].to_titlecase>
#            value: <[category]>
#            description: <[description]>
#            emoji: 🤩
#        - define options <[options].with[<[loop_index]>].as[<[option_item]>]>
#
#      - define menu <discord_selection.with[id].as[inspiration_categories].with[options].as[<[options]>]>
#      - ~discordmessage id:c channel:1072885969600127067 rows:<[menu]> "text here"
# todo: -----------------------------------------

      - define options <list>
      - foreach <script.parsed_key[data.categories]> key:category as:description:
        - definemap option_item:
            label: <[category].to_titlecase>
            value: <[category]>
            description: <[description]>
            #emoji: <map.with[name].as[rogue].with[id].as[625891304148303894]>
        - define options <[options].include_single[<[option_item]>]>
      - definemap menu:
          type: 3
          custom_id: inspiration_categories
          options: <[options]>
          placeholder: Categorize this model
          min_values: 1
          max_values: 1
          #max_values: <script.data_key[data.categories].size>
      - definemap component_menu:
          type: 1
          components: <list_single[<[menu]>]>

      - definemap data:
          #content: text message here
          message_reference:
            message_id: <[message].id>
            channel_id: 1072885969600127067
            guild_id: 901618453356630046
            fail_if_not_exists: false
          components: <list_single[<[component_menu]>]>

      - definemap headers:
          Authorization: <secret[cbot]>
          Content-Type: application/json
          User-Agent: b

      - define url https://discord.com/api/channels/1072885969600127067/messages
      - ~webget <[url]> data:<[data].to_json[native_types=true]> method:post headers:<[headers]> save:response
      #- inject web_debug.webget_response
      #- narrate <[data].to_json[native_types=true]>

    on discord selection used:
      - ~discordinteraction defer interaction:<context.interaction>
      - ~discordinteraction delete interaction:<context.interaction>

      - define selection_message <context.message>
      - define reference_message <[selection_message].replied_to>
      - define message_ids <list[<[selection_message].id>|<[reference_message].id>]>
      - define channel_id <context.channel.id>
      - define selection <context.option.get[value]>

      - if <[selection]> == trash:
        - define reason "Model referenced marked for deletion"
        - run discord_delete_bulk_messages_api def:<list_single[<[channel_id]>].include_single[<[message_ids]>].include_single[<[reason]>]>
        - stop

      # construct the embed
      - define embed_data <[reference_message].embed.first.map>
      - definemap embed:
          author:
            name: <[embed_data.author_name]>
          #title: <[embed_data.title]>
          #url: <[embed_data.title_url]>
          description: <[embed_data.description]>
          color: <color[0,254,255].rgb_integer>
          image:
            url: <[embed_data.image]>
      - define embeds <list_single[<[embed]>]>

      - definemap headers:
          Authorization: <secret[cbot]>
          Content-Type: application/json
          User-Agent: b

      - if <server.has_flag[behr.discord.news_feeds.channels.<[selection]>]>:
        - define channel_id <server.flag[behr.discord.news_feeds.channels.<[selection]>]>
        - inject create_influence_post

      # send the message
      - else:
        - inject create_influence_forum_post

    on discord message command name:refresh_influence:
      - ~discordinteraction defer interaction:<context.interaction>
      - ~discordinteraction delete interaction:<context.interaction>
      - define message <context.interaction.target_message>

      - define options <list>
      - foreach <script.parsed_key[data.categories]> key:category as:description:
        - definemap option_item:
            label: <[category].to_titlecase>
            value: <[category]>
            description: <[description]>
            #emoji: <map.with[name].as[rogue].with[id].as[625891304148303894]>
        - define options <[options].include_single[<[option_item]>]>
      - definemap menu:
          type: 3
          custom_id: inspiration_categories
          options: <[options]>
          placeholder: Categorize this model
          min_values: 1
          max_values: 1
          #max_values: <script.data_key[data.categories].size>
      - definemap component_menu:
          type: 1
          components: <list_single[<[menu]>]>

      - definemap data:
          components: <list_single[<[component_menu]>]>

      - definemap headers:
          Authorization: <secret[cbot]>
          Content-Type: application/json
          User-Agent: b

      - define url https://discord.com/api/channels/1072885969600127067/messages/<[message].id>
      - ~webget <[url]> data:<[data].to_json[native_types=true]> method:patch headers:<[headers]> save:response

discord_refresh_influence_command_create:
  type: task
  debug: false
  script:
    - ~discordcommand id:c create group:901618453356630046 name:Refresh_Influence type:message "description:Refreshses the menu for influence feeds"

create_influence_post:
  type: task
  debug: false
  definitions: channel_id|embeds
  script:
    # create data
    - definemap data:
        embeds: <[embeds]>

    - define url https://discord.com/api/channels/<[channel_id]>/messages
    - ~webget <[url]> data:<[data].to_json> method:post headers:<[headers]> save:response
    - inject web_debug.webget_response

create_influence_forum_post:
  type: task
  debug: false
  definitions: embeds
  script:
    # create data
    - definemap data:
        #name: 1-100 characters
        name: Influential Content - <[selection].to_titlecase>
        message:
          embeds: <[embeds]>
      #|auto_archive_duration: 60, 1440, 4320, 10080 minutes to auto-close
      #|rate_limit_per_user: amount of seconds ratelimiting players for messages
      #|message: forum message thread which is;
        #|content: 1-2000 characters
        #|embeds: embedded messages up to 6000 characters
        #|allowed_mentions: just another key under it parse: <list>
        #|components: buttons and shit
        #|files: oh shit not this again
        #|attachments: i will die
        #|flags: things like crossposted, is_crossposted, suppress_embeds, source_message_deleted, urgent, has_thread, ephemeral, loading, failed_to_mention_some_roles_in_thread
        #| half of those threads are weird af
      #|applied_tags: IDs of tags to apply?

    - define url https://discord.com/api/channels/1072176893303996516/threads
    - ~webget <[url]> data:<[data].to_json> method:post headers:<[headers]> save:response
    - inject web_debug.webget_response
    - define channel_id <util.parse_yaml[<entry[response].result>].get[id]>
    - flag server behr.discord.news_feeds.channels.<[selection]>:<[channel_id]>
    # todo: check if this was successful or not, try again later if not
