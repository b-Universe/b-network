player_join_handler:
  type: world
  debug: false
  events:
    on player joins:
      - define time <util.time_now>
      - define returning_player <player.has_flag[behr.essentials.profile.first_joined]>

      # ██ [ check if this is the first time joining                          ] ██:
      - if !<[returning_player]>:

        # ██ [ base flags                                                     ] ██:
        - flag player behr.essentials.profile.first_joined:<[time]>

        # ██ [ apply experience and levels                                    ] ██:
        - foreach construction|magic|technology as:stat:
          - if !<player.has_flag[behr.essentials.profile.stats.<[stat]>]>:
            - flag <player> behr.essentials.profile.stats.<[stat]>.experience:0
            - flag <player> behr.essentials.profile.stats.<[stat]>.level:1

      # ██ [ check for a namechange                                           ] ██:
      - if !<player.has_flag[behr.essentials.profile.data.names_owned.<player.name>]>:
        - flag player behr.essentials.profile.data.names_owned.<player.name>:<[time]>

      # ██ [ apply permissions                                                ] ██:
      - if !<player.has_flag[behr.essentials.groups]>:
        - definemap data:
            player: <player>
            action: grant
            group: newbie
        - run group_permission_handler defmap:<[data]>

      # ██ [ give the available starting and kit items                        ] ██:
      - run player_join_items_and_stuff def:<[returning_player]>

      # ██ [ announce the player join and chat announcements                  ] ██:
      - inject player_join_announcement_task
      - run player_join_discord_announcement_task def:true|<[time]>

      - wait 10s
      - if !<player.has_flag[behr.essentials.muted]>:
        - narrate "<&3>Welcome again to B; If you'd like to check out the discord, you can join at <&b><underline>https<&co>//www.behr.dev/Discord <&3>- We<&sq>re accepting feature requests, suggestions, and any kind of feedback you'd like to provide!"
      - else:
        - narrate "<red>Remember, you<&sq>re still muted. You can appeal on the discord at <&b><underline>https<&co>//www.behr.dev/Discord" targets:<player>


player_join_items_and_stuff:
  type: task
  definitions: returning_player
  script:
    - if <player.health> != 40:
      - adjust <player> max_health:40
      - heal <player>

    - if !<[returning_player]>:
      - give elytra
      - give physics_device
      - give bwand
      - give lime_bed
      - give lime_shulker_box
      - give firework_rocket quantity:192
      - give space_fruit quantity:256
      - give space_juice quantity:6
    - else:
      - if !<player.has_flag[behr.essentials.ratelimit.starter_kit]>:
        - flag <player> behr.essentials.ratelimit.starter_kit expire:2h
        - inject create_starter_kit
        - define kit <[starter_kit]>
        - give starter_kit

    - if <server.has_flag[behr.essentials.uniques.<player.uuid>.space_suit]>:
      - if !<player.has_flag[behr.essentials.ratelimit.unique_space_suit_reward]>:
        - flag <player> behr.essentials.ratelimit.unique_space_suit_reward expire:7d
        - narrate "<&3>The Galactic Federation of B has gifted this unique space suit for your contribution here at B. We thank you for your support."
      - define equipment_map <server.flag[behr.essentials.uniques.<player.uuid>.space_suit]>
    - else:
      - definemap equipment_map:
          helmet: respira_space_suit_helmet_WC1
          chest: elytra
          boots: respira_space_suit_boots
    - if !<player.inventory.contains_item[<[equipment_map.helmet]>]> && !<player.equipment_map.contains[helmet]>:
      - equip head:<[equipment_map.helmet]>
    - if !<player.inventory.contains_item[<[equipment_map.chest]>]> && !<player.equipment_map.contains[chest]>:
      - equip chest:<[equipment_map.chest]>
    - if !<player.inventory.contains_item[<[equipment_map.boots]>]> && !<player.equipment_map.contains[boots]>:
      - equip boots:<[equipment_map.boots]>

    - adjust <player> discover_recipe:<server.recipe_ids.filter[contains_text[denizen]]>
    - adjust <player> resend_recipes

player_join_announcement_task:
  type: task
  definitions: returning_player
  script:
    # ██ [ let everyone know they joined, if they aren't constantly joining ] ██:
    - stop if:<player.has_flag[behr.essentials.ratelimit.join_announcement]>
    - flag player behr.essentials.ratelimit.join_announcement expire:1m

    # ██ [ Check if joining for the first time, or not                      ] ██:
    - if <[returning_player]>:
      - define text "<&b><player.name> joined b"
    - else:
      - define text "<&c>🎊<&6>🎊<&e>🎉 <&b><player.name> joined B for the first time! <&e>🎉<&6>🎊<&c>🎊"

    # ██ [ send the message                                                 ] ██:
    - playsound <server.online_players> entity_player_levelup pitch:<util.random.decimal[0.8].to[1.2]> volume:0.3
    - determine <[text]> passively

player_join_discord_announcement_task:
  type: task
  definitions: returning_player|time
  script:
    # ██ [ let everyone know they joined, if they aren't constantly joining ] ██:
    - stop if:<player.has_flag[behr.essentials.ratelimit.discord_join_announcement]>
    - flag player behr.essentials.ratelimit.discord_join_announcement expire:10m

    # ██ [ base defintions                                                  ] ██:
    - define embed.color <color[0,254,255].rgb_integer>
    - define player.name <player.name>
    - define player.uuid <player.uuid>

    # ██ [ Check if joining for the first time, or not                      ] ██:
    - if <[returning_player]>:
      - define embed.description "<[player.name]> joined b"
    - else:
      - define embed.title "🎉 <[player.name]>A new player joined! 🎉"
      - define embed.description "🎉🎊🎊🎊🎊🎉<n> joined B for the first time! <n>**<[player].name>** to b!"
      - define embed.image.url https<&co>//crafatar.com/renders/body/<[player.uuid]>?overlay=true&scale=3&<[time].format[MM-dd]>

    # ██ [ construct webhook message                                        ] ██:
    - definemap payload:
        username: <player.name>
        avatar_url: https://minotar.net/armor/bust/<[player.uuid].replace_text[-]>/100.png?date=<[time].format[MM-dd]>
        embeds: <list_single[<[embed]>]>
        allowed_mentions:
          parse: <list>

    - define webhook_url <secret[discord_chat_webhook]>
    - define webhook_url <secret[discord_test_webhook]> if:<server.has_flag[behr.developmental.debug_mode]>

    - definemap headers:
        Authorization: <secret[bbot]>
        Content-Type: application/json
        User-Agent: b

    # ██ [ send discord relay message                                       ] ██:
    - ~webget <[webhook_url]> headers:<[headers]> data:<[payload].to_json> save:response
    - inject web_debug.webget_response if:<server.has_flag[behr.developmental.debug_mode]>
