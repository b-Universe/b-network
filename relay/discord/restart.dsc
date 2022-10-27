create_restart_discordcommand:
  type: task
  debug: true
  script:
    - definemap options:
        2:
          name: server
          type: string
          description: Specify the server to restart 
          required: true
        3:
          name: list
          type: string
          description: Lists the online servers that can queue a restart
          required: false
        4:
          name: delay
          type: string
          description: Sets a delay before the restart initiates
        5:
          name: confirmation
          type: boolean
          description: Returns a confirmation that the server restart
          required: false
       # 6:
       #   name: log
       #   type: boolean
       #   description: Returns a startup log after restarting
       #   required: false
        7:
          name: version
          type: boolean
          description: Returns the before-and-after version comparison after restart
          required: false
        8:
          name: plugin
          type: boolean
          description: Returns the before-and-after plugin comparison after restart
          required: false

    - ~discordcommand id:b create name:webget "description:Restarts a server" group:901618453356630046 options:<[options]>

#restart_discordcommand_handler:
#  type: world
#  debug: true
#  events:
#    on discord slash command name:restart:
