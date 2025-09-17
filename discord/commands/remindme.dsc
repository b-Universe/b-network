remindme_command_create:
  type: task
  debug: false
  script:
    - definemap options:
        1:
          type: string
          name: duration
          description: Sets the time to wait for the reminder
          required: true
        2:
          type: string
          name: reminder
          description: The thing to remind yourself of
          required: true
        3:
          type: user
          name: user
          description: Selects the user you want to remind
          required: false

    - ~discordcommand id:c create name:remindme "description:Reminds you of a task" options:<[options]> group:901618453356630046
    #- ~discordcommand id:c create name:remindme "description:Reminds you or another user of a task" options:<[options]> group:901618453356630046

remindme_command_handler:
  type: world
  debug: false
  events:
    on discord slash command name:remindme group:901618453356630046:
      # check if the duration is valid
      - define duration_input <context.options.get[duration]>
      - inject verify_duration_discord

      - definemap reminder_data:
          channel: <context.channel>
          reminder: <context.options.get[reminder]>
          user: <context.interaction.target_user.if_null[<context.interaction.user>]>

      - define time <util.time_now.add[<[duration]>]>
      - definemap embed_data:
          title: Reminder Set!
          description: I'll remind you in <[time].format_discord[R]><&co><n><[reminder_data.reminder]><n>Reminder set for<&co> <[time].format_discord[F]>
          color: 0,254,254
      - define embed <discord_embed.with_map[<[embed_data]>]>

      - runlater reminder_task defmap:<[reminder_data]> delay:<[duration]>

      - discordinteraction reply interaction:<context.interaction> <[embed]>

reminder_task:
  type: task
  definitions: channel|reminder|user
  script:
    - definemap embed_data:
        title: Reminder!
        description: <[reminder]>
        color: 0,254,254
    - define embed <discord_embed.with_map[<[embed_data]>]>

    - discordmessage id:c channel:<[channel]> <[user].mention> embed:<[embed]>
