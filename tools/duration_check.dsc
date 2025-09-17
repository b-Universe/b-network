verify_duration:
  type: task
  debug: false
  definitions: duration_input
  script:
    # % ██ [ start with empty lists                                          ] ██:
    - define current_integer <list>
    - define duration_parts <list>

    # % ██ [ loop through each character                                     ] ██:
    - foreach <[duration_input].to_list> as:character:

      # % ██ [ combine all characters that prefix any possible duration unit ] ██:
      - if <[character].is_integer>:
        - define current_integer <[current_integer].include_single[<[character]>]>

      # % ██ [ concatenate the integers into a list with the duration unit   ] ██:
      # % ██ [ reset the current integer                                     ] ██:
      - else:
        - define duration_parts <[duration_parts].include_single[<[current_integer].unseparated><[character]>]>
        - define current_integer <list>

    # % ██ [ verify each duration, add to a total durationtag if valid       ] ██:
    - define duration <duration[0s]>
    - foreach <[duration_parts]> as:duration_part:
      - if <duration[<[duration_part]>].exists>:
        - define duration <[duration].add[<[duration_part]>]>

      # % ██ [ return invalid                                                ] ██:
      - else:
        - definemap message:
            text: <&c>Invalid usage - <&e><[duration_part]> is an invalid duration
            hover:
              - <&b>Valid duration inputs<&co>
              - t <&6>= <&a>ticks <&6>(<&e>0<&6>.<&e>05 seconds<&6>)
              - s <&6>= <&a>seconds <&6>(<&e>20 ticks<&6>)
              - m <&6>= <&a>minutes <&6>(<&e>60 seconds<&6>)
              - h <&6>= <&a>hours <&6>(<&e>60 minutes<&6>)
              - d <&6>= <&a>days <&6>(<&e>24 hours<&6>)
              - w <&6>= <&a>weeks <&6>(<&e>7 days<&6>)
              - y <&6>= <&a>years <&6>(<&e>365 days<&6>)
        - narrate <[message.text].on_hover[<[message.hover].separated_by[<n><&e>]>]>
        #                                                    .on_click[/command ].type[suggest_command]>
        - stop

verify_duration_discord:
  type: task
  debug: false
  definitions: duration_input
  script:
    # % ██ [ start with empty lists                                          ] ██:
    - define current_integer <list>
    - define duration_parts <list>

    # % ██ [ loop through each character                                     ] ██:
    - foreach <[duration_input].to_list> as:character:

      # % ██ [ combine all characters that prefix any possible duration unit ] ██:
      - if <[character].is_integer>:
        - define current_integer <[current_integer].include_single[<[character]>]>

      # % ██ [ concatenate the integers into a list with the duration unit   ] ██:
      # % ██ [ reset the current integer                                     ] ██:
      - else:
        - define duration_parts <[duration_parts].include_single[<[current_integer].unseparated><[character]>]>
        - define current_integer <list>

    # % ██ [ verify each duration, add to a total durationtag if valid       ] ██:
    - define duration <duration[0s]>
    - foreach <[duration_parts]> as:duration_part:
      - if <duration[<[duration_part]>].exists>:
        - define duration <[duration].add[<[duration_part]>]>

      # % ██ [ return invalid                                                ] ██:
      - else:
        - definemap embed_data:
            title: <&lt>/remindme<&co>1201903940476878900<&gt> Invalid Duration
            description: For reference on using this properly<&co><n>`t`=ticks (0.05 seconds), `s`=seconds, <n>`m`=minutes (60 seconds), `h`=hours (60 minutes),<n> `d`=days (24 hours), and `w`=weeks (7 days)
            color: 100,0,0
            footer: <context.options.get[duration]> is an invalid duration.
            footer_icon: https://cdn.discordapp.com/emojis/901634983867842610.gif
        - define embed <discord_embed.with_map[<[embed_data]>]>
        - ~discordinteraction reply interaction:<context.interaction> <[embed]> save:message ephemeral
        - stop
