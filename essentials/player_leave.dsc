player_leave_handler:
  type: world
  debug: false
  events:
    on player quits:
      # ██ [ let everyone know they left, if they aren't constantly leaving ] ██:
      - determine cancelled if:<player.has_flag[behr.essentials.ratelimit.leave_announcement]>
      - flag player behr.essentials.ratelimit.leave_announcement expire:10s

        # ██ [ base defintions            ] ██:
      - define action leave
      - define time <util.time_now>
      - definemap player_data:
          name: <player.name>
          uuid: <player.uuid>
      - define text "<&b><player.name> left b"

      # ██ [ announce the player leave    ] ██:
      - determine <[text]> passively
      - determine cancelled if:<player.has_flag[behr.essentials.ratelimit.discord_leave_announcement]>
      - flag player behr.essentials.ratelimit.discord_leave_announcement expire:10m
      - inject discord_door_message
