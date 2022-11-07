help_command:
  type: command
  debug: true
  name: help
  description: Shows helpful command information
  usage: /help (<&ns>)
  permission: behr.essentials.help
  script:
  # % ██ [ check arguments ] ██
    - if <context.args.size> > 1:
      - inject command_syntax_error

  # % ██ [ check for index ] ██
    - if !<context.args.is_empty>:
      - define page_index <context.args.first>
      - if !<[page_index].is_integer>:
        - inject command_syntax_error
    - else:
      - define page_index 1

  # % ██ [ build command list ] ██
    - define message <list>
    - define message "<[message].include_single[commands available<&co>]>"
    - define commands <util.scripts.filter[data_key[type].equals[command]].filter[name.ends_with[_command]].filter_tag[<player.has_flag[behr.essentials.permissions.commands.<[filter_value].name.before_last[_]>]>]>
    # todo: introduce the row quantity setting to the settings menu
    - define row_count <player.flag[behr.essentials.settings.help_row_count].if_null[7]>
    - define max_page_index <[commands].sub_lists[<[row_count]>].size.round_up>
    - define message <[message].include[<[commands ].sub_lists[<[row_count]>].get[<[page_index]>].parse_tag[<[parse_value].parsed_key[usage].proc[command_syntax_format]> <&b>| <&[green]><[parse_value].data_key[description]>]>]>
    - define message <[message].include_single[--- page 1 of <[max_page_index]> ---]>

    - narrate <[message].separated_by[<n>]>



basic_perm_flags:
  type: task
  data:
    player:
      - chat_channel
      - chat_settings
      - colors
      - emoji_board
      - friend
      - help
      - me
      - ping
      - rules
      - suicide
    sponsors:
      - hat
      - head
      - skin
    builder:
      # todo: add checks for builder gamemode
      - ascend
      - buildermode
      - clear_inventory
      - fly
      - fly_speed
      - run
      - run_speed
      - teleport_menu
      - time
      - weather
      - world
    mod:
      - clear_ground
      - enchant
      - food
      - heal
      - hunger
      - lore
      - max_health
      - max_oxygen
      - oxygen
    admin:
      - clear_console
      - gamemode
      - rename_item
      - restore_inventory


  script:
    - foreach <script.data_key[data.player]> as:permission:
      - flag <player> behr.essentials.permissions.commands.<[permission]>
