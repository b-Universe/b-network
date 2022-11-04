player_join_handler:
  type: world
  data:
    default_permissions:
      - behr.essentials.permissions.read_chat_channel.all
      - behr.essentials.permissions.read_chat_channel.player_chat
      - behr.essentials.permissions.read_chat_channel.system
      - behr.essentials.permissions.read_chat_channel.narrate
  events:
    on player joins flagged:!first_joined:
      - foreach <script.data_key[data.default_permissions]> as:permission:
        - flag <player> <[permission]>
      - flag <player> first_joined:<util.time_now>
