bedit_sel_command:
  type: command
  debug: false
  enabled: true
  name: /sel
  usage: //sel clear
  description: clears a selection
  tab completions:
    1: clear
  script:
    - if !<context.args.size> > 1 || !<context.args.first.if_null[null]> != clear:
      - inject command_syntax_error

    - foreach left|right as:click_type:
      - if <player.has_flag[behr.essentials.bedit.<[click_type]>.selection]>:
        - flag <player> behr.essentials.bedit.<[click_type]>.selection:!
        - remove <player.flag[behr.essentials.bedit.<[click_type]>.selection_entity]> if:<player.flag[behr.essentials.bedit.<[click_type]>.selection_entity].is_truthy>
      - flag <player> behr.essentials.bedit.selection.cuboid:!
      - narrate "<&e><[click_type].to_titlecase> <&a>selection cleared"
