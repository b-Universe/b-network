create_connect_4_command:
  type: task
  debug: false
  script:
    - definemap options:
        1:
          type: user
          name: opponent
          description: The person you'd like to play with - if left empty, the first person to react plays!
          required: false
        2:
          type: integer
          name: width
          description: Sets the width of the board (Default<&co> 7)
          required: false
        3:
          type: integer
          name: height
          description: Sets the height of the board (Default<&co> 7)
          required: false

    - ~discordcommand id:c create name:connect_4 "description:Creates a mini connect-4 game that you can play" group:901618453356630046 options:<[options]>
#<DiscordInteractionTag

connect_4_test:
  type: task
  script:
    - definemap buttons:
        1:
            1: <discord_button.with[id].as[connect_4_1].with[label].as[🔴].with[emoji].as[1️⃣].with[style].as[success]>
            2: <discord_button.with[id].as[connect_4_2].with[label].as[🔴].with[emoji].as[2️⃣].with[style].as[success]>
            3: <discord_button.with[id].as[connect_4_3].with[label].as[🔴].with[emoji].as[3️⃣].with[style].as[success]>
            4: <discord_button.with[id].as[connect_4_4].with[label].as[🔴].with[emoji].as[4️⃣].with[style].as[success]>
            5: <discord_button.with[id].as[connect_4_5].with[label].as[🔴].with[emoji].as[5️⃣].with[style].as[success]>
        2:
            6: <discord_button.with[id].as[connect_4_6].with[label].as[🔴].with[emoji].as[6️⃣].with[style].as[success]>
            7: <discord_button.with[id].as[connect_4_7].with[label].as[🔴].with[emoji].as[7️⃣].with[style].as[success]>
            8: <discord_button.with[id].as[connect_4_8].with[label].as[🔴].with[emoji].as[8️⃣].with[style].as[success]>
            9: <discord_button.with[id].as[connect_4_9].with[label].as[🔴].with[emoji].as[9️⃣].with[style].as[success]>
            10: <discord_button.with[id].as[connect_4_10].with[label].as[🔴].with[emoji].as[🔟].with[style].as[success]>
        3:
            11: <discord_button.with[id].as[connect_4_11].with[label].as[Bump].with[emoji].as[🔃].with[style].as[primary]>
            12: <discord_button.with[id].as[connect_4_12].with[label].as[Bonk].with[emoji].as[💢].with[style].as[primary]>
            13: <discord_button.with[id].as[connect_4_13].with[label].as[Forfeit].with[emoji].as[😟].with[style].as[danger]>

    - definemap embed:
        title: ⚪ Connect Four 🔴
        color: <color[0,254,255]>
        author_name: It's Hydra Behr's turn!
        author_icon_url: https://images-ext-2.discordapp.net/external/uWdVuLdqINhgFu1DhZzHJns_AkKh_piq2ob5hSzyEmw/https/media.discordapp.net/attachments/547556605328359455/603671749917147136/rainbow.gif
        description: <element[🟦].repeat_as_list[100].sub_lists[10].parse[unseparated].separated_by[<n>]><n>1️⃣2️⃣3️⃣4️⃣5️⃣6️⃣7️⃣8️⃣9️⃣🔟
        footer: Fly Fishing Funky placed 🔴 at LIVE SLUG REACTION
        footer_icon: https://cdn.discordapp.com/avatars/526237450171842570/a_ec0283d87a239df388bba779cac1a73d.gif

    - announce "<&e>length<&6><&co> <&a><discord_embed.with_map[<[embed]>].output_length>"
    - ~discordmessage id:c channel:984576778397945886 <discord_embed.with_map[<[embed]>]> rows:<[buttons]> save:game_message
    - flag server behr.discord.connect_4.games:<entry[game_message].message>

connect_4_command:
  type: world
  debug: true
  sub_scripts:
    not_ready_yet:
      - random:
        - ~discordinteraction reply ephemeral interaction:<context.interaction> "Not ready yet! <&lt>:screm:979068257300541511<&gt>"
        - ~discordinteraction reply ephemeral interaction:<context.interaction> "Not ready yet! <&lt>:occifer:978049718397579274<&gt>"
        - ~discordinteraction reply ephemeral interaction:<context.interaction> "Not ready yet! <&lt>a:bongobapbap:927405734474428476<&gt>"
        - ~discordinteraction reply ephemeral interaction:<context.interaction> "Not ready yet! <&lt>:wahr:908102524677009429<&gt>"
        - ~discordinteraction reply ephemeral interaction:<context.interaction> "<&lt>:puffer_pant_top:984018150892912670<&gt>Not ready yet!<n><&lt>:puffer_pant_middle:984018150741934120<&gt><n><&lt>:puffer_pant_bottom:984018150834208788<&gt>"

  events:
    on discord slash command name:connect_4:

      - define id <util.time_now.epoch_millis>
      - define user <context.interaction.user>
      - definemap options:
          1:
              label: Red
              value: 1
              #description: So much red!
              emoji: 🔴
          2:
              label: Orange Orange
              value: 2
              #description: Orange Orange
              emoji: 🟠
          3:
              label: Yeller
              value: 3
              description: That's pronounced "Riley" backwards!
              emoji: 🟡
          4:
              label: Not a creative color
              value: 4
              emoji: 🟢
          5:
              label: Blue
              value: 5
              emoji: 🔵
          6:
              label: Purpur
              value: 6
              emoji: 🟣
          7:
              label: Brown
              value: 7
              emoji: 🟤
          8:
              label: Black
              value: 8
              emoji: ⚫
          9:
              label: White
              value: 9
              emoji: ⚪
          10:
              label: Pufferfish
              value: 10
              emoji: 🐡
          11:
              label: Sneaky snaaaake
              value: 11
              emoji: 🐍
          12:
              label: Funky
              value: 12
              emoji: 🤡
          13:
              label: Angie
              value: 13
              emoji: 👹
          14:
              label: Monke
              value: 14
              emoji: 🐵
          #1:
          #    label: 
          #    value: 
          #    emoji: 


          #
      - define menu <discord_selection.with[id].as[connect_4_<[id]>].with[options].as[<[options]>]>
      - definemap data:
          width: <context.options.get[width].if_null[7]>
          height: <context.options.get[height].if_null[7]>
          player_one:
            user: <[user]>
          menu: <[options]>
      - if <context.options.contains[opponent]>:
        - define data.player_two.user <context.options.get[opponent]>
        - if <[data.player_two.user]> == <[user]>:
          - definemap embed:
              title: <&lt>a<&co>warn<&co>901634983867842610<&gt> **There was a problem**<&co> Self harm!
              color: <color[100,0,0]>
              description: You can't challenge yourself to the game
          - ~discordinteraction reply ephemeral interaction:<context.interaction> <discord_embed.with_map[<[embed]>]>
          - stop

      - if <[data.width]> < 5:
        - definemap embed:
            title: <&lt>a<&co>warn<&co>901634983867842610<&gt> **There was a problem**<&co> Too small!
            color: <color[100,0,0]>
            description: The board can't be less than five blocks wide
        - ~discordinteraction reply ephemeral interaction:<context.interaction> <discord_embed.with_map[<[embed]>]>
        - stop

      - else if <[data.width]> > 10:
        - definemap embed:
            title: <&lt>a<&co>warn<&co>901634983867842610<&gt> **There was a problem**<&co> Too big!
            color: <color[100,0,0]>
            description: The board can only be ten blocks wide
        - ~discordinteraction reply ephemeral interaction:<context.interaction> <discord_embed.with_map[<[embed]>]>
        - stop

      - if <[data.height]> < 5:
        - definemap embed:
            title: <&lt>a<&co>warn<&co>901634983867842610<&gt> **There was a problem**<&co> Too small!
            color: <color[100,0,0]>
            description: The board can't be less than five blocks tall
        - ~discordinteraction reply ephemeral interaction:<context.interaction> <discord_embed.with_map[<[embed]>]>
        - stop

      - else if <[data.height]> > 50:
        - definemap embed:
            title: <&lt>a<&co>warn<&co>901634983867842610<&gt> **There was a problem**<&co> Too big!
            color: <color[100,0,0]>
            description: The board can only be fifty blocks tall
        - ~discordinteraction reply interaction:<context.interaction> ephemeral <discord_embed.with_map[<[embed]>]>
        - stop

      - definemap embed:
          title: <[data.player_one.team.emoji].if_null[⚪]> Connect Four <[data.player_two.team.emoji].if_null[🔴]>
          color: <color[0,254,255]>
          description: Game created! Select your team color below <[user].mention>!
      - ~discordinteraction reply interaction:<context.interaction> <discord_embed.with_map[<[embed]>]>
      - if !<context.options.contains[opponent]>:
        - ~discordmessage id:c channel:<context.interaction.channel> "Awaiting opponent..." rows:<[menu]> save:message
      - else:
        - ~discordmessage id:c channel:<context.interaction.channel> "<[user].mention> challenged you to a game of Connect-Four, <context.options.get[opponent].mention>!<n>Pick your team color below!" rows:<[menu]> save:message

      - define data.selection_message <entry[message].message>
      - flag <entry[message].message> data:<[data]>
      - flag server behr.discord.connect_four.games.<[id]>:<[data]> expire:1m

    on discord selection used id:connect_4_*:
      # the game is too old now
      - if !<context.message.has_flag[data]>:
        - definemap embed:
            title: <&lt>a<&co>warn<&co>901634983867842610<&gt> **There was a problem**<&co> This events too old!
            color: <color[100,0,0]>
            description: This event ended already, challenge them to a new one lol
        - ~discordinteraction reply interaction:<context.interaction> ephemeral <discord_embed.with_map[<[embed]>]>
        - stop

      - define data <context.message.flag[data]>
      - define team <context.option>
      - define team_selection_formatted "<[team.emoji]> <[team.label]> <[team.emoji]>"
      - define user <context.interaction.user>


      - if <[user].has_flag[discord.ratelimit.connect_4_selection]> && <[user].flag[discord.ratelimit.connect_4_selection]> > 5:
        - definemap embed:
            title: <&lt>a<&co>warn<&co>901634983867842610<&gt> **There was a problem**<&co> Ratelimited!
            color: <color[100,0,0]>
            description: You're making selections too quickly, maybe chill out for a minute
        - ~discordinteraction reply interaction:<context.interaction> ephemeral <discord_embed.with_map[<[embed]>]>
        - flag <[user]> discord.ratelimit.connect_4_selection:++ expire:1m
        - stop

      - flag <[user]> discord.ratelimit.connect_4_selection:++ expire:1m

      # if it's player one responding
      - if <[data.player_one.user]> == <[user]>:
        # if they have a team already
        - if <[data.player_one].contains[team]>:
          # picked a team after already being on a team / already picking a team
          - definemap embed:
              title: <&lt>a<&co>warn<&co>901634983867842610<&gt> **There was a problem**<&co> Already on a team!
              color: <color[100,0,0]>
              description: You already picked <[data.player_one.team.emoji]> <[data.player_one.team.label]> <[data.player_one.team.emoji]>
          - ~discordinteraction reply interaction:<context.interaction> ephemeral <discord_embed.with_map[<[embed]>]>
          - stop

        # player one picks a team
        - define data.player_one.team <[team]>
        - flag <[data.selection_message]> data.player_one.team:<[team]>

      # if there's a second player involved with opponent<&co>
      - else if <[data].contains[player_two]>:
        # if the second player is the player responding
        - if <[data.player_two.user]> == <[user]>:
          - if <[data.player_two].contains[team]>:
            # picked a team after already being on a team / already picking a team
            - definemap embed:
                title: <&lt>a<&co>warn<&co>901634983867842610<&gt> **There was a problem**<&co> Already on a team!
                color: <color[100,0,0]>
                description: You already picked <[data.player_two.team.emoji]> <[data.player_two.team.label]> <[data.player_two.team.emoji]>, <[data.player_two.user].mention>!
            - ~discordinteraction reply interaction:<context.interaction> ephemeral <discord_embed.with_map[<[embed]>]>
            - stop

          - define data.player_two.team <[team]>
          - flag <[data.selection_message]> data.player_two.team:<[team]>

        # there's a second player, but this player isn't it
        - else:
          - definemap embed:
              title: <&lt>a<&co>warn<&co>901634983867842610<&gt> **There was a problem**<&co> This events not for you!
              color: <color[100,0,0]>
              description: This event is for <[data.player_two.user].mention>, unless they forfeit<n>You can always challenge them yourself with `/connect_4 opponent<&co>`<[data.player_two.user].mention>
          - ~discordinteraction reply interaction:<context.interaction> ephemeral <discord_embed.with_map[<[embed]>]>
          - stop

      # if there's no opponent set, then it's free rein
      - else:
        # check if they somehow took the same team
        - if <[data.player_one].contains[team]> && <[data.player_one.team.emoji]> == <[team.emoji]>:
          - definemap embed:
              title: <&lt>a<&co>warn<&co>901634983867842610<&gt> **There was a problem**<&co> Team is taken!
              color: <color[100,0,0]>
              description: <[data.player_one.user].mention> already took that team<n>Pick a different one!
          - ~discordinteraction reply interaction:<context.interaction> ephemeral <discord_embed.with_map[<[embed]>]>
          - stop

        - define data.player_two.user <[user]>
        - define data.player_two.team <[team]>
        - flag <[data.selection_message]> data.player_two.user:<[user]>
        - flag <[data.selection_message]> data.player_two.team:<[team]>

      - define team_one_formatted "<[data.player_one.team.emoji]> <[data.player_one.team.label]> <[data.player_one.team.emoji]>" if:<[data.player_one].contains[team]>
      - define team_two_formatted "<[data.player_two.team.emoji]> <[data.player_two.team.label]> <[data.player_two.team.emoji]>" if:<[data.player_two].contains[team].if_null[false]>

      - if !<[data.player_one].contains[team]> || !<[data].contains[player_two]> || !<[data.player_two].contains[team]>:
        - define new_menu <discord_selection.with[id].as[connect_4_<util.time_now.epoch_millis>].with[options].as[<[data.menu].exclude[<[team.value]>]>]>
        - if <[data.player_one].contains[team]>:
          - if <[data].contains[player_two]>:
            - ~discordmessage id:c edit:<[data.selection_message]> "<[data.player_one.user].mention> chose <[team_one_formatted]>!<n>Waiting on <[data.player_two.user].mention><&sq>s team selection to continue..." rows:<[new_menu]>
          - else:
            - ~discordmessage id:c edit:<[data.selection_message]> "<[data.player_one.user].mention> chose <[team_one_formatted]>!<n>Waiting on an opponent to select a team to continue..." rows:<[new_menu]>
        - else:
          - ~discordmessage id:c edit:<[data.selection_message]> "<[data.player_two.user].mention> chose <[team_two_formatted]>!<n>Waiting on <[data.player_one.user].mention><&sq>s team selection to continue..." rows:<[new_menu]>
        - ~discordinteraction defer interaction:<context.interaction>
        - ~discordinteraction delete interaction:<context.interaction>
        - stop

      - ~discordinteraction defer interaction:<context.interaction>
      - ~discordinteraction delete interaction:<context.interaction>
      - ~discordmessage id:c edit:<[data.selection_message]> "<[data.player_one.user].mention> chose <[data.player_one.team.emoji]> <[data.player_one.team.label]> <[data.player_one.team.emoji]>!<n><[data.player_two.user].mention> chose <[data.player_two.team.emoji]> <[data.player_two.team.label]> <[data.player_two.team.emoji]>!"

      - define emojis <element[🟦].repeat_as_list[<[data.width].mul[<[data.height]>]>].sub_lists[<[data.width]>].parse[unseparated].separated_by[<n>]><n><script.data_key[data.emojis.column_numbers].get[first].to[<[data.width]>].unseparated>
      - definemap embed:
          title:  <[data.player_one.team.emoji].if_null[⚪]> Connect Four <[data.player_two.team.emoji].if_null[🔴]>
          color: <color[0,254,255]>
          description: "`<[emojis]>`"

      - if <util.random_chance[50]>:
        - define embed.author_name "<[data.player_one.user].nickname[901618453356630046].if_null[<context.interaction.user.name>]><&sq>s turn!"
        - define embed.author_icon_url <[data.player_one.user].avatar_url>
        - define embed.footer "Opponent<&co> <[data.player_two.user].nickname[901618453356630046].if_null[<[data.player_two.user].name>]>"
        - define embed.footer_icon <[data.player_two.user].avatar_url>
      - else:
        - define embed.author_name "<[data.player_two.user].nickname[901618453356630046].if_null[<context.interaction.user.name>]><&sq>s turn!"
        - define embed.author_icon_url <[data.player_two.user].avatar_url>
        - define embed.footer "Opponent<&co> <[data.player_one.user].nickname[901618453356630046].if_null[<[data.player_one.user].name>]>"
        - define embed.footer_icon <[data.player_one.user].avatar_url>

      - repeat <[data.width]> as:i:
        - define buttons.<[i].div[5].round_up>.<[i]> <discord_button.with[id].as[connect_4_<[i]>].with[label].as[🔴].with[emoji].as[<script.data_key[data.emojis.column_numbers].get[<[i]>]>].with[style].as[success]>
      - define buttons.3.11 <discord_button.with[id].as[connect_4_bump].with[label].as[Bump].with[emoji].as[🔃].with[style].as[primary]>
      - define buttons.3.12 <discord_button.with[id].as[connect_4_bonk].with[label].as[Bonk].with[emoji].as[💢].with[style].as[primary]>
      - define buttons.3.13 <discord_button.with[id].as[connect_4_forfeit].with[label].as[Forfeit].with[emoji].as[😟].with[style].as[danger]>

      #- announce to_console <&4><[buttons].to_yaml>
      #- define buttons_1 <[buttons]>
      #- define buttons:!
      #- definemap buttons:
      #    1:
      #        1: <discord_button.with[id].as[connect_4_1].with[label].as[🔴].with[emoji].as[1️⃣].with[style].as[success]>
      #        2: <discord_button.with[id].as[connect_4_2].with[label].as[🔴].with[emoji].as[2️⃣].with[style].as[success]>
      #        3: <discord_button.with[id].as[connect_4_3].with[label].as[🔴].with[emoji].as[3️⃣].with[style].as[success]>
      #        4: <discord_button.with[id].as[connect_4_4].with[label].as[🔴].with[emoji].as[4️⃣].with[style].as[success]>
      #        5: <discord_button.with[id].as[connect_4_5].with[label].as[🔴].with[emoji].as[5️⃣].with[style].as[success]>
      #    2:
      #        6: <discord_button.with[id].as[connect_4_6].with[label].as[🔴].with[emoji].as[6️⃣].with[style].as[success]>
      #        7: <discord_button.with[id].as[connect_4_7].with[label].as[🔴].with[emoji].as[7️⃣].with[style].as[success]>
      #    #    8: <discord_button.with[id].as[connect_4_8].with[label].as[🔴].with[emoji].as[8️⃣].with[style].as[success]>
      #    #    9: <discord_button.with[id].as[connect_4_9].with[label].as[🔴].with[emoji].as[9️⃣].with[style].as[success]>
      #    #    10: <discord_button.with[id].as[connect_4_10].with[label].as[🔴].with[emoji].as[🔟].with[style].as[success]>
      #    3:
      #        11: <discord_button.with[id].as[connect_4_11].with[label].as[Bump].with[emoji].as[🔃].with[style].as[primary]>
      #        12: <discord_button.with[id].as[connect_4_12].with[label].as[Bonk].with[emoji].as[💢].with[style].as[primary]>
      #        13: <discord_button.with[id].as[connect_4_13].with[label].as[Forfeit].with[emoji].as[😟].with[style].as[danger]>
      #- announce to_console <&2><[buttons].to_yaml>
      #- define buttons_2 <[buttons]>
      #- if <[buttons_1]> == <[buttons_2]>:
      #  - narrate "<&a>Great success"

      - announce "<&e>length<&6><&co> <&a><discord_embed.with_map[<[embed]>].output_length>"
      - ~discordmessage id:c channel:<context.interaction.channel> <discord_embed.with_map[<[embed]>]> rows:<[buttons]> save:message

    on discord button clicked id:connect_4_*:
      - if <context.interaction.user.id> != 194619362223718400:
        - inject connect_4_command.sub_scripts.not_ready_yet
      - announce to_console <context.button>
      - define action <context.button.map.get[id].after_last[_]>
      - define user <context.interaction.user>
      - choose <[action]>:
        - case 1 2 3 4 5 6 7 8 9 10:
          - narrate number
        - case bump:
          - narrate bump
        - case bonk:
          - narrate bonk
        - case forfeit:
          - narrate forfeit
  data:
    emojis:
      # unused
      background: 🟦
      # column_numbers
      column_numbers:
      - 1️⃣
      - 2️⃣
      - 3️⃣
      - 4️⃣
      - 5️⃣
      - 6️⃣
      - 7️⃣
      - 8️⃣
      - 9️⃣
      - 🔟
        #footer: Use the bump button to move the playing board to the bottom of the chat!
        #footer_icon: https://emojipedia-us.s3.dualstack.us-west-1.amazonaws.com/thumbs/240/microsoft/310/clockwise-vertical-arrows_1f503.png
