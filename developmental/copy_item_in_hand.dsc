copy_item_in_hand:
  type: command
  name: copy_item_in_hand
  debug: false
  description: Copies the item in yours, or another player's hand
  usage: /copy_item_in_hand (player)
  tab completions:
    1: <server.online_players.exclude[<player>].parse[name].include[skull_skin]>
  script:
    - choose <context.args.size>:
      - case 0:
        - definemap message:
            text: <&a>Click to copy to clipboard<&co> <&e><[item].display.if_null[<[item].material.name>]>
            hover: <&a>Click to copy to clipboard<&co><n><&e><[item]>
            click: <[item]>
        - inject copy_item_in_hand.sub_script

      - case 1:
        - choose <context.args.first>:
          - case skull_skin:
            - define item <player.item_in_hand>
            - if !<player.item_in_hand.skull_skin.exists>:
              - narrate "<&c>Item does not have a skull_skin property"
              - stop

            - definemap message:
                text: <&a>Click to copy to clipboard<&co> <&e><[item].display.if_null[<[item].material.name>]><&a><&sq>s skull_skin
                hover: <&a>Click to copy to clipboard<&co><n><&e><[item]>
                click: <[item].skull_skin>

          - default:
            - define player_name <context.args.first>
            - inject command_player_verification
            - definemap message:
                text: <&a>Click to copy to clipboard<&co> <&e><[item].display.if_null[<[item].material.name>]>
                hover: <&a>Click to copy to clipboard<&co><n><&e><[item]>
                click: <[item]>

        - inject copy_item_in_hand.sub_script

      - default:
        - inject command_syntax_error

  sub_script:
    - if <[player].item_in_hand> matches air:
      - narrate "<&c>You must hold an item in your hand to copy"
      - stop

    - narrate <[message.text].on_hover[<[message.hover]>].on_click[<[message.click]>].type[copy_to_clipboard]>
