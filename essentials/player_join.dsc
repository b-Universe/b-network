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

    - give b_book if:!<player.inventory.contains_item[b_book]>
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
        - give <[starter_kit]>

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
        username: <[player.name]>
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


b_book:
  type: item
  debug: false
  material: written_book
  mechanisms:
    book:
      author: B
      title: <&b>All Things B
      pages:
        - <&3>Here on B, you'll find a large number of new, custom, and tweaked features. <n><n>Amongst them are concatenated in this book for you!
        - <&[fancy_title]><bold>bEdit ● Master Building Tools<n><&3>If you're familiar with WorldEdit, you can familiarize yourself with systematic building tools here called bEdit! Quickly build, construct, and excavate to your hearts desire with this fantastic set of tools

        - <&3>Higher construction levels will allow you to change more blocks at a time and learn new construction commands! The starting commands you receive are<&co><n><&3>● <&6>//pos1 <&3>& <&6>//pos2 <&3>for manual position selection.<n>● <&6>//set <&3>to set the blocks in a selection to another material

        - <&[fancy_title]><bold>Other bEdit commands<&co><n><n><&3>● <&6>//ceiling<n><&3>● <&6>//floor<n><&3>● <&6>//shell<n><&3>● <&6>//walls<n><&3>● <&6>//center<n><&3>● <&6>//stack<n><&3>● <&6>//frame<n><&3>● <&6>//undo

        - <&3>To create the <&[fancy_title]>Selection tool<&3> called the <&[fancy_title]>bWand<&3>, use the following ingredients: <n>● Four Molten Gold Blocks<n>● Two Iron Blocks<n>● One Molten Redstone Block<n>● One Perfect Emerald<n>● One Fortified Blaze Rod <n>(1/2)
        - <&3>Each of these can be crafted by combining or smelting the ingredients from a large quantity. Check your recipe book for help (2/2)

        - <&[fancy_title]><bold>Starting kits<n><&3>When you log in, you'll receive a kit every few hours. It's cram-packed with delicious food and essentials

        - <&[fancy_title]><bold>/dback & /bed command<n><&3>If you die, you'll have some time to return back to your death location once with <&6>/dback<&3> and to your bed location with <&6>/bed<&3>

        - <&[fancy_title]><bold>/spawn command<n><&3>If you're looking for a new home, you can try randomly teleporting again from the spawn using <&6>/spawn<&3>. Don't be scared of the new spawning mechanics in the End, you won't float away from shulker attacks

        - <&[fancy_title]><bold>/resource command<n><&3>If you want the resource pack but declined it the first time, you can use <&6>/resource<&3> to serve it again, or just relog

        - <&[fancy_title]><bold>/settings command<n><&3>You can disable the sounds you hear on commands in your settings. There will be more available as time comes to customize

        - <&[fancy_title]><bold>Flight charging<n><&3>You can save yourself some firework charges (and escape potential danger!) by holding your sneak button while gliding. Remember it has a cooldown!

        - <&[fancy_title]><bold>Obtaining Water<n><&3>You'll notice an abundance of water. You can generate water with infinite water sources or mine ice shards from andesite in The End

        - <&[fancy_title]><bold>Mob effects<n><&3>Chicken eggs may hatch if left unattended!<n>Phantoms are exceptionally grabby!<n>slimes split funny.<n>Skeletons have taken flight!<n><n><&[fancy_title]><bold>Climbing<n><&3>You can climb chains!

        - <&[fancy_title]><bold>Colors n' stuff<n><&3>You can color your chat or signs by using the color codes with your text<n><n><&[fancy_title]><bold>Enchantments<n><&3>There are custom enchantments, such as higher flame levels!

        - <&[fancy_title]><bold>New Foods<bold><n><&3>Enjoy new things to eat like hotdogs, sandwiches, and gyros!<n><n><&[fancy_title]><bold>Dispensers<n><&3>These lovely redstone pieces can now place concrete powder blocks
