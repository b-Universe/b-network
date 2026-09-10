# +----+-----------------------------------------------------------------------------+----+
# | ██ | Description:                                                                | ██ |
# | ██ | Create a new role for the guild                                             | ██ |
# | ██ | Requires the `MANAGE_ROLES` permission                                      | ██ |
# | ██ | Returns the new role object on success                                      | ██ |
# | ██ | Fires a `Guild Role Create` Gateway event                                   | ██ |
# | ██ | All `JSON` params are optional                                              | ██ |
# +----+-----------------------------------------------------------------------------+----+
# | ██ | Tags: `<[role_id]>` - the ID of the role created                            | ██ |
# +----+-----------------------------------------------------------------------------+----+
# | ██ | Meta: https://docs.discord.com/developers/resources/guild#create-guild-role | ██ |
# +----+-----------------------------------------------------------------------------+----+
discord_create_guild_role:
  type: task
  definitions: guild_id|permissions|role_name
  script:
    - define url_endpoint https<&co>//discord.com/api/v10/guilds/<[guild_id]>/roles

    - definemap request_headers:
        User-Agent: B
        Authorization: Bot <secret[c]>
        Content-Type: application/json
        X-Audit-Log-Reason: Automated role setup via Denizen script

    - define permission_map <script[discord_permission_flags].data_key[map]>
    - define permission_bitwise_values <[permission_map].get[view_channel|send_messages|read_message_history].sum>

    - definemap role_paylod:
        name: <[role_name]>
        permissions: <[permissions]>
        color: <[color].rgb_integer>
        hoist: true
        # Input is a raw emoji, eg: 🪐, 💬, and 🦽
        unicode_emoji: null
        mentionable: true

    - define role_payload <map[name=New Role].to_json>
    - ~webget <[url_endpoint]> data:<[role_payload]> headers:<[request_headers]> method:POST save:role_response

    - define role_id <entry[role_response].result.parse_yaml.get[id].if_null[null]>
