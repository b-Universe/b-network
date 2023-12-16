
crafting_table_command:
  type: command
  name: crafting_table
  debug: false
  usage: /crafting_table
  description: Opens a crafting table
  script:
    - define fake_location <player.location.above[10]>
    - showfake <[fake_location]> CRAFTING_TABLE d:1t
    - adjust <player> show_workbench:<[fake_location]>
    - showfake <[fake_location]> cancel
