create_changelog:
  type: task
  debug: false
  script:
    - definemap options:
        1:
          type: string
          name: title
          description: (Optional) Provides a summary title for the changelog
          required: false

    - ~discordcommand id:c create name:changelog "description:Sends a changelog message" group:901618453356630046 options:<[options]>

changelog_handle:
  type: world
  debug: false
  events:
    on discord slash command name:changelog for:c:
      - definemap rows:
          1:
            1: <discord_text_input.with[id].as[content].with[label].as[Changelog content].with[style].as[Paragraph]>
      - flag <context.interaction.user> discord.interaction.changelog.last_title:<context.options.get[title]> if:<context.options.contains[title]> expire:1h
      - ~discordmodal interaction:<context.interaction> name:changelog "title:Add change log" rows:<[rows]>

    on discord modal submitted name:changelog:
      - discordinteraction defer interaction:<context.interaction>
      - define user <context.interaction.user>
      - definemap embed_data:
          color: 0,255,255
          description: <context.values.get[content]>
      - if <[user].has_flag[discord.interaction.changelog.last_title]>:
        - define embed_data.title <[user].flag[discord.interaction.changelog.last_title]>
        - flag <[user]> discord.interaction.changelog.last_title:!
      - define embed <discord_embed.with_map[<[embed_data]>]>
      - discordinteraction delete interaction:<context.interaction>
      - ~discordmessage id:c channel:901618453746712662 <[embed]>


create_basic_changelog:
  type: task
  debug: true
  script:
    - ~discordcommand id:c create name:basic_changelog "description:Sends a changelog message" group:901618453356630046

basic_changelog_handle:
  type: world
  debug: true
  events:
    on discord slash command name:basic_changelog for:c:
      - definemap rows:
          1:
            1: <discord_text_input.with[id].as[content].with[label].as[Changelog content].with[style].as[Paragraph]>
      - ~discordmodal interaction:<context.interaction> name:changelog "title:Add change log" rows:<[rows]>

    on discord modal submitted name:basic_changelog for:c:
      - discordinteraction defer interaction:<context.interaction>
      - definemap embed_data:
          color: 0,255,255
          description: <context.values.get[content]>
      - discordinteraction reply interaction:<context.interaction>
      - ~discordmessage id:c channel:901618453746712662 <discord_embed.with_map[<[embed_data]>]>
