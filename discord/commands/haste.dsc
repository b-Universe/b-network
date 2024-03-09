haste_command_create:
  type: task
  debug: false
  enabled: false
  script:
    - ~discordcommand id:c create name:haste "description:Serves the haste link for pasting scripts or code snippets" group:901618453356630046

haste_command_handler:
  type: world
  debug: false
  enabled: false
  events:
    on discord slash command name:haste group:901618453356630046:
      - discord id:c channel:<context.channel> start_typing
      - definemap embed_data:
          color: <color[0,254,255]>
          description: "[`(https://paste.denizenscript.com/New/Script)`](https://paste.denizenscript.com/New/Script)"

      - ~discordinteraction reply interaction:<context.interaction> <discord_embed.with_map[<[embed_data]>]>
