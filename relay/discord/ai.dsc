create_ai_discord_command:
  type: task
  debug: false
  script:
    - definemap options:
        1:
          type: string
          name: ask
          description: Ask a question
          required: true
        2:
          type: number
          name: token_count
          description: Sets the maximum number of tokens to use in a response. Default is 2,000, maximum is 3,000.
          required: false
        3:
          type: boolean
          name: image
          description: Determines if the question prompted creates an image, or not
          required: false

    - ~discordcommand id:c create options:<[options]> name:ai "Description:Asks the AI a question" group:<script[ai_data].data_key[guild_id]>

ai_command_handler:
  type: world
  debug: false
  events:
    after discord message received:
      # ██ [ Check if the message received is a reply              ] ██
      - define message <context.new_message.replied_to.if_null[null]>
      - stop if:!<[message].is_truthy>

      # ██ [ Check if the message received is a valid reply to bot ] ██
      - stop if:<context.new_message.author.equals[<context.bot.self_user>]>
      - stop if:!<context.new_message.replied_to.author.equals[<context.bot.self_user>]>

      # stop if gif channel
      - stop if:<context.new_message.channel.id.equals[1072553008560349205]>

      # ██ [ Check if the message replied to is an AI response     ] ██
      # todo ██ [ determine if i want any reply to trigger replies ] ██
      # - stop if:!<[message].has_flag[AI_question_response]>
      - if !<[message].has_flag[AI_question_response]>:
        - flag <[message]> AI_question_response:2
      - flag <[message]> AI_question_response:--
      - stop if:<[message].flag[AI_question_response].is_less_than[0]>

      - define question <context.new_message.text>
      - define user <context.new_message.author>
      - define maximum_tokens 2000
      - inject ai_question_task

      # ██ [ Send the message                                      ] ██
      - ~discordmessage id:c channel:<context.channel> reply:<context.new_message> <[embed]> save:message
      - stop if:!<entry[message].message.if_null[null].is_truthy>
      - flag <entry[message].message> AI_question_response:3

    after discord slash command name:ai:
      - ~discordinteraction defer interaction:<context.interaction>
      - stop if:<context.channel.id.equals[1072553008560349205]>
      - define question <context.options.get[ask]>
      - define user <context.interaction.user>
      - if <context.options.contains[token_count]>:
        - define maximum_tokens <context.options.get[token_count]>
      - else:
        - define maximum_tokens 2000

      # ██ [ Check if the the user used the command wrongly        ] ██
      - if <[question]> == <empty>:
        - define embed "<discord_embed.with[footer].as[You have to ask a question or you ask for help.]>"
        - inject ai_question_task.sub_paths.error_response

      - inject ai_question_task

      - define embed "<[embed].with[footer].as[you asked<&co> <[question]>]>"

      # ██ [ Send the message                                      ] ██
      - flag server behr.discord.users.<[user].id>.experience:+:<util.random.int[10].to[15]>
      - ~discordinteraction reply interaction:<context.interaction> <[embed]> save:message
      # - flag <context.interaction.target_message> AI_question_response:3

ai_question_task:
  type: task
  debug: false
  sub_paths:
    error_response:
      - define embed <[embed].with[color].as[<color[100,0,0]>]>
      - define embed <[embed].with[footer_icon].as[https://cdn.discordapp.com/emojis/901634983867842610.gif]>

      # ██ [ Check if the request was a reply or an interaction    ] ██
      - discord id:c stop_typing channel:<context.channel>
      - if <context.interaction.exists>:
        - ~discordinteraction reply interaction:<context.interaction> <[embed]> save:message ephemeral
      - else:
        - ~discordmessage id:c channel:<context.channel> reply:<context.new_message> <[embed]>
      - stop

  script:
      - discord id:c start_typing channel:<context.channel>
      # ██ [ Create base definitions                               ] ██
      - define embed_map.color <color[0,254,255]>
      - if <context.options.contains[image].if_null[false]> && <context.options.get[image].if_null[false]>:
        - define embed <discord_embed>
        - define embed "<[embed].with[footer].as[Prompted from<&co><[question]>]>"
        - define url https://api.openai.com/v1/images/generations
        - definemap headers:
            Authorization: <secret[ai]>
            Content-Type: application/json
            User-Agent: B
        - definemap data:
            size: 256x256
            #size: 1024x1024
            n: 10
            prompt: <[question]>
        - ~webget <[url]> data:<[data].to_json[native_types=true]> headers:<[headers]> save:response
        #- inject web_debug.webget_response
        - if <entry[response].failed>:
          - define embed "<[embed].with[footer].as[Unexpected error, please try again later.]>"
          - inject ai_question_task.sub_paths.error_response
        - define image_url <util.parse_yaml[<entry[response].result>].get[data].last.get[url]>
        - define embed <[embed].with[color].as[<color[0,254,255]>]>
        - discord id:c stop_typing channel:<context.channel>
        - ~discordmessage id:c channel:<context.channel> "<[embed].with[title].as[Alternative Results].with[description].as[<util.parse_yaml[<entry[response].result>].get[data].get[3].to[9].parse_tag[<&lb>Image Reference<&rb>(<[parse_value].get[url]>)].separated_by[<n>]>]>"
        - define embed <[embed].with[image].as[<[image_url]>]>
        - ~discordinteraction reply interaction:<context.interaction> <[embed]>
        - stop
      - else:
        - define url https://api.openai.com/v1/completions

      - definemap headers:
          Authorization: <secret[ai]>
          Content-Type: application/json
          User-Agent: B

      # ██ [ Check if asking how to use this command, generically  ] ██
      - if <script[ai_data].data_key[generic_help_questions].contains_any_text[<[question]>]>:
        - define embed_map.title "Discord Command | `/ai <&lt>question<&gt>`"
        - define embed_map.description "Creates a chat request to the OpenAI API and returns it's response.<n>You can alternatively reply to my messages and I will respond.<n>"
        - define embed <discord_embed.with_map[<[embed_map]>]>
        - define embed "<[embed].add_field[**Misc Arguments<&co>**].value[`/ai ask:help` - Opens this helpful guide on how to use this command and how the arguments work.]>"
        - define embed "<[embed].add_field[**(ask<&co><&lt>question<&gt>)**].value[Asks the AI a question you input]>"
        - define embed "<[embed].add_field[**(max_tokens<&co><&ns>)**].value[Specifies the maximum number of tokens the AI will use to generate your response. Higher token count will result in a more in-depth and longer response. Maximum is 1,000, default is 200.]>"

        # ██ [ Create a quick list of ideas for questions          ] ██
        - define data '{"model":"text-davinci-003","prompt": "What are three cool questions I can ask you?","temperature": 0,"max_tokens": 200}'
        - ~webget <[url]> data:<[data]> headers:<[headers]> save:response

        # ██ [ Check if the request failed                         ] ██
        - if !<entry[response].failed>:
          - define embed "<[embed].add_field[Some ideas to try!].value[<util.parse_yaml[<entry[response].result>].get[choices].first.get[text]>]>"

        # ██ [ Check if the request was a reply or an interaction  ] ██
        - discord id:c stop_typing channel:<context.channel>
        - if <context.interaction.exists>:
          - ~discordinteraction reply interaction:<context.interaction> <[embed]> save:message
        - else:
          - ~discordmessage id:c channel:<context.channel> <[embed]>
        - stop

      # ██ [ Check if the token count is too high                  ] ██
      - if <[maximum_tokens]> > 3000:
        - define embed <discord_embed.with[footer].as[Maximum token count cannot be above 3,000.]>
        - inject ai_question_task.sub_paths.error_response


      # ██ [ Check if the token count is too low                   ] ██
      - if <[maximum_tokens]> <= 0:
        - define embed "<discord_embed.with[footer].as[Maximum token count cannot be negative.]>"
        - inject ai_question_task.sub_paths.error_response

      # ██ [ Create the request                                    ] ██
      # todo: test start
      - flag server "training.information:->:<[user].name><&co> <[question]>"
      # todo: test end
      - definemap data:
          model: text-davinci-003
          #prompt: <[question]>
          prompt: <[question]>
          temperature: 0.7
          max_tokens: <[maximum_tokens]>
          #user: <[user_id]>
      - define data.prompt <[question]>. if:!<[question].ends_with[.]>
      - ~webget <[url]> data:<[data].to_json[native_types=true]> headers:<[headers]> save:response
      # - inject web_debug.webget_response

      # ██ [ Check if the request failed                           ] ██
      - if <entry[response].failed>:
        - define embed "<discord_embed.with[footer].as[Unexpected error, please try again later.]>"
        - inject ai_question_task.sub_paths.error_response

      # ██ [ Return the response                                   ] ██
      - define response <util.parse_yaml[<entry[response].result>].get[choices].first.get[text].replace_text[Champagne(you)<&co><n><n>]>
      - define embed_map.description <[response]>
      - define embed <discord_embed.with_map[<[embed_map]>]>
      # todo: test end
      - flag server "training.information:->:Champagne(you)<&co> <[response]>"
      - if <server.flag[training.information].size> > 10:
        - define previous_data <server.flag[training.information].get[<server.flag[training.information].size.sub[10]>].to[last]>
        - flag server training.information:!
        - flag server training.information:|:<[previous_data]>
      # todo: test start

ai_data:
  type: data
  guild_id: 901618453356630046
  generic_help_questions:
    - How do i use this command
    - How do i use /ai
    - How to use /ai
    - help
    - help me
    - help me with using this command
    - help me use /ai
    - help me use ai
