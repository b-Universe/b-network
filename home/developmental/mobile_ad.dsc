mobile_ad_test:
  type: task
  debug: false
  script:
    - narrate "made for either webhook or bot message"

  data:
    description:
      - 🤖**Android Products**🤖
      - <&gt> [Minecraft for Android](https://play.google.com/store/apps/details?id=com.mojang.minecraftpe)
      - <&gt>
      - <&gt> Download Minecraft for Android
      - <&gt> from the Google Play store
      - <&gt> `(Free if you own Java Edition)` / `($7.49)`
      - <&gt> <&sp>
      - <&gt> [Status Widget](https://play.google.com/store/apps/details?id=me.jenibor.minecraftserverstatus)
      - <&gt>
      - <&gt> Check the status of the server from
      - <&gt> your lock screen or home screen! `(Free)`
      - <empty>
      - 🍎**Apple Products**🍎
      - <&gt> [Minecraft for iPhone, iPad, and Mac](https://apps.apple.com/us/app/minecraft/id479516143)
      - <&gt> Download Minecraft for Apple
      - <&gt> from the App Store for `($6.99)`
      - <&gt> <&sp>
      - <&gt> [Status Widget](https://apps.apple.com/us/app/mc-status-widget-for-minecraft/id1408215245?platform=iphone)
      - <&gt> Check the status of the server from
      - <&gt> your homepage or lock screen for  `($6.99)`

  webhook:
    - define hook_url https://url.com

    - definemap headers:
        User-Agent: b
        Content-Type: application/json

    - definemap embed:
        description: <script.parsed_key[data.description].separated_by[<n>]>
        color: 60415

    - definemap data:
        #username: 
        # avatar_url: 
        embeds:
          - <[embed]>

    - ~webget <[hook_url]> headers:<[headers]> data:<[data].to_json> save:response

  bot message:
    - define channel_id 1234567890

    - definemap embed_map:
        description: <script.parsed_key[data.description].separated_by[<n>]>
        color: 60415

    - define embed <discord_embed.with_map[<[embed_map]>]>
    - ~discordmessage id:b channel:<[channel_id]> <[embed]>
