generate_font_tool:
  type: task
  debug: false
  data:
    -     <&lc>
    -       <&dq>type<&dq><&co> <&dq>bitmap<&dq>,
    -       <&dq>file<&dq><&co> <&dq>gui/custom/bgui/background/27/<[value].add[1]>.png<&dq>,
    -       <&dq>ascent<&dq><&co> 14,
    -       <&dq>height<&dq><&co> 256,
    -       <&dq>chars<&dq><&co> <&lb><&dq>\u<[hex]><&dq><&rb>
    -     <&rc>,
  script:
    - define list <list>
    #- repeat 17 from:0:
    - repeat 24 from:0:
      - define hex <[value].add[57444].number_to_hex>
      - define list <[list].include_single[<script.parsed_key[data].separated_by[<n>]>]>
    - narrate <element[copy].on_click[<[list].separated_by[<n>]>].type[copy_to_clipboard]>
