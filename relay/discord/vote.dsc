discord_vote_data:
  type: data
  discord:
    bot_id: Champagne
    guild_id: 901618453356630046
  voting_sites:
    SuperVoteSite: https://www.youtube.com/watch?v=dQw4w9WgXcQ
    BestPluginSite: https://denizenscript.com/

# to refresh this after updating, execute `/ex run create_vote_command` in-game or from the console
create_votesites_command:
    type: task
    debug: false
    script:
      - ~discordcommand id:<script[discord_vote_data].data_key[discord.bot_id]> create name:vote "description:Gives you the voting site links" group:<script[discord_vote_data].data_key[discord.guild_id]>

      - foreach <script[discord_vote_data].data_key[voting_sites]> key:name as:url:
        - define buttons:->:<discord_button.with[id].as[<[url]>].with[label].as[<[name]>].with[style].as[link]>

      - flag server discord.vote_buttons:<list_single[<[buttons]>]>

votesites_command_listener:
  type: world
  debug: false
  events:
    on discord slash command name:votesites:
      - ~discordinteraction defer interaction:<context.interaction>
      - ~discordinteraction reply interaction:<context.interaction> rows:<server.flag[discord.vote_buttons]> "Thanks for taking the time to vote for our server! Here are the voting links you can vote for us at<&co>"
