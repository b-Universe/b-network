player_join_handler:
  type: world
  debug: false
  events:
    on player joins:
      # ██ [ let everyone know they joined, if they aren't constantly joining ] ██:
      - determine cancelled if:<player.has_flag[behr.essentials.ratelimit.join_announcement]>
      - flag player behr.essentials.ratelimit.join_announcement expire:10s

        # ██ [ base defintions                ] ██:
      - define time <util.time_now>
      - definemap player_data:
          name: <player.name>
          uuid: <player.uuid>

      - if <player.has_flag[behr.essentials.profile.first_joined]>:
        - define action join
        # ██ [ check for a namechange         ] ██:
        - if !<player.has_flag[behr.essentials.profile.data.names_owned.<player.name>]>:
          - flag player behr.essentials.profile.data.names_owned.<player.name>:<util.time_now>

        # ██ [ base defintions                ] ██:
        - define text "<&b><player.name> joined b"

      - else:
        - define action first_join
        # ██ [ default profile flags and data ] ██:
        - definemap data:
            player: <player>
            action: grant
            group: newbie
        - run group_permission_handler defmap:<[data]>

        - flag player behr.essentials.profile.first_joined:<util.time_now>
        - foreach construction|magic|technology as:stat:
          - if !<player.has_flag[behr.essentials.profile.stats.<[stat]>]>:
            - flag <player> behr.essentials.profile.stats.<[stat]>.experience:0
            - flag <player> behr.essentials.profile.stats.<[stat]>.level:1

        # ██ [ base defintions                ] ██:
        - define text "<&c>🎊<&6>🎊<&e>🎉 <&b><player.name> joined B for the first time! <&e>🎉<&6>🎊<&c>🎊"

        - teleport <player> <server.flag[behr.essentials.spawn_location]>
        - give space_pickaxe
        - give elytra
        - give physics_device
        - give lime_bed
        - give lime_shulker_box
        - give firework_rocket quantity:64
        - give space_fruit quantity:256
        - give space_juice quantity:6

        - if <server.has_flag[behr.essentials.uniques.<player.uuid>.space_suit]>:
          - if !<player.has_flag[behr.essentials.ratelimit.unique_space_suit_reward]>:
            - flag <player> behr.essentials.ratelimit.unique_space_suit_reward expire:7d
            - narrate "<&3>The Galactic Federation of B has gifted this unique space suit for your contribution here at B. We thank you for your support."
          - define equipment_map <server.flag[behr.essentials.uniques.<player.uuid>.space_suit]>

        - else:
          - definemap equipment_map:
              helmet: respira_space_suit_helmet_WC1
              chest: respira_space_suit_top
              legs: respira_space_suit_boots

        - equip head:<[equipment_map.helmet]> chest:<[equipment_map.chest]> boots:<[equipment_map.legs]>

        - adjust <player> max_health:40
        - heal <player>

      # ██ [ announce the player join         ] ██:
      - playsound <server.online_players> entity_player_levelup pitch:<util.random.decimal[0.8].to[1.2]> volume:0.3
      - determine <[text]> passively
      - inject discord_door_message
      - wait 10s
      - if !<player.has_flag[behr.essentials.muted]>:
        - narrate "<&3>Welcome again to B; If you'd like to check out the discord, you can join at <&b><underline>https<&co>//www.behr.dev/Discord <&3>- We<&sq>re accepting feature requests, suggestions, and any kind of feedback you'd like to provide!"
      - else:
        - narrate "<red>Remember, you<&sq>re still muted. You can appeal on the discord at <&b><underline>https<&co>//www.behr.dev/Discord" targets:<player>

      - if <player.is_online>:
        - adjust <player> discover_recipe:<server.recipe_ids.filter[contains_text[denizen]]>
        - adjust <player> resend_recipes
