player_leave_handler:
  type: world
  debug: false
  events:
    on player quits:
      # ██ [ let everyone know they left, if they aren't constantly leaving ] ██:
      - determine cancelled if:<player.has_flag[behr.essentials.ratelimit.leave_announcement]>
      - flag player behr.essentials.ratelimit.leave_announcement expire:10s
      - determine "<&b><player.name> left b"
