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
    - define commands <server.scripts.filter[data_key[type].equals[command]].filter[name.ends_with[_command]].filter_tag[<player.has_flag[behr.essentials.<[filter_tag].name.before_last[_]>]>]>
    # todo: introduce the row quantity setting to the settings menu
    - define row_count <player.flag[behr.essentials.settings.help_row_count].if_null[7]>
    - define max_page_index <[commands].sub_lists[<[row_count]>].size.round_up>
    - define message <[message].include[<[commands].sub_lists[<[row_count]>].get[<[page_index]>].parse_tag[<&e><[parse_value].data_key[usage]> <&b>| <&a><[parse_value].description>]>]>
    - define message <[message].include_single[--- page 1 of something ---]>
    
    - announce to_console <[message].separated_by[<n>]>
