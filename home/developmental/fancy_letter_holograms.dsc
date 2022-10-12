spawn_templates:
  type: task
  definitions: text
  debug: false
  clear:
    - remove letter_entity
  script:
    - remove letter_entity
    - definemap letters:
        1:
          letter: a
          length: <element[a].text_width>
        2:
          letter: b
          length: <element[b].text_width>
        3:
          letter: c
          length: <element[c].text_width>
        4:
          letter: d
          length: <element[d].text_width>
        5:
          letter: e
          length: <element[e].text_width>
        6:
          letter: f
          length: <element[f].text_width>
        7:
          letter: g
          length: <element[g].text_width>
        8:
          letter: h
          length: <element[h].text_width>
        9:
          letter: i
          length: <element[i].text_width>
        10:
          letter: j
          length: <element[j].text_width>
        11:
          letter: k
          length: <element[k].text_width>
        12:
          letter: l
          length: <element[l].text_width>
        13:
          letter: m
          length: <element[m].text_width>
        14:
          letter: n
          length: <element[n].text_width>
        15:
          letter: o
          length: <element[o].text_width>
        16:
          letter: p
          length: <element[p].text_width>
        17:
          letter: q
          length: <element[q].text_width>
        18:
          letter: r
          length: <element[r].text_width>
        19:
          letter: s
          length: <element[s].text_width>
        20:
          letter: t
          length: <element[t].text_width>
        21:
          letter: u
          length: <element[u].text_width>
        22:
          letter: v
          length: <element[v].text_width>
        23:
          letter: w
          length: <element[w].text_width>
        24:
          letter: x
          length: <element[x].text_width>
        25:
          letter: y
          length: <element[y].text_width>
        26:
          letter: z
          length: <element[z].text_width>

    - repeat 26 as:i:
      - spawn "letter_entity[custom_name=<&e><[letters].get[<[i]>].get[letter]><&6><&co> <&a><&a><[letters].get[<[i]>].get[length]>]" save:letter_entity <location[862,48.5,754,world].add[0,0,<[i]>].with_yaw[90]>
      - equip <entry[letter_entity].spawned_entity> head:letter_template_item[custom_model_data=<[i].add[1300100]>]

  #/ex run spawn_templates.test_write "def:i love lasagna so much"
  test_write:
    - remove letter_entity
    - define center_length <[text].text_width.sub[6].div[6].div[2]>
    - define location <player.cursor_on.backward_flat[0.5].center.with_yaw[<player.cursor_on.face[<player.location>].yaw.round_to_precision[45]>].right[<[center_length]>]>

    - definemap letters:
        a:
          model_id: 1300101
          length: <element[a].text_width>
        b:
          model_id: 1300102
          length: <element[b].text_width>
        c:
          model_id: 1300103
          length: <element[c].text_width>
        d:
          model_id: 1300104
          length: <element[d].text_width>
        e:
          model_id: 1300105
          length: <element[e].text_width>
        f:
          model_id: 1300106
          length: <element[f].text_width>
        g:
          model_id: 1300107
          length: <element[g].text_width>
        h:
          model_id: 1300108
          length: <element[h].text_width>
        i:
          model_id: 1300109
          length: <element[i].text_width>
        j:
          model_id: 1300110
          length: <element[j].text_width>
        k:
          model_id: 1300111
          length: <element[k].text_width>
        l:
          model_id: 1300112
          length: <element[l].text_width>
        m:
          model_id: 1300113
          length: <element[m].text_width>
        n:
          model_id: 1300114
          length: <element[n].text_width>
        o:
          model_id: 1300115
          length: <element[o].text_width>
        p:
          model_id: 1300116
          length: <element[p].text_width>
        q:
          model_id: 1300117
          length: <element[q].text_width>
        r:
          model_id: 1300118
          length: <element[r].text_width>
        s:
          model_id: 1300119
          length: <element[s].text_width>
        t:
          model_id: 1300120
          length: <element[t].text_width>
        u:
          model_id: 1300121
          length: <element[u].text_width>
        v:
          model_id: 1300122
          length: <element[v].text_width>
        w:
          model_id: 1300123
          length: <element[w].text_width>
        x:
          model_id: 1300124
          length: <element[x].text_width>
        y:
          model_id: 1300125
          length: <element[y].text_width>
        z:
          model_id: 1300126
          length: <element[z].text_width>


    - foreach <[text].to_list> as:character:
      - define length <[letters].get[<[character]>].get[length].div[6].if_null[1]>
      - if <[letters].contains[<[character]>]>:
        - define model_id <[letters].get[<[character]>].get[model_id]>
        - spawn "letter_entity[custom_name=<&e><[character]><&6><&co> <&a><&a><[letters].get[<[character]>].get[length]>]" save:letter_entity <[location]>
        - equip <entry[letter_entity].spawned_entity> head:letter_template_item[custom_model_data=<[model_id]>]
      - define location <[location].left[<[length]>]>

letter_entity:
  type: entity
  entity_type: armor_stand
  mechanisms:
    marker: true
    visible: false
    custom_name_visible: true

letter_template_item:
  type: item
  material: leather_horse_armor
  mechanisms:
    color: lime
