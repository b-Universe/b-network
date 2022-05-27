msg_hover_ins:
    type: procedure
    debug: false
    definitions: Hover|Text|Insert
    script:
        - determine <&hover[<[Hover]>]><&insertion[<[Insert]>]><[Text]><&end_insertion><&end_hover>

old_Colors_Command:
    type: command
    name: colors
    debug: false
    description: Lists the colors in a click-menu
    usage: /colors
    permission: behr.essentials.colors
    script:
    # % ██ [ Verify args ] ██
      - if !<context.args.is_empty>:
        - narrate "<&c>Invalid usage - just /colors"
        - stop

    # % ██ [ Create color lists ] ██
      - define colors "<list[&0|&1|&2|&3|&4|&5|&6|&7|&8|&9|&a|&b|&c|&d|&e|&f].parse_tag[<[parse_value].parse_color><bold><[parse_value].on_hover[<&color[#F3FFAD]>Shift-Click to Insert<&color[#26FFC9]><&co><n><[parse_value].parse_color>This Color!].with_insertion[<[parse_value]>]>]>"

      - define formats <list>
    # % ██ [ Create format lists ] ██
      - foreach <script.parsed_key[data.formats]> key:code as:name:
        - define formats "<[formats].include_single[<[name].on_hover[<&color[#F3FFAD]>Shift-Click to Insert<&color[#26FFC9]><&co><n><&color[#C1F2F7]><element[&<[code]>].parse_color>This format!].with_insertion[&<[code]>]>]>"
      - define formats "<[formats].include_single[<element[Comic Sans].font[utility:comic_sans].on_hover[<&color[#F3FFAD]>Shift-Click to Insert<&color[#26FFC9]><&co><n><&color[#C1F2F7]><element[<&font[utility:comic_sans]>].parse_color>This special format lol].with_insertion[&k]>]>"

    # % ██ [ Narrate ] ██
      - narrate "<element[●<strikethrough><&sp.repeat[13]><reset><bold>( Shift-Click To Insert )<reset><strikethrough><&sp.repeat[13]><reset>●].hex_rainbow>"
      - narrate <[colors].sub_lists[8].parse[separated_by[<&sp.repeat[4]>]].separated_by[<n>]>
      - narrate "<&sp.repeat[11]><element[●<strikethrough><&sp.repeat[4]><reset><bold>( &z <strikethrough><&sp>●<&sp><reset> Rainbow Text! <bold>)<strikethrough><&sp.repeat[4]><reset>●].hex_rainbow.on_hover[<&color[#F3FFAD]>Shift-Click to Insert<&color[#26FFC9]><&co><n><element[This special format!].hex_rainbow>].with_insertion[&z]>"
      - narrate <&sp.repeat[11]><[formats].sub_lists[3].parse[separated_by[<&sp.repeat[3]>]].separated_by[<n><&sp.repeat[11]>]>
      - narrate "<&sp.repeat[11]><element[<&8>(<&7>Note<&8>)<&7>: Color before formats!].on_hover[<&color[#C1F2F7]>Except for <element[the special rainbow <bold><&lb>&k<&rb>].hex_rainbow><n><&color[#C1F2F7]>Rainbow only supports Comic Sans<n>Other formats aren't supported for comic sans]>"
      - narrate <element[●<strikethrough><&sp.repeat[65]><reset>●].hex_rainbow>
    data:
      formats:
        n: <&n>Underline
        m: <&m>Strikethrough
        o: <&o>Italic
        r: <&r>Reset format
        l: <&l>Bold
