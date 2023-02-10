discord_view_edit_command_create:
  type: task
  debug: false
  script:
    - ~discordcommand id:c create group:901618453356630046 name:View_Edit type:message "description:Shows you the edit history of this message, if any."

discord_view_edit_command_handler:
  type: world
  debug: false
  events:
    on discord message modified:
      - define message <context.new_message>
      - if <context.old_message_valid>:
        - flag <[message]> behr.discord.message.original_message:<context.old_message.text>
      - flag <[message]> behr.discord.message.edited_messages.<util.time_now.epoch_millis>:<[message].text>

    on discord message command name:view_edit:
      - define message <context.interaction.target_message>
      - define message_url https://discord.com/channels/<context.group.id>/<context.channel.id>/<[message].id>
      - announce to_console "<&e><context.interaction.target_message.author.name> <&a>checked for an edit on <&b><[message_url]>"
      - if !<[message].was_edited>:
        - definemap embed_data:
            footer: This message has never been modfied.
            color: <color[100,0,0]>
            footer_icon: https://cdn.discordapp.com/emojis/901634983867842610.gif

        - ~discordinteraction reply interaction:<context.interaction> ephemeral <discord_embed.with_map[<[embed_data]>]>
        - stop

      - definemap embed_data:
          color: <color[0,254,255]>
          author_name: <[message].author.name>
          author_url: <[message_url]>
          author_icon_url: <[message].author.avatar_url>

      - define embed_data.description <list>
      - if <[message].has_flag[behr.discord.message.original_message]>:
        - define embed_data.description <[embed_data.description].include_single[📒 **Original Message**]>
        - define original_message <[message].flag[behr.discord.message.original_message]>
        - define original_message <[original_message].replace_text[<n>].with[<n><&gt> ]>
        - define embed_data.description <[embed_data.description].include_single[<&gt> <[original_message]><n>]>
      - else:
        - define embed_data.description <[embed_data.description].include_single[📕 **Note**]>
        - define embed_data.description <[embed_data.description].include_single[<&gt> Original message failed to cache.<n>]>

      - if <[message].has_flag[behr.discord.message.edited_messages]>:
        - foreach <[message].flag[behr.discord.message.edited_messages]> as:old_message:
          - define embed_data.description <[embed_data.description].include_single[<&co>warning<&co> **Edit `<[loop_index]>`** (New message)]>
          - define old_message <[old_message].replace_text[<n>].with[<n><&gt> ]>

          - if <[embed_data.description].include_single[<&gt> <[old_message]><n>].separated_by[<n>].length> > 4000:
            - define embed_data.description <[embed_data.description].remove[1|2]>
            - define embed_data.footer "Note<&co> This message was truncated due to being over 4000 characters."
            - define embed_data.color <color[100,0,0]>
            - define embed_data.footer_icon https://cdn.discordapp.com/emojis/901634983867842610.gif

          - define embed_data.description <[embed_data.description].include_single[<&gt> <[old_message]><n>]>

      - define embed_data.description <[embed_data.description].separated_by[<n>]>

      - ~discordinteraction reply interaction:<context.interaction> ephemeral <discord_embed.with_map[<[embed_data]>]>

format_view_edit_message:
  type: procedure
  definitions: message
  debug: false
  enabled: false
  script:
    # todo: can't really use this until i implement carrying over the `message` and ```code``` blocks to each line
    - define new_lines "<list_single[<&gt> ]>"
    - foreach <[message].split[<n>]> as:line:
      - if <[line].starts_with[<&gt>]>:
        - define new_lines "<[new_lines].include_single[<&gt> <[line].replace_text[<&gt>].with[<&gt><&co>b_dq<&co>1071462779082526772<&lt>]>]>"
      - else:
        - define new_lines "<[new_lines].include_single[<&gt> <[line]>]>"
    - determine <[new_lines].separated_by[<n>]>
