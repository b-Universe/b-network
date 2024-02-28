
hi_dad:
  type: world
  debug: false
  enabled: false
  events:
    after discord message received message:i*:
      - define message.message <context.new_message>
      - define message.text <[message.message].text>
      - if <[message.text].starts_with[im ]> || <[message.text].starts_with[i<&sq>m ]>:
        - define new_name <[message.text].after[ ]>
        # stop if they type "im " for example / check if <empty>
        - stop if:!<[new_name].is_truthy>
        - define author <[message.message].author>
        - define old_name <[author].nickname[<context.group>].if_null[<[author].name>]>
        - ~discord id:b rename <[new_name]> user:<[author]> group:<context.group>
        - ~discordmessage id:b channel:<context.channel> "If i had perms, you'd be renamed to <[new_name]>!"
        - wait 5s
        - ~discord id:b rename <[old_name]> user:<[author]> group:<context.group>
