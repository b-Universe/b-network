create_shots:
  type: task
  debug: false
  script:
  - definemap options:
      1:
        type: integer
        name: min
        description: The minimum number of shots you want to take
        required: false
      2:
        type: integer
        name: max
        description: The maximum number of shots you want to take
        required: false

  - ~discordcommand id:c create name:shots "description:Randomizes a number of shots for you to take." group:901618453356630046 options:<[options]>

shots_command:
  type: world
  debug: false
  events:
    on discord slash command name:shots:
    - ~discordinteraction defer interaction:<context.interaction>

    - define minimum <context.options.get[min].if_null[0]>
    - define maximum <context.options.get[max].if_null[8]>
    - define embed.thumbnail https://cdn.discordapp.com/attachments/901618453746712665/912034620151836672/liquors.png

    - define embed.color <color[0,254,255]>
    - define embed.title "Randomized shot generator says..."
    - define shots <util.random.int[<[minimum]>].to[<[maximum]>]>

    - if <[minimum]> < 0 || <[maximum]> < 0:
      - define embed.footer "You can't take negative shots!"
      - define embed.footer_icon https://cdn.discordapp.com/emojis/901634983867842610.gif
      - define embed.thumbnail:!

    - else if <[shots]> == 0:
      - define embed.description "No shots for you!"

    - else if <[shots]> == 1:
      - define embed.description "Take one shot!"

    - else:
      - define embed.description "Take <[shots]> shots!"

    - if <[shots]> > 128:
      - define embed.footer "Note: Blood alcohol levels over 85<&pc> are not recommended"
      - define embed.footer_icon https://cdn.discordapp.com/emojis/901634983867842610.gif

    - else if <[shots]> > 6:
      - define embed.footer "Please drink responsibly"
      - define embed.footer_icon https://cdn.discordapp.com/emojis/901634983867842610.gif

    - ~discordinteraction reply interaction:<context.interaction> <discord_embed.with_map[<[embed]>]>
