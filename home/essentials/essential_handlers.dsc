essentials:
  type: world
  debug: false
  events:
    on player kicked:
      - if <context.reason> == "Illegal characters in chat":
        - determine cancelled

    on player changes sign:
      # todo: add &z and comic sans
      - determine <context.new.parse[parse_color]>

    on player right clicks Villager with:lead:
      - if !<context.entity.has_flag[behr.essentials.interaction.lead]>:
        - flag <context.entity> behr.essentials.interaction.lead duration:1t
        - if <context.entity.is_leashed>:
          - if <context.entity.leash_holder> == <player>:
            - stop

        - wait 1t
        - adjust <context.entity> leash_holder:<player>
        - take iteminhand
      - determine cancelled
