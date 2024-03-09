repository_command_create:
  type: task
  debug: false
  enabled: false
  script:
    - ~discordcommand id:c create name:repository "description:Serves the repository links for B" group:901618453356630046

repository_command_handler:
  type: world
  debug: false
  enabled: false
  data:
    repository_links:
      b-network:
        link: https<&co>//github.com/b-Universe/b-network
        description: Server scripts for commands, handlers, and API management
      b-resource:
        link: https<&co>//github.com/b-Universe/b-resource
        description: Resource pack used for B for server textures, shaders, and font data
      b-datapack:
        link: https<&co>//github.com/b-Universe/b-datapack
        description: Customized world generation and biome configuration, dimension settings, and item registries
  events:
    on discord slash command name:repository group:901618453356630046:
      - discord id:c channel:<context.channel> start_typing

      - define fields <list>
      - foreach <script.parsed_key[data.repository_links]> key:repository as:data:
        - definemap field:
            title: 📜 <[repository]>
            value: <&lb>`<&lb>🔗Link<&rb>`<&rb>(<[data.link]>)<n><[data.description]>
            inline: true
        - define fields <[fields].include_single[<[field]>]>

      - definemap embed_data:
          color: <color[0,254,255]>
          fields: <[fields]>

      - ~discordinteraction reply interaction:<context.interaction> <discord_embed.with_map[<[embed_data]>]>
