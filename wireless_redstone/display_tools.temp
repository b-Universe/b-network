wireless_redstone_activate_transmitter_task:
  type: task
  debug: true
  definitions: location
  script:
    # base definitions
    - define frequency <[location].flag[behr.essentials.wireless_redstone.frequency]>
    - define receivers <[location].proc[find_wireless_blocks].context[receiver|<[frequency]>]>

    - if <[location].switched>:
      # activate both transmitter and receivers in range
      - adjust <[receivers].parse[flag[behr.essentials.wireless_redstone.entity]]> item:wireless_receiver_block[custom_model_data=1003]
      - adjust <[location].flag[behr.essentials.wireless_redstone.entity]> item:wireless_transmitter_block[custom_model_data=1001]

      - playeffect effect:red_dust at:<[location].center>  offset:0.5 special_data:1|255,0,0 quantity:10
      - playeffect effect:electric_spark at:<[location].center>  offset:0.5 quantity:10
      - playsound at:<[location]> sound:block_dispenser_dispense pitch:<util.random.int[7].to[10].div[10]> volume:2

      - foreach <[receivers].filter[advanced_matches[dispenser]]> as:receiver:
        - flag <[receiver]> behr.essentials.wireless_redstone.ratelimited
        - adjust <[receiver].flag[behr.essentials.wireless_redstone.entity]> item:wireless_receiver_block[custom_model_data=1003]
        - modifyblock <[receiver]> redstone_block
        - playeffect effect:red_dust at:<[receiver].center> offset:0.5 special_data:1|255,0,0 quantity:10
        - playeffect effect:electric_spark at:<[receiver].center> offset:0.5 quantity:10
        - playsound at:<[receiver]> sound:block_dispenser_dispense pitch:<util.random.int[7].to[10].div[10]> volume:2
        - flag <[receiver]> behr.essentials.wireless_redstone.ratelimited:!

    - else:
      - adjust <[location].flag[behr.essentials.wireless_redstone.entity]> item:wireless_transmitter_block[custom_model_data=1002]
      - foreach <[receivers]> as:receiver:
        - flag <[receiver]> behr.essentials.wireless_redstone.ratelimited
        - adjust <[receiver].flag[behr.essentials.wireless_redstone.entity]> item:wireless_receiver_block[custom_model_data=1004]
        - modifyblock <[receiver]> dispenser
        - flag <[receiver]> behr.essentials.wireless_redstone.ratelimited:!

wireless_redstone_deactivate_transmitter_task:
  type: task
  debug: false
  definitions: location
  script:
    # base definitions
    - define frequency <[location].flag[behr.essentials.wireless_redstone.frequency]>
    - define receivers <[location].proc[find_wireless_blocks].context[receiver|<[frequency]>]>

    - adjust <[location].flag[behr.essentials.wireless_redstone.entity]> item:wireless_transmitter_block[custom_model_data=1002]

    - playeffect effect:electric_spark at:<[location].center> offset:0.5 quantity:10

    - foreach <[receivers].filter[advanced_matches[redstone_block]]> as:receiver:
      - foreach next if:!<[location].proc[find_wireless_blocks].context[transmitter|<[frequency]>|true].is_empty>
      - flag <[receiver]> behr.essentials.wireless_redstone.ratelimited
      - adjust <[receiver].flag[behr.essentials.wireless_redstone.entity]> item:wireless_receiver_block[custom_model_data=1004]
      - modifyblock <[receiver]> dispenser
      - playeffect effect:electric_spark at:<[receiver].center> offset:0.5 quantity:10
      - playsound at:<[receiver]> sound:block_dispenser_dispense pitch:<util.random.int[7].to[10].div[10]> volume:2
      - flag <[receiver]> behr.essentials.wireless_redstone.ratelimited:!

wireless_redstone_refresh_receivers_task:
  type: task
  debug: false
  definitions: location|frequency
  script:
    # play effects
    - playeffect effect:electric_spark at:<[location].center> offset:0.5 quantity:10

    # check old frequency receivers
    - define receivers <[location].proc[find_wireless_blocks].context[receiver|<[frequency]>]>
    - foreach <[receivers]> as:receiver:
      - run wireless_redstone_refresh_receiver_task def:<[receiver]>|<[frequency]>

wireless_redstone_refresh_receiver_task:
  type: task
  debug: false
  definitions: location|frequency
  script:
    # base definitions
    - define transmitters <[location].proc[find_wireless_blocks].context[transmitter|<[frequency]>|true]>

    - if <[location]> matches redstone_block && <[transmitters].is_empty>:
      - flag <[location]> behr.essentials.wireless_redstone.ratelimited
      - adjust <[location].flag[behr.essentials.wireless_redstone.entity]> item:wireless_receiver_block[custom_model_data=1004]
      - modifyblock <[location]> dispenser
      - flag <[location]> behr.essentials.wireless_redstone.ratelimited:!

    - else if <[location]> matches dispenser && !<[transmitters].is_empty>:
      - flag <[location]> behr.essentials.wireless_redstone.ratelimited
      - adjust <[location].flag[behr.essentials.wireless_redstone.entity]> item:wireless_receiver_block[custom_model_data=1003]
      - modifyblock <[location]> redstone_block
      - playeffect effect:red_dust at:<[location].center> offset:0.5 special_data:1|255,0,0 quantity:10
      - playeffect effect:electric_spark at:<[location].center> offset:0.5 quantity:10
      - playsound at:<[location]> sound:block_dispenser_dispense pitch:<util.random.int[7].to[10].div[10]> volume:2
      - flag <[location]> behr.essentials.wireless_redstone.ratelimited:!

find_wireless_blocks:
  type: procedure
  debug: false
  definitions: location|type|frequency|active|range
  script:
    - define range 16 if:!<[range].exists>
    - define wireless_blocks <[location].find_blocks_flagged[behr.essentials.wireless_redstone].within[<[range]>]>
    - define wireless_blocks <[wireless_blocks].filter[flag[behr.essentials.wireless_redstone.material].equals[<[type]>]]>
    - define wireless_blocks <[wireless_blocks].filter[flag[behr.essentials.wireless_redstone.frequency].equals[<[frequency]>]]>
    - if <[active].exists>:
      - if <[active]>:
        - define wireless_blocks <[wireless_blocks].filter[switched]>
      - else:
        - define wireless_blocks <[wireless_blocks].filter[switched]>
    - determine <[wireless_blocks]>
