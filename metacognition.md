# Permissions, flag-based permissions, and flags

## Player
| Permission name                                                 | Command / Script     | Description |
| :-------------------------------------------------------------- | :------------------: | :---------- |
| behr.essentials.permissions.admin                               | `/builder_mode`      | Determines if a player has the administrative rights, or not
| behr.essentials.top                                             | `/ascend`            | Teleports a player to the highest block where they're standing 
| behr.essentials.gamemode.builder                                | `/buildermode`       | Toggles the builder gamemode
| behr.essentials.gamemode.builder_mode                           | builder_mode         | Permits builder permitted commands:<br>`ascend`, `clear_inventory`, `fly`, `fly_speed`, `run`, `run_speed`, `teleport_menu`, `time`, `weather`, `world`
| behr.essentials.chat.channel                                    | chat                 | Determines the chat channel a player is currently in, can be any of:<br>`player_chat`, `system`, `admin`, or `<[player].flag[behr.essentials.chat.<[channel]>]>` for any custom made chat channels
| behr.essentials.chat.last_channel                               | chat                 | Determines the last channel a player was in
| behr.essentials.clear_console                                   | `/clear_console`     | Clears the console for a blank screen
| behr.essentials.chat_settings                                   | `/chat_settings`     | Changes various settings used in chat;<br> All players can configure: `show_dismiss_controls`, `toggle_channel_button`, <br>Sponsors can optionally configure: `hide_voters`<br>Admins can configure: `show_deleted_messages`, `show_delete_controls`, and `reset_chat`
| behr.essentials.permissions.read_chat_channel.<[channel]>       | chat                 | Determines whether a player can read the chat within <[channel]>
| behr.essentials.permissions.write_chat_channel.<[channel]>      | chat                 | Determines whether a player can write in the chat within <[channel]>
| behr.essentials.colors                                          | `/colors`            | Lists the colors in a click-menu for copying and pasting
| behr.essentials.enchant                                         | `/enchant`           | Enchants an item in your hand
| behr.essentials.fly                                             | `/fly`               | Toggles flight to yourself or another player
| behr.essentials.fly_speed                                       | `/fly_speed`         | Changes yours or another player's fly speed
| behr.essentials.friend                                          | `/friend`            | Adds or removes a player to or from your friends list
| behr.essentials.friends                                         | friend               | Returns a list of players a player added as a friend
| behr.essentials.friends.<[player]>                              | friend               | The <[player]> that the player added as a friend
| behr.essentials.friends.<[player]>.<[time]>                     | friend               | Returns the time a player added <[player]> as a friend
| behr.essentials.hat                                             | `/hat`               | Gives yours or another player's head
| behr.essentials.head                                            | `/head`              | Gives yours or another player's head
| behr.essentials.heal                                            | `/heal`              | Heals yourself or another player
| behr.essentials.hunger                                          | `/hunger`            | Hungers or satiates another player's or your own hunger
| behr.essentials.lore                                            | `/lore`              | Applies basic lore to the item in hand
| behr.essentials.max_health                                      | `/max_health`        | Adjusts yours or another player's max health from 1 to 100
| behr.essentials.max_oxygen                                      | `/max_oxygen`        | Changes yours or another player's maximum oxygen capacity
| behr.essentials.me                                              | `/me`                | me irl but outloud
| behr.essentials.oxygen                                          | `/oxygen`            | Replinishes or deflates yours or another player's oxygen
| behr.essentials.ping                                            | `/ping`              | Shows yours or another player's ping
| behr.essentials.rename_item                                     | `/rename_item`       | Applies a custom display name to the item in hand
| behr.essentials.restore_inventory                               | `/restore_inventory` | Restores a previous inventory for a player after death
| behr.essentials.cached_inventories                              | restore_inventory    | Map of a player's cached inventories indexes, mostly from death
| behr.essentials.cached_inventories.<[index]>                    | restore_inventory    | Map of a player's cached inventories, mostly from death
| behr.essentials.cached_inventories.<[index]>.cause              | restore_inventory    | The cause of the player's cached inventory, like a death or a rollback
| behr.essentials.cached_inventories.<[index]>.contents           | restore_inventory    | Map of a player's equipment and inventory contents
| behr.essentials.cached_inventories.<[index]>.contents.equipment | restore_inventory    | Map of the player's equipment
| behr.essentials.cached_inventories.<[index]>.contents.inventory | restore_inventory    | List of the player's inventory contents
| behr.essentials.cached_inventories.<[index]>.damager            | restore_inventory    | Entity who killed the player, if any
| behr.essentials.cached_inventories.<[index]>.location           | restore_inventory    | Location of where the player died
| behr.essentials.cached_inventories.<[index]>.timestamp          | restore_inventory    | Time of when the inventory was cached
| behr.essentials.cached_inventories.<[index]>.world              | restore_inventory    | Name of the world where this inventory was saved
| behr.essentials.cached_inventories.<[index]>.xp                 | restore_inventory    | Experience of the player removed on death
| behr.essentials.rules                                           | `/rules`             | Lists the rules for b
| behr.essentials.run_speed                                       | `run_speed`          | Adjusts your run-speed up to 10
| behr.essentials.skins                                           | `/skin`              | Managers your player's skin
| simplesit.armorstand.entity                                     | sit                  | The chair entity for chairs
| simplesit.armorstand.location                                   | sit                  | The chair entity's location for chairs
| behr.essentials.suicide                                         | `/suicide`           | Kills yourself
| behr.essentials.teleport_menu                                   | `/teleport_menu`     | Opens the teleport_menu menu, or teleports you to the named location
| behr.essentials.time                                            | `/time`              | Changes the time of day
| behr.essentials.weather                                         | `/weather`           | Adjusts the weather to sunny, clear, stormy, or thundery
| behr.essentials.world                                           | `/world`             | Manages worlds or teleports youself or another player to the specified world

## Server
| Permission name                                                     | Command / Script     | Description |
| :------------------------------------------------------------------ | :------------------: | :---------- |
| behr.essentials.weather.world.<[world]>.weather                     | weather              | Determines the weather manually set for <[world]> between `storm`, `thunder`, and `sunny`
| behr.essentials.weather.world.<[world]>.lock                        | weather              | Determines if <[world]>'s weather is locked for the day
| behr.essentials.crafting                                            | crafting             | The quantity of netherrack or nylium stored in a furnace
| behr.essentials.saved_skins                                         | skins                | Map of saved skins with their url and skin blobs
| behr.essentials.saved_skins.<[name]>                                | skins                | Map of the url, the skin blob, and any skin overlays per player for the <[name]> skin
| behr.essentials.saved_skins.<[name]>.url                            | skins                | URL of the saved skin for <[name]>
| behr.essentials.saved_skins.<[name]>.skin_blob                      | skins                | Skin_blob of the saved skin for <[name]>
| behr.essentials.saved_skins.<[player]>.<[name]>.url                 | skins                | URL of the saved skin for <[name]> overlaying <[player]>'s skin
| behr.essentials.saved_skins.<[player]>.<[name]>.skin_blob           | skins                | Skin_blob of the saved skin for <[name]> overlaying <[player]>'s skin
| behr.essentials.teleport_menu_locations                             | teleport_menu        | Map of names mapped to locations to teleport to with the teleport menu
| behr.essentials.teleport_menu_locations.<[name]>.creator            | teleport_menu        | The player of the user who created the teleport  location for <[name]>
| behr.essentials.teleport_menu_locations.<[name]>.icon               | teleport_menu        | The icon of the teleport location for <[name]>
| behr.essentials.teleport_menu_locations.<[name]>.location           | teleport_menu        | Location of the <[name]> location available for teleporting to with the teleport menu
| behr.essentials.teleport_menu_locations.<[name]>.time_created       | teleport_menu        | The time the location was saved for <[name]>
| behr.essentials.teleport_menu_locations.<[name]>.world              | teleport_menu        | World of the <[name]> location available for teleport to with the teleport menu
| behr.essentials.teleport_menu_locations_last_update                 | teleport_menu        | Time when the teleport menu was last updated, to re-cache the menu
| behr.essentials.teleport_menu_locations_last_update_cache           | teleport_menu        | The last time the teleport menu was cached
| behr.projects                                                       | emoji_board          | Map of active projects on B
| behr.projects.<[project]>                                           | emoji_board          | Description of active <[project]>'s on B
| behr.back_data.wait_for_player                                      | bread_factory        | Map of the projects waiting for myserious contributors to arrive
| behr.back_data.wait_for_player.<[project]>.contributor              | bread_factory        | Map of the player UUIDs who contributed to the <[project]>s
| behr.back_data.wait_for_player.<[project]>.contributor.<[uuid]>     | bread_factory        | List of the contributions provided by the mysterious player who owns the <[uuid]>
| behr.back_data.wait_for_player.<[project]>.contributor              | bread_factory        | Map of player UUIDs who contributed to the <[project]>
| behr.back_data.wait_for_player.<[project]>.contributor.<[uuid]>     | bread_factory        | List of contributions provided from the player who owns the <[uuid]>
| behr.<[project]>.mystery_contributors.<[player_name]>.uuid          | bread_factory        | UUID of the mysterious contributor <[player_name]> to <[project]>
| behr.<[project]>.mystery_contributors.<[player_name]>.contributions | bread_factory        | List of the mysterious contributor <[player_name]>'s contributions' to <[project]>
| behr.<[project]>.contributors                                       | bread_factory        | Map of players who have contributed to <[project]>
| behr.<[project]>.contributors.<[player]>                            | bread_factory        | List of contributions to <[project]>
| behr.<[project]>.contributor_last_update                            | bread_factory        | The last time the contribution list for the <[project]> was updated
| behr.<[project]>.contributor_last_update_cache                      | bread_factory        | The last time the contribution list for the <[project]> was cached
| behr.mysterious_player_heads                                        | bread_factory        | Map of mysterious contributors' player heads with their skull_skin applied cached
***`*`*** Current <[projects]>: bread_factory, emoji_board

## Entities
| Flag name                                              | Script | Description |
| :----------------------------------------------------- | :----: | :---------- |
| behr.essentials.combat.grenade_stickied                | Determines the quantity of sticky grenades entity has been stuck with

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
| behr.essentials.permissions.read_chat_channel.<[channel]>     | false   | Determines if a player is allowed to read this chat channel, or not
| behr.essentials.chat.settings.show_delete_controls            | true    | Determines if a player is opted into seeing chat message delete controls, or not
| behr.essentials.chat.settings.show_dismiss_controls           | true    | Determines if a player is opted into seeing message dismiss controls, or not
| behr.essentials.chat.settings.hide_channel_buttons            | false   | Determines if a player has the channel buttons hidden from chat, or not
| behr.essentials.chat.settings.channel.<[channel]>.hide_button | false   | Determines if a player has the <[channel]> channel button hidden, or not
| behr.essentials.friends                                       | null    | Returns a list of friends a player has added to their friends list

## Server
yaml: behr.essentials.chat.history | Map of data:
```yml
chat:
  <[time].epoch_millis>:
    channel: The channel the message belongs to
    message: <[data.channel]>/The raw message being sent
    delete: The delete button available for players to delete for chat messages
    deleted: The time this message was deleted
    dismiss: The dismiss button available for players to delete for system messages
    dismissed: The list of players who have dismissed this system message
    targets: The list of players who will receive this message
    time: The TimeTag this message was sent
    player_uuid: The player's UUID who sent the message for supporting the Player Interaction GUI 
```

# Commands

## Player defaults
| Command            | Usage       -                          | Description |
| :----------------- | :------------------------------------- | :---------- |
| /chat_channel      | `/chat_channel (<channel>)`            | Changes the chat channel you're talking in. Default enabled are `all`, `player_chat`, and `system`. Admins own `admin`
| /chat_settings     | `/chat_settings (<setting>)`           | Changes various chat settings available for configuration
| /colors            | `/colors`                              | Lists the colors in a click-menu for copying and pasting
| /emoji_board       | -                                      | Opens the emoji-board for copying and pasting emojis
| /friend            | `/friend <player> (remove)`            | Adds or removes a player to or from your friends list
| /help              | `/help (#)`                            | Shows helpful command information
| /me                | `/me (message)`                        | me irl but outloud
| /ping              | `/ping (player>)`                      | Shows yours or another player's ping
| /rules             | `/rules`                               | Lists the rules for b
| /suicide           | `/suicide`                             | Kills yourself

## Sponsors
| Command            | Usage            | Description |
| :----------------- | :--------------- | :---------- |
| /hat               | `/hat`           | Places a held item in your head as a hat
| /head              | `/head (player)` | Gives yours or another player's head
| /skin              | `/skin help`<br>`/skin set <name>`<br>`/skin reset`<br>`/skin rename <old_name> <new_name>`<br>`/skin save <player_name>`<br>`/skin save <name> <url> (slim)`<br>`/skin list`<br>` /skin delete <name>` | Manages your player's skin



## Builder
| Command            | Usage                                 | Description |
| :----------------- | :------------------------------------ | :---------- |
| /ascend            | `/ascend`                             | ***`*`*** Takes you to the highest block where you're standing
| /buildermode       | `/buildermode`<br>Aliases: `/gmb`     | Toggles builder mode
| /clear_inventory   | `/clear_inventory (player)`           | ***`*`*** Clears your inventory<br>Admins can optionally clear another player's inventory
| /fly               | `/fly`                                | ***`*`*** Toggles your flight<br>Moderators can optionally toggle other player's flight 
| /fly_speed         | `/fly_speed (#)`                      | ***`*`*** Changes your fly speed<br>Moderators can optionally change other player's fly_speed<br>Speeds are from `0` to `10` or any of `lightspeed`, `ludicrous`, `plaid`, or `default`
| /run_speed         | `/run_speed (#)`                      | ***`*`*** Adjusts your walking and running speed<br>Moderators can optionally specify another player to adjust
| /teleport_menu     | `/teleport_menu`<br>Aliases: `/tm`    | ***`*`*** Opens the teleport menu for quick navigation teleportation
| /time              | `/time <time of day / 0-23999>`       | ***`*`*** Changes the time of the world to a time of the day<br>Times of day being any of `start`, `day`, `noon`, `sunset`, `bedtime`, `dusk`, `night`, `midnight`, `sunrise`, or `dawn`<br>Time can also be an integer time between `0` and `23999`
| /weather           | `/weather <weather>`                  | ***`*`*** Changes the weather of the world<br>Weather is any of `sunny`, `storm`, `thunder`, or `clear`
| /world             | `/world <world>`<br>`/world create <world>`<br>`/world destroy <world>`<br>`/world help`<br>`/world list`<br>`/world list_unloaded`<br>`/world load <world>`<br>`/world unload <world>`<br>`/world teleport <world> (player)` | ***`*`*** Teleports you to the specified world<br>Admins can manage worlds or teleport players to the specified world
***`*`*** Note: Builders can only use this under Builder restrictions

## Moderator
| Command            | Usage                                               | Description |
| :----------------- | :-------------------------------------------------- | :---------- |
| /clear_ground      | `/clear_ground`                                     | Clears the ground of dropped items around you
| /enchant           | `/enchant <enchantment> (level)`                    | Enchants an item in your hand
| /heal              | `/heal (player)`                                    | Heals a player or yourself
| /hunger            | `/hunger (player) <#>`                              | Hungers or satiates yours or another player's hunger
| /lore              | `/lore <lore line 1>(\|lore line #n)*`              | Applies lore to the item in hand
| /max_health        | `/max_health (player) <1-100>`<br>Aliases: `/maxhp` | Adjusts another player's or your max health from 1 to 100
| /max_oxygen        | `/max_oxygen (player) <#/default>`                  | Changes another player or your maximum oxygen capacity in seconds
| /oxygen            | `/oxygen (player) <0-20>`                           | Replinishes or deflates yours or another player's oxygen
| /rename_item       | `/rename_item <display name>`                       | Applies a custom display name to the item in hand

## Admin
| Command            | Usage      | Description |
| :----------------- | :--------- | :---------- |
| /clear_console     | `/clear_console`                                                   | Clears the console for a blank screen
| /gamemode          | `/gamemode <survival/creative/spectator/adventure/builder>`<br>Aliases: `/gms` \| `/gmc` \| `/gmsp` \| `/gma` \| `/gmb` | Changes your gamemode to any of `survival`, `creative`, `spectator`, `adventure`, or `builder`
| /restore_inventory | `/restore_inventory <player>`<br>Aliases: `/invrestore` \| `/invr` | Restores a previous inventory for a player after death
