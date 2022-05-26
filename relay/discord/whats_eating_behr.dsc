create_whats_eating_behr:
  type: task
  debug: false
  script:
    #- definemap options:
    #    1:
    #      type: string
    #      name: topic
    #      description: Shows all projects available
    #      required: false
    #- ~discordcommand id:c create name:vote "description:Creates a topic for upvoting or downvoting" group:901618453356630046 options:<[options]>
    - ~discordcommand id:c create name:whats_eating_behr "description:Shows the active development topics" group:901618453356630046


whats_eating_behr_handler:
  type: world
  debug: false
  events:
    on discord slash command name:whats_eating_behr for:c:
      - ~discordinteraction defer interaction:<context.interaction>

      - if <discord_channel[c,901618453746712656].active_threads.is_empty>:
      #  - definemap embed_data.description "There are no active development threads open right now. You can view archived projects using `/whats_eating_behr archived`"
        - definemap embed_data.description "There are no active development threads open right now. Check back later kek"

      - else:
        - define threads <discord_channel[c,901618453746712656].active_threads>
        - define embed_data.description "Here are the latest and active development project(s) right now, click the buttons below to be added to their threads<n><n>Anyone is welcome to participate in feedback, collaboration, and suggestions for any development project here"
        - define embed_data.footer "(You can always leave threads after joining)"
        - foreach <[threads]> as:thread:
          - definemap buttons.<[loop_index]>:
              id: join_thread_<[thread].id>
              label: <[thread].name.after[📒 ]>
              style: success
              emoji: 📒

        - define embed_data.title "`<&lb><[threads].size><&rb>` Active development project(s)"
        - define embed_data.color 0,255,255

      - define embed <discord_embed.with_map[<[embed_data]>]>

      - ~discordinteraction reply interaction:<context.interaction> <[embed]> rows:<[buttons]>


discord_join_thread_buttons:
  type: world
  debug: false
  events:
    on discord button clicked id:join_thread_* for:c:
      - define user <context.interaction.user>
      - define thread_id <context.button.map.get[id].after[join_thread_]>
      - definemap headers:
          Authorization: <secret[cbot]>
          Content-Type: application/json
          User-Agent: B

      - ~webget https://discord.com/api/channels/<[thread_id]>/thread-members/<[user].id> data:{} method:PUT headers:<[headers]> save:response

      - define thread <discord_channel[c,<[thread_id]>]>
      # todo: this tag will be fixed in time:
      #- if <[thread].thread_members.contains[<[user]>]>:
      # from here
      - ~webget https://discord.com/api/channels/<[thread_id]>/thread-members method:GET headers:<[headers]> save:response
      - define thread_member_ids <util.parse_yaml[{"data":<entry[response].result>}].get[data].parse[get[user_id]]>
      # to here
      - if <[thread_member_ids].contains[<[user].id>]>:
        - define embed_data.description "You're already in that thread<n>You can jump over to the discussion at <&lt><&ns><[thread_id]><&gt>"
        - define embed_data.color 0,255,255
      - else:
        - define embed_data.title "You were added to the <[thread].name.after[📒 ]> thread!"
        - define embed_data.description "Check your pings, or jump on over to <&lt><&ns><[thread_id]><&gt> to check it out"
        - define embed_data.color 0,255,255
      - define embed <discord_embed.with_map[<[embed_data]>]>
      - ~discordinteraction reply interaction:<context.interaction> <[embed]> ephemeral:true
