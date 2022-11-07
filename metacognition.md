# Permissions, flag-based permissions, and flags

### Player
| Permission name                                           | Command     | Description |
| :-------------------------------------------------------- | :---------: | :---------- |
| behr.essentials.top                                       | ascend      | Teleports a player to the highest block where they're standing 
| behr.essentials.gamemode.builder                          | buildermode | Toggles the builder gamemode
| behr.essentials.gamemode.builder_mode                     | -           | Permits builder permitted commands:<br>`ascend`, `clear_inventory`, `fly`, `fly_speed`, `run`, `run_speed`, `teleport_menu`, `time`, `weather`, `world`
| behr.essentials.chat.channel                              | -           | Determines the chat channel a player is currently in, can be any of:<br>`player_chat`, `system`, `admin`, or `<[player].flag[behr.essentials.chat.]>`
| behr.essentials.chat.last_channel                         | -           | Determines the last channel a player was in
| behr.essentials.permissions.admin                         | -           | Determines if a player has the administrative rights, or not

### Server
| Flag name                                       | Description |
| :---------------------------------------------- | :---------- |
| behr.essentials.weather.world.<[world]>.weather | Determines the weather manually set for <[world]> between `storm`, `thunder`, and `sunny`
| behr.essentials.weather.world.<[world]>.lock    | Determines if <[world]>'s weather is locked for the day

# Player and Server Settings flags

### Player
| Flag name                                                     | Default | Description |
| :------------------------------------------------------------ | :-----: | :---------- |
| behr.essentials.builder_mode.flight_disabled                  | false   | Determines whether a player has flight disabled in builder mode, or not
| behr.essentials.builder_mode.logged_flying                    | false   | Determines if a player in builder mode logged out while flying to restore after login
| behr.essentials.builder_mode.was_flying                       | false   | Determines if a player in builder mode was flying when changing between spectator and builder gamemodes
| behr.essentials.builder.settings.material_list_verbose        | false   | Determines whether a player in builder mode sees a verbose material list or a more compact list
| behr.essentials.builder.settings.builder_spectator            | false   | Determines if a player in builder mode is in spectator mode, or not
| behr.essentials.settings.help_row_count                       | 7       | Determines the number of commands output from `/help`
| behr.essentials.permissions.read_chat_channel.<[channel]>     | -       | Determines if a player is allowed to read this chat channel, or not
| behr.essentials.chat.settings.show_delete_controls            | true    | Determines if a player is opted into seeing chat message delete controls, or not
| behr.essentials.chat.settings.show_dismiss_controls           | true    | Determines if a player is opted into seeing message dismiss controls, or not
| behr.essentials.chat.settings.hide_channel_buttons            | false   | Determines if a player has the channel buttons hidden from chat, or not
| behr.essentials.chat.settings.channel.<[channel]>.hide_button | false   | Determines if a player has the <[channel]> channel button hidden, or not


### Server
yaml: behr.essentials.chat.history | Map of data:
```yml
chat:
  channel: The channel the message belongs to
  message: <[data.channel]>/The raw message being sent
  delete: The delete button available for players to delete for chat messages
  time: The TimeTag this message was sent
  player_uuid: The player's UUID who sent the message for supporting the Player Interaction GUI 
```

# Commands

## Player defaults
| Command            | Usage      | Description |
| :----------------- | :--------- | :---------- |
| /chat_channel       | 
| /chat_settings      | 
| /colors             | 
| /emoji_board        | 
| /friend             | 
| /help               | 
| /me                 | 
| /ping               | 
| /rules              | 
| /suicide            | 

## Sponsors
| Command            | Usage      | Description |
| :----------------- | :--------- | :---------- |
| /hat                | 
| /head               |
| /skin               |

## Builder
| Command            | Usage      | Description |
| :----------------- | :--------- | :---------- |
| /ascend             |
| /buildermode        |
| /clear_inventory    |
| /fly                |
| /fly_speed          |
| /run                |
| /run_speed          |
| /teleport_menu      |
| /time               |
| /weather            |
| /world              |

## Moderator
| Command            | Usage      | Description |
| :----------------- | :--------- | :---------- |
| /clear_ground       |
| /enchant            |
| /food               |
| /heal               |
| /hunger             |
| /lore               |
| /max_health         |
| /max_oxygen         |
| /oxygen             |

## Admin
| Command            | Usage      | Description |
| :----------------- | :--------- | :---------- |
| /clear_console      | 
| /gamemode           | 
| /rename_item        | 
| /restore_inventory  | 
