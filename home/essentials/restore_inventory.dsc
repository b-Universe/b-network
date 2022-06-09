restore_inventory_command:
  type: command
  name: restore_inventory
  debug: false
  description: Restores a previous inventory for a player after death
  aliases:
    - invrestore
  usage: /restore_inventory <&lt>player<&gt>
  permission: behr.essentials.restore_inventory
  tab completions:
    1: <server.online_players.exclude[<player>].parse[name]>
  script:
    # todo: create a GUI for managing cached inventories
    - if <Context.args.is_empty> || <context.args.size> > 2:
      - narrate "<&c>You have to specify a player to restore an inventory for"
      - stop

    - define player <server.match_player[<context.args.first>].if_null[null]>
    - if !<[player].is_truthy>:
      - narrate "<&c>You have to specify a player, that player wasn't found"
      - stop

    - if <context.args.size> == 1:
      - define index 1
    - else:
      - define index <context.args.last>

    - if !<[index].is_integer>:
      - narrate "<&c>Inventory indexes are numbers"
      - stop

    - if !<[player].has_flag[behr.essentials.cached_inventories]>:
      - narrate "<&c>There are no cached inventories for this player"
      - stop

    - if <[player].flag[behr.essentials.cached_inventories].size> > <[index]>:
      - narrate "<&c>The player doesn't have that many inventories cached"
      - stop

    # cache the old inventory? or just give, maybe in a chest or a shulkerbox or a backpack or a bag
    # clear and give the cached inventory

store_inventory_listener:
  type: world
  debug: false
  events:
    on player dies:
      - define epoch <util.time_now.epoch_millis>

      - definemap inventory_cache:
          cause: <context.cause>
          contents:
            equipment: <player.equipment_map>
            inventory: <player.inventory.list_contents>
          damager: <context.damager>
          location: <player.location>
          timestamp: <util.time_now>
          world: <player.location.world.name>
          xp: <context.xp>

      - flag <player> behr.essentials.cached_inventories:<map.with[<[epoch]>].as[<[inventory_cache]>]>

# todo: cached inventory viewer gui
player_inventory_cache_gui:
  type: inventory
  inventory: chest
  size: 54
  gui: false
  slots:
    # menu
    #- [menu] [info] [restore] [delete] [] [] [] [] []
    # equipment
    #- [head] [top] [bottom] [booties] [mainhand] [offhand]
    # inventory
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    # hotbar
    - [] [] [] [] [] [] [] [] []
