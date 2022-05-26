create_updoot:
  type: task
  script:
    - definemap options:
        1:
          type: string
          name: topic
          description: Thing to vote for
          required: true
        2:
          type: string
          name: title
          description: (Optional) Title of vote
          required: false
        3:
          type: boolean
          name: threaded
          description: (Optional) Creates the vote in a new thread
          required: false
        4:
          type: mentionable
          name: ping
          description: (Optional) Input users and roles to ping
          required: false

    - ~discordcommand id:c create name:vote "description:Creates a topic for upvoting or downvoting" group:901618453356630046 options:<[options]>

updoot_handle:
  type: world
  events:
    on discord slash command name:updoot for:c:
      - ~discordinteraction defer interaction:<context.interaction>
      - define user <context.interaction.user>
      - definemap embed_data:
          color: 26,188,156
          author_name: <[user].nickname[<context.interaction.channel.group>].if_null[<[user].name>]>
          author_icon_url: <[user].avatar_url>
          description: <context.options.get[topic]>
      - define embed <discord_embed.with_map[<[embed_data]>]>
      - if <context.options.contains[title]>:
        #check if too long
        - define embed <[embed].with[title].as[<context.options.get[title]>]>
      - if <context.options.contains[threaded]> && <context.options.get[threaded]>:
        - ~discordcreatethread id:c name:<context.options.get[title].if_null[Vote!]> parent:<context.interaction.channel> save:thread
        - define message "Your vote was made here<&co> <entry[thread].created_thread.mention>"
        - ~discordinteraction reply interaction:<context.interaction> <[message]> ephemeral:true
        - define channel <entry[thread].created_thread>
        #- ~discordmessage id:c channel:<[channel]> <[embed]> save:message
      - else:
        - define channel <context.interaction.channel>
        #- ~discordmessage id:c channel:<[channel]> <[embed]> save:message
        - ~discordinteraction delete interaction:<context.interaction> ephemeral:true

      - if <context.options.contains[ping]>:
        - ~discordmessage id:c channel:<[channel]> <context.options.get[ping].mention> save:message
      - else:
        - ~discordmessage id:c channel:<[channel]> <[embed]> save:message

      - definemap buttons:
          1:
            id: vote_yes_<entry[message].message.id>
            label: 0
            style: secondary
            emoji: <&lt>:upvote_green:740606478880211065<&gt>
          2:
            id: vote_no_<entry[message].message.id>
            label: 0
            style: secondary
            emoji: <&lt>:downvote_red:740606479035400215<&gt>

      - ~discordmessage id:c edit:<entry[message].message> channel:<[channel]> <[embed]> rows:<[buttons]> save:response
      - flag server discord.open_votes.<entry[message].message.id>.message:<entry[message].message>
      - flag server discord.open_votes.<entry[message].message.id>.author:<[user]>
      - flag server discord.open_votes.<entry[message].message.id>.active expire:15m
      # pin the message
      - definemap headers:
            Authorization: <secret[cbot]>
            Content-Type: application/json
            User-Agent: B
            X-Audit-Log-Reason: This message is emphasised for voting
      - ~webget https://discord.com/api/channels/<[channel].id>/pins/<entry[response].message.id> data:{} method:PUT headers:<[headers]> save:response


discord_vote_buttons:
    type: world
    check_if_expired:
      - define message_id <context.button.map.get[id].after_last[_]>
      - if !<server.has_flag[discord.open_votes.<[message_id]>.active]>:
        - define embed "<discord_embed[color=<color[100,0,0]>;description=This vote has expired.]>"
        - ~discordinteraction reply interaction:<context.interaction> <[embed]> ephemeral:true
        - stop
      - define player_flag_name discord.votes.<[message_id]>
      - define user <context.interaction.user>

    refresh_votes:
      - definemap buttons:
          1:
            id: vote_yes_<[message_id]>
            label: <server.flag[discord.open_votes.<[message_id]>.upvotes].if_null[0]>
            style: secondary
            emoji: <&lt>:upvote_green:740606478880211065<&gt>
          2:
            id: vote_no_<[message_id]>
            label: <server.flag[discord.open_votes.<[message_id]>.downvotes].if_null[0]>
            style: secondary
            emoji: <&lt>:downvote_red:740606479035400215<&gt>
      - define message <server.flag[discord.open_votes.<[message_id]>.message]>
      # change the button integers
      - ~discordmessage id:c edit:<[message]> <[message].embed.first.if_null[<[message].text>]> rows:<[buttons]>
#/vote topic:thing to vote for
    events:
      on discord button clicked id:vote_yes_* for:c:
        - inject discord_vote_buttons.check_if_expired

        # check if voted
        - if <[user].has_flag[<[player_flag_name]>]>:
          # check if upvoted
          - if <[user].flag[<[player_flag_name]>]> == upvote:
          # already upvoted
            - define embed "<discord_embed[color=<color[100,0,0]>;description=You've already voted.]>"
          - else:
            # changed upvote to downvote
            - define embed "<discord_embed[color=#1abc9c;description=Your vote was accepted and changed.]>"
            - flag server discord.open_votes.<[message_id]>.upvotes:++
            - flag server discord.open_votes.<[message_id]>.downvotes:--
        - else:
          # upvoted
          - define embed "<discord_embed[color=#1abc9c;description=Your vote was accepted.]>"
          - flag server discord.open_votes.<[message_id]>.upvotes:++

        - flag <[user]> <[player_flag_name]>:upvote
        - ~discordinteraction reply interaction:<context.interaction> <[embed]> ephemeral:true
        - inject discord_vote_buttons.refresh_votes

      on discord button clicked id:vote_no_* for:c:
        - inject discord_vote_buttons.check_if_expired

        # check if voted
        - if <[user].has_flag[<[player_flag_name]>]>:
          # check if downvoted
          - if <[user].flag[<[player_flag_name]>]> == downvote:
            # already downvoted
            - define embed "<discord_embed[color=<color[100,0,0]>;description=You've already voted.]>"
          - else:
            # changed downvote to upvote
            - define embed "<discord_embed[color=#1abc9c;description=Your vote was accepted and changed.]>"
            - flag server discord.open_votes.<[message_id]>.upvotes:--
            - flag server discord.open_votes.<[message_id]>.downvotes:++
        - else:
          # downvoted
          - define embed "<discord_embed[color=#1abc9c;description=Your vote was accepted.]>"
          - flag server discord.open_votes.<[message_id]>.downvotes:++

        - flag <[user]> <[player_flag_name]>:downvote
        - ~discordinteraction reply interaction:<context.interaction> <[embed]> ephemeral:true
        - inject discord_vote_buttons.refresh_votes
