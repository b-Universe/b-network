discord_permission_flags:
  type: data
  map:
    # General Server Permissions
    view_channel: 1024
    manage_channels: 16
    manage_roles: 268435456
    manage_emojis_and_stickers: 1073741824
    create_guild_expressions: 8796093022208
    view_audit_log: 128
    view_guild_insights: 524288
    manage_webhooks: 536870912
    manage_guild: 32

    # Membership Permissions
    create_instant_invite: 1
    change_nickname: 67108864
    manage_nicknames: 134217728
    kick_members: 2
    ban_members: 4
    moderate_members: 1099511627776

    # Text Channel Permissions
    send_messages: 2048
    send_messages_in_threads: 274877906944
    create_public_threads: 34359738368
    create_private_threads: 68719476736
    embed_links: 16384
    attach_files: 32768
    add_reactions: 64
    use_external_emojis: 262144
    use_external_stickers: 137438953472
    mention_everyone: 131072
    manage_messages: 8192
    manage_threads: 17179869184
    read_message_history: 65536
    send_tts_messages: 4096
    send_voice_messages: 70368744177664
    send_polls: 562949953421312

    # Voice & Stage Channel Permissions
    connect: 1048576
    speak: 2097152
    stream: 512
    use_soundboard: 4398046511104
    use_external_sounds: 35184372088832
    use_vad: 33554432
    priority_speaker: 256
    mute_members: 4194304
    deafen_members: 8388608
    move_members: 16777216
    request_to_speak: 4294967296

    # Events Permissions
    create_events: 17592186044416
    manage_events: 8589934592

    # Apps & Monetization Permissions
    use_application_commands: 2147483648
    use_embedded_activities: 549755813888
    use_external_apps: 1125899906842624
    view_creator_monetization_analytics: 2199023255552

    # Advanced Permissions
    administrator: 8
