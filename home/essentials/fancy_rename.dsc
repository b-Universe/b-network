fancy_rename_command:
  type: command
  debug: true
  name: fancy_rename
  usage: /fancy_rename (add <&lt>text<&gt>) / (set <&lt>line <&ns><&gt> <&lt>text<&gt>) / (remove <&lt>line <&ns><&gt>)
  description: Renames an NPC with text parsing colors, Denizen tags, and placeholders per player
  permission: behr.essentials.fancy_rename
  sub_paths:
    parse_name:
      # parse the colors and formatting
      - define name <[raw_name].parse_color>

      # check if they might be using %placeholders%
      - if <[name].contains[<&pc>]> && <[name].to_list.count[<&pc>]> > 1:
        - define name_split <[name].split[<&pc>]>
        - define new_name_split <list>
        - foreach <[name_split]> as:text:
          - if <[loop_index].is_odd>:
            - define new_name_split <[new_name_split].include_single[<[text].escaped>]>
          - else:
            - define new_name_split <[new_name_split].include_single[<&lt>placeholder<&lb><[text]><&rb>.player<&lb><&lt>player<&gt><&rb><&gt>]>
      - define new_name <[new_name_split].unseparated.unescaped.replace[&pc].with[<&pc>]>
  script:
    # make sure there's an NPC attached
    - if !<npc.exists>:
      - narrate "<&[error]>You need to select an NPC!"
      - stop

    # make sure there's a name
    - if <context.args.is_empty>:
      - narrate "<&[error]>You have to type arguments!"
      - narrate "/fancy_rename add <&lt>text<&gt> | Adds a new line to the NPC's name"
      - narrate "/fancy_rename set <&lt>line<&ns><&gt> <&lt>text<&gt> | Sets the line of an NPC's name"
      - narrate "/fancy_rename remove <&lt>line<&ns><&gt> | Removes a specific line on the NPC"
      - narrate "/npc hologram lineheight <&lt>height<&gt> | Sets the distance between the NPC's rows of names"
      - narrate "/npc hologram direction <&lt>up/down<&gt>"
      - narrate "/npc hologram clear | Removes every line of fancy naming on this NPC!"
      - stop

    # check if setting an index
    - choose <context.args.first>:
      - case add:
        - if <context.args.size> == 1:
          - narrate "<&[error]>When adding a name line, specify a new name!"
          - stop

        - define raw_name <context.args.get[2].to[last].space_separated>
        - inject fancy_rename_command.sub_paths.parse_name
        - flag <npc> fancy_name:->:<[new_name]>

      - case set:
        - if <context.args.size> == 1:
          - narrate "<&[error]>When using set, specify a line number and a new name!"
          - stop
        - else if <context.args.size> == 2:
          - if <context.args.last.is_integer>:
            - narrate "<&[error]>When using set, also specify the name!"
          - else:
            - narrate "<&[error]>When using set, specify a line number and a new name!"
          - stop

        - define index <context.args.get[2]>
        - if !<[index].is_integer> || <npc.hologram_lines.size> > <[index]>:
          - narrate "<&[error]>When using set, specify a valid line number! There are currently <&[warning]><npc.hologram_lines.size><&[error]>"
          - stop


        - define raw_name <context.args.get[3].to[last]>
        - inject fancy_rename_command.sub_paths.parse_name

        - flag <npc> fancy_name:!
        - flag <npc> fancy_name:|:<[fancy_name].set[<[new_name]>].at[<[index]>]>

      - case remove:
        - if !<npc.has_flag[fancy_name]>:
          - narrate "<&[error]>NPC doesn't have a fancy name set!"
          - stop

        - if <context.args.size> == 1:
          - narrate "<&[error]>When removing lines, specify a line number to remove!"
          - stop

        - else if <context.args.size> == 2:
          - if <context.args.last.is_integer>:
            - narrate "<&[error]>When using remove, also specify the name!"
          - else:
            - narrate "<&[error]>When using remove, specify a line number and a new name!"
          - stop

        - define index <context.args.get[2]>
        - if !<[index].is_integer> || <npc.hologram_lines.size> > <[index]>:
          - narrate "<&[error]>When using remove, specify a valid line number! There are currently <&[warning]><npc.hologram_lines.size><&[error]>"
          - stop

        - define fancy_name <npc.flag[fancy_name]>
        - flag <npc> fancy_name:!
        - flag <npc> fancy_name:<[fancy_name].remove[<[index]>]>

    # assign the NPC
    - assignment set script:fancy_npc

fancy_npc:
  type: assignment
  data:
    refresh_name:
    - if <npc.has_flag[fancy_name]>:
      - rename t:<npc.hologram_npcs> <npc.flag[fancy_name]> per_player
  actions:
    on assignment:
      - adjust <npc> hologram_line_height:0
      - adjust <npc> hologram_lines:<dark_gray><&lt><gray>Loading<dark_gray><&gt>
      - adjust <npc> name_visible:false
      - inject fancy_npc.subpaths.refresh_name

    on spawn:
      - inject fancy_npc.subpaths.refresh_name

    on enter proximity:
      - inject fancy_npc.subpaths.refresh_name


#main case to look out for is the base npc spawning and enters proximity will fire after that happens (give it a generous radius)

listen:
  type: world
  events:
    after player steers entity:
      - narrate <context.sideways>
    #after mythickeys key pressed:
    #  - narrate	<context.id>
    #after mythickeys key pressed id:minecraft:right:
    #  - adjust <player> velocity:<player.location.sub[<player.location.left[0.3]>]>
    #after mythickeys key pressed id:minecraft:left:
    #  - adjust <player> velocity:<player.location.sub[<player.location.right[0.3]>]>



birds_eye:
  type: task
  debug: false
  script:
    - spawn armor_stand[visible=false] <player.location.with_pitch[90]> save:ent
    #- fakeequip <player> hand:feather[display=<&a>;custom_model_data=3] duration:10s
    - adjust <player> spectate:<entry[ent].spawned_entity>
    - repeat 120:
      - adjust <entry[ent].spawned_entity> velocity:0,1,0
      - look <entry[ent].spawned_entity> <server.flag[test_loc]>
      - wait 1t
    - adjust <entry[ent].spawned_entity> gravity:false
    - wait 5s
    - adjust <player> spectate:<player>
    - remove <entry[ent].spawned_entity>
