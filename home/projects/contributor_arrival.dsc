contributor_arrival:
  type: world
  debug: true
  events:
    on player joins:
      - define uuid <player.uuid>
      - if !<server.has_flag[behr.back_data.wait_for_player]>:
        - stop

      - foreach <server.flag[behr.back_data.wait_for_player].keys> as:project:
        - choose <[project]>:
          # there's just one case for room for more, i hope
          - case bread_factory emoji_board:
            - if !<server.has_flag[behr.back_data.wait_for_player.<[project]>.<[uuid]>]>:
              - stop

            - define contributions <server.flag[behr.back_data.wait_for_player.<[project]>.<[uuid]>]>

            - narrate "<&a>You were marked as a contributor for the project <&e><[project]><&a>; Thanks for your contribution! This notification is to note that your contribution notes prior to your actual existence here have been updated; In the contributions section of the Bread Factory, you'll find that you've been appreciated for the following contributions<&co><[content].parse_tag[<&e>- <&a><[parse_value]>].separated_by[<n>]>"
            - flag server behr.<[project]>.contributors.<player>:|:<[contributions]>
            - flag server behr.back_data.wait_for_player.<[project]>.<[uuid]>:!
