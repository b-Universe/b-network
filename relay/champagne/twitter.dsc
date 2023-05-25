twitter_task:
  type: task
  definitions: action
  data:
    application:
      name: 1661381749018972165Champagne_b
      id: 27192907
      bearer_token: <secret[twitter_bearer_token]>
      access_token: <secret[twitter_access_token]>
      access_secret: <secret[twitter_access_secret]>
      api_and_secret: <secret[twitter_api_and_secret]>
    endpoints:
      post: https<&co>//api.twitter.com/2/tweets
      delete: https<&co>//api.twitter.com/2/tweets/<[tweet_id]>
      search_user: https://api.twitter.com/2/users/by/username

      authorize: https<&co>//api.twitter.com/oauth/authorize
      request_token: https<&co>//api.twitter.com/oauth/request_token?oauth_callback=oob&x_auth_access_type=write
      oAuth: https<&co>//api.twitter.com/oauth2/token
    headers:
      Content-Type: application/json
      User-Agent: Champagne
      Authorization: <script.parsed_key[data.application.access_token]>
  script:
    - if !<[action].exists>:
      - narrate "<&c>Must specify an action<&6><&co> <&e><script.list_keys[data.endpoints].remove[-1|-2|-3].separated_by[<&a>, <&e>]>"
      - stop

    - define url <script.parsed_key[data.endpoints.<[action]>]>
    - define headers <script.parsed_key[data.headers]>

    - choose <[action]>:
      - case post:
        - definemap data:
            content: I am Champagne!

        #- define url <script.parsed_key[data.endpoints.authorize]>
        #- define url <script.parsed_key[data.endpoints.request_token]>
        - ~webget <[url]> headers:<[headers]> data:<[data].to_json[native_types=true]> save:response
        - inject web_debug.webget_response

twitter_reminder:
  type: world
  events:
    #on system time minutely every:10 chance:3:
    on system time minutely every:10 chance:3 server_flagged:!behr.champagne.brain.has_already_asked_about_tweeting:
      - define time <util.time_now>
      - stop if:!<[time].day_of_week.is_in[2|3|4|5]>
      - stop if:!<[time].hour.is_in[12|13|14|15|16]>

      - flag server behr.champagne.brain.has_already_asked_about_tweeting expire:2d
      - define mom_mention <&lt>@194619362223718400<&gt>
      - define channel_id 901618453356630052
      #- define channel_id 901618453746712665


      # ██ [ Create base definitions                               ] ██
      - define embed_map.color <color[0,254,255]>
      - define url <script[bdata].parsed_key[api.OpenAI.endpoint.completions]>
      - define headers <script[bdata].parsed_key[api.OpenAI.headers]>

      # ██ [ Create the request                                    ] ██
      - definemap data:
          model: text-davinci-003
          prompt: <script[bdata].parsed_key[champagne.twitter_brain].random[100].separated_by[<n>]>
          temperature: 0.7
          max_tokens: 1500
          n: 1
      - discord id:c start_typing
      - ~webget <[url]> data:<[data].to_json[native_types=true]> headers:<[headers]> save:response
      - inject web_debug.webget_response

      # ██ [ Return the response                                   ] ██
      - define embed_map.description <util.parse_yaml[<entry[response].result>].get[choices].last.get[text].replace_text[Champagne<&co> ].replace_text[Champagne<&co>]>
      - if !<[embed_map.description].is_truthy>:
        - flag server behr.champagne.brain.has_already_asked_about_tweeting:!
        - stop
      - flag server "behr.champagne.training.davinci:->:Champagne<&co> <[embed_map.description]>"
      - flag server behr.champagne.training.davinci[1]:<- if:<server.flag[behr.champagne.training.davinci].size.is_more_than[7]>

      - define embed <discord_embed.with_map[<[embed_map]>]>

      - discordmessage id:c channel:<[channel_id]> <[mom_mention]>! embed:<[embed]>
