
minesweeper_command:
  type: world
  debug: false
  events:
    on discord slash command name:minesweeper:
    #- ~discordinteraction defer interaction:<context.interaction>

    - define width <context.options.get[width].if_null[6]>
    - define height <context.options.get[height].if_null[6]>
    - define intensity <context.options.get[intensity].if_null[<[width].mul[<[height]>].div[4].round>]>

    - foreach <[height]>|<[width]>|<[intensity]> as:arg:
      - if <[arg]> < 0:
        - definemap embed:
            title: <&lt>a<&co>warn<&co>901634983867842610<&gt> **There was a problem**<&co> Too much negativity!
            color: <color[100,0,0]>
            description: You can't have negative numbers here!<n>Use positive numbers for the width, height, and intensity of a board!
        - ~discordinteraction reply interaction:<context.interaction> <discord_embed.with_map[<[embed]>]>
        - stop

    - foreach <[height]>|<[width]>|<[intensity]> as:arg:
      - if <[arg]> == 0:
        - definemap embed:
            title: <&lt>a<&co>warn<&co>901634983867842610<&gt> **There was a very complicated problem**<&co> Infinitly complicated!
            color: <color[100,0,0]>
            description: Someone divided by zero!<n> Width and height can't be zero<n>And an intensity level of zero would be too easy!
        - ~discordinteraction reply interaction:<context.interaction> <discord_embed.with_map[<[embed]>]>
        - stop
      - else if <[arg]> == 1:
        - definemap embed:
            title: <&lt>a<&co>warn<&co>901634983867842610<&gt> **There wasn't a problem**;
            color: <color[100,0,0]>
            description: But you should make a board larger than one block long or wide!
        - ~discordinteraction reply interaction:<context.interaction> <discord_embed.with_map[<[embed]>]>
        - stop

    - if <[width].mul[<[height]>]> < <[intensity]>:
      - definemap embed:
          title: <&lt>a<&co>warn<&co>901634983867842610<&gt> **There was a problem**<&co> too many bombs!
          color: <color[100,0,0]>
          description: Your Minesweeper board would have more bombs than tiles with that high of intensity<n>Try using a smaller number for the intensity, or a make bigger board!
      - ~discordinteraction reply interaction:<context.interaction> <discord_embed.with_map[<[embed]>]>
      - stop

    - define context "<list_single[<&co>arrow_up_down<&co> Height<&co> **<[height]>** | <&co>left_right_arrow<&co> Width<&co> **<[width]>** | <&co>video_game<&co> intensity<&co> **<[intensity]>**]>"
    - define context <[context].include_single[<element[<&lt>a<&co>colorbar<&co>913245079328673793<&gt>].repeat[<[width].add[2]>]>]>

    - define corner <location[0,0,0].with_world[<server.worlds.first>]>
    - define board <[corner].to_cuboid[<[corner].right[<[width].sub[1]>].backward[<[height].sub[1]>]>]>
    - define bombs <[board].blocks.random[<[intensity]>]>
    - chunkload <[board].partial_chunks> duration:1s
    - flag <[bombs]> minesweeper.bomb expire:1s

    - foreach <[board].blocks> as:tile:
      # Check if we're on the first column of a new row;
      # The [first loop] or [<[width].add[1]>] .modular[<[width]>] will always return one
      - if <[loop_index].mod[<[width]>]> == 1:
        - define row:++
        - define colorful_border_emoji <script[minesweeper_emoji].data_key[colorful_border.<[row].mod[6]>]>
        - define board_emojis.<[row]>:->:<[colorful_border_emoji]>
      - if !<[tile].has_flag[minesweeper.bomb]>:
        - define bomb_count <[tile].center.find_blocks_flagged[minesweeper.bomb].within[1.415].size>
        - define emoji ||<&co><script[minesweeper_emoji].data_key[numbers.<[bomb_count]>]><&co>||
      - else:
        - define emoji ||<&co>boom<&co>||
      - define board_emojis.<[row]>:->:<[emoji]>
      - if <[loop_index].mod[<[width]>]> == 0:
        - define board_emojis.<[row]>:->:<[colorful_border_emoji]>

    - foreach <[board_emojis]> key:row as:columns:
      - narrate "row <[row]> column <[columns].unseparated>"
      - define context <[context].include_single[<[columns].unseparated>]>
    - define description <[context].separated_by[<n>]>
    - if <[description].length> < 4000:
      - definemap embed:
          title: <&co>boom<&co> Let's play some **Minesweeper**! <&co>boom<&co>
          color: <color[0,254,255]>
          description: <[description]>
    - else:
      - definemap embed:
          title: <&lt>a<&co>warn<&co>901634983867842610<&gt> **There was a problem**<&co> Big board too big!
          color: <color[100,0,0]>
          description: Discord messages can only be so long<n>Try using a smaller size for the Minesweeper board!
    - if <[description].length> > 2200:
      - define embed.footer "Note<&co> There may be a bug with this embed, it might get fixed later kek"
    - ~discordinteraction reply interaction:<context.interaction> <discord_embed.with_map[<[embed]>]>

create_minesweeper_command:
  type: task
  debug: false
  script:
  - definemap options:
      1:
        type: integer
        name: width
        description: Sets the width of the board (Default<&co> 6)
        required: false
      2:
        type: integer
        name: height
        description: Sets the height of the board (Default<&co> 6)
        required: false
      3:
        type: integer
        name: intensity
        description: Sets the intensity of the board (Default<&co> math)
        required: false

  - ~discordcommand id:c create name:minesweeper "description:Creates a mini Minesweeper game that you can play" group:901618453356630046 options:<[options]>

minesweeper_emoji:
  type: data
  numbers:
    1: one
    2: two
    3: three
    4: four
    5: five
    6: six
    7: seven
    8: eight
    0: zero
  colorful_border:
    1: 🟥
    2: 🟧
    3: 🟨
    4: 🟩
    5: 🟦
    0: 🟪
