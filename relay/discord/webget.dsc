create_webget_discord_command:
  type: task
  debug: true
  script:
    - definemap options:
        1:
          name: help
          type: boolean
          description: Shows helpful information on how to use this command correctly
          required: false
        2:
          name: url
          type: string
          description: webpage or API url to connect to
          required: true
        3:
          name: data
          type: string
          description: Set of data to send to the server (changes the default method from GET to POST)
          required: false
       4:
          name: parsed_data
          type: string
          description: Parses tags and converts to data to send to the server (changes the default method from GET to POST)
          required: false
        5:
          name: method
          type: string
          # choices:  GET|POST|HEAD|OPTIONS|PUT|DELETE|TRACE|PATCH
          description: Specifies the HTTP method to use in your request (default GET)
          required: false
        6:
          name: headers
          type: string
          description: Headers to submit to the server; Uses `key=value;...` format
          required: false
        7:
          name: timeout
          type: string
          description: Sets how long the command should wait for a webpage to load before giving up (defaults to 10 seconds)
          required: false
       8:
          name: log
          type: boolean
          description: Enables or disables logging the request query (Default disabled)
          required: false
        9:
          name: extension
          type: string
          # choices: json|dsc|yml|txt|html
          description: Determines the extension to save the request query if logged (Defaults to txt)
          required: false
       10:
          name: fail_status
          type: boolean
          description: Indicates whether connection errors or any failure statuses return
          required: false
        11:
          name: confirm
          type: boolean
          description: Follows-up with a confirmation after submitting a request made, useful for responses with longer delays
          required: false
        12:
          name: result
          type: boolean
          description: Determines whether the result is returned (Default true)
          required: false
      # todo: add secrettag urls for use and make the url arg not required, error if neither are used
      # 13:
          # name: secret_url
          # type: string
          # note: discord-hook; maybe bot-spam-discord-webhook or a discord-channel-webhook that returns whether a channel's hook exists? create it if not?
          # choices: discord-hook
          # description: Uses a secret url as the webpage or API url to connect to
          # required: false
     # todo: queue controls
     # 14:
          # name: queue
          # type: string
          # choices: list|clear|stop
          # description: Manages active webget queues
          # required: false

    - ~discordcommand id:b create name:webget "description:Gets the contents of a web page or API response" group:901618453356630046 options:<[options]>

webget_command_handler:
  type: world
  debug: true
  events:
    on discord slash command name:webget:
      # % ██ [ set defaults ] ██
      - define method get if:<context.options.contains[method]>
      - define timeout 10s if:!<context.options.contains[timeout]>
      - define embed_data.color <color[0,254,255]>
      - define headers <map[User-Agent=b]>
      - define description <list>
      - define error_list <list>
      - define response <list>

      # % ██ [ check if help was requested ] ██
      - if <context.options.contains[help]> && <context.options.get[help]>:
        - ~discordinteraction defer interaction:<context.interaction>
        - define embed_data.title "Discord Command | `/webget <&lt>url<&gt> (args)`"
        - definemap description:
            - Connects to a webpage or API and returns or saves it's contents and response.
            # <&lb>url<&co><&lt>url<&gt>/secret_url<&co>list/some_secret_urls_here<&rb>
            - **Command Usage**<&co> `/webget <&lb>url<&co><&lt>url<&gt><&rb> (data/parsed_data<&co><&lt>data<&gt>) (method<&co><&lt>method<&gt>) (headers<&co><&lt>header=value(;...)+<&gt>) (timeout<&co><&lt>duration<&gt>) (failed_status<&co>true/false) (log<&co>true/false) (extension<&co><&lt>txt/yml/json/html/etc<&gt>) (confirm<&co>true/false) (result<&co>true/false)
            # - **Queue Controls**<&co> `/webget queue<&co>list/clear/cancel X`
            - **Misc Arguments**<&co> `/webget help`
        - define embed_data.description <[description].separated_by[<n>]>
        # - definemap embed_data.fields:
              # - name: Controls & Page Index
              #   value: left_disabled ( 1 / 3 ) right | **Description** | Arguments (1/2) | Arguments (2/2)

        - ~discordinteraction reply interaction:<context.interaction> <discord_embed.with_map[<[embed]>]>
        - stop

      # % ██ [ Check for url ] ██
        - if <context.options.contains[url|secret_url]>:
          - definemap embed_data:
              title: **Command error** | Too many arguments
              color: <color[red]>
              description: Must specify only either `url` or `secret_url`. `url` refers to any webpage or API link. `secret_url` refers to any named and saved secret url
              footer: Note<&co> use /webget help for more help
              footer_icon: https://cdn.discordapp.com/emojis/901634983867842610.gif
            - ~discordinteraction reply interaction:<context.interaction> ephemeral <discord_embed.with_map[<[embed_data]>]>
            - stop

        - else if <context.options.contains[url]>:
          - define url <context.options.get[url]>

        - else if <context.options.contains[secret_url]>
          - define secret <context.options.get[secret_url]>
          - if <secret[<[secret]>].is_truthy>:
            - define url <secret[<[secret]>]>
          - else:
            - definemap embed_data:
                title: **Command error** | Invalid secret url
                # description: Available secret url's that you have permission to use<&co><n><[secret_list].parse_value_tag[**<[parse_key]>**<&co> `<[parse_value]>`].values.separated_by[<n>]>
                footer: Note<&co> use /webget help for more help
                footer_icon: https://cdn.discordapp.com/emojis/901634983867842610.gif
            - ~discordinteraction reply interaction:<context.interaction> ephemeral <discord_embed.with_map[<[embed_data]>]>

        - else:
          - definemap embed_data:
              title: **Command error** | No url specified
              description: Must specify a webpage or an API to query
              footer: Note<&co> use /webget help for more help
              footer_icon: https://cdn.discordapp.com/emojis/901634983867842610.gif
          - ~discordinteraction reply interaction:<context.interaction> ephemeral <discord_embed.with_map[<[embed_data]>]>
          - stop
            

      # % ██ [ Check for data ] ██
        - if <context.options.contains[data|parsed_data]>:
          - definemap embed_data:
              title: **Command error** | Invalid data
              color: <color[red]>
              description: Must specify only either data or parsed_data. Data uses raw input, parsed_data parses tags before converting to raw data.
              footer: Note: use /webget help for more help
              footer_icon: https://cdn.discordapp.com/emojis/901634983867842610.gif
          - ~discordinteraction reply interaction:<context.interaction> ephemeral <discord_embed.with_map[<[embed_data]>]>
          - stop

        - else if <context.options.contains[data]>:
          - define data <context.options.get[data]>
          - define method post
          
        - else if <context.options.contains[parsed_data]>:
          - define data <context.options.get[parsed_data].parsed>
          - define method post

      # % ██ [ Check for method ] ██
      - if <context.options.contains[method]>:
        - if <context.options.get[method]> in GET|POST|HEAD|OPTIONS|PUT|DELETE|TRACE|PATCH:
          - define method <[method]>
        - else:
          - define method get if:!<[method].exists>
          - define error_list "<[error_list].include_single[**Method Error**<&co> `<context.options.get[method]>` is an invalid method. Defaulted to <[method]>]>

      # % ██ [ Check for timeout ] ██
      - if <context.options.contains[timeout]>:
        - if <duration[<context.options.get[timeout]>].is_truthy>:
          - define timeout <context.options.get[timeout]>
          - if <duration[<[timeout]>].in_minutes> > 5:
            - define error_list "<[error_list].include_single[**Timeout Error**<&co> `<[timeout]>` exceeds the five minute timeout limit. Defaulted to `5m`]>"
            - define timeout 5m
          - else if <duration[<[timeout].in_ticks> < 0:
            - define error_list "<[error_list].include_single[**Timeout Error**<&co> `<[timeout]>` is less than zero and is invalid. Defaulted to `10s`]>"
            - define timeout 10s
        - else:
          - define error_list "<[error_list].include_single[**Timeout Error**<&co> `<context.options.get[timeout]>` is an invalid duration. Defaulted to `<[timeout]>`]>"

      # % ██ [ Check for confirmation ] ██
      - if <context.options.contains[confirmation]> && <context.options.get[confirmation]>:
        - define embed.title "**Webget confirmation**"
        - define description "<[description].include_single[Webget request submit with a timeout of <duration[<[timeout]>].formatted>]>"
        - define description <[description].include[<[error_list]>]> if:!<[error_list].is_empty>
        - define embed.description <[description].separated_by[<n>]>
        - ~discordinteract reply interaction:<context.interaction> ephemeral <discord_embed.with_map[<[embed]>]>
      - else:
        - ~discordinteract delete interaction:<context.interaction>

      # % ██ [ Check for headers ] ██
      - if <context.options.contains[headers]>:
        - if <map.include[<context.options.get[headers]>]>].is_truthy>:
          - define <[headers].include[<context.options.get[headers]>]>
        - else:
          - define error_list "<[error_list].include_single[**Headers Error**<&co> `<context.options.get[headers]>` is an invalid header mapping. Format is `key=value;...` (ex<&co> `User-Agent=Champagne`]>"
          


      # % ██ [ Create webget ] ██
      - if <[data].exists>:
        - ~webget <[ur]> data:<[data]> method:<[method]> headers:<[headers]> save:response
      - else:
        - ~webget <[url]> method:<[method]> headers:<[headers]> save:response
        
      # % ██ [ Check for fail status responses ] ██
      - if <context.options.contains[fail_status]> && <context.options.get[fail_status]> && <entry[response].failed.if_null[false]>:
       - definemap entry_responses:
          failed:
            name: **Failed**<&co>
            value: `<entry[response].failed.if_null[invalid]>`
            inline: true
          status:
            name: **HTTP status**<&co>
            value: <entry[status].failed.if_null[invalid].proc[<[http_status_codes]>]>
            inline: true
          time_ran:
            name: **Failed**<&co>
            value: `<entry[time_ran].failed.if_null[invalid]>`
            inline: true
          result_headers:
            name: **Failed**<&co>
            value: ```<entry[result_headers].failed.if_null[invalid].replace_text[`].with[']>```
          result:
            name: **result**<&co>
            value: ```<entry[result].failed.if_null[invalid].replace_text[`].with[']>```
        
        #- define entry_responses <list_single[]>
        #- define entry_responses <[entry_responses].include_single[]>
        - define response <[response].include_single[<[entry_responses]>

      # % ██ [ Check for logging ] ██
      # % ██ [ Check for extension ] ██
      # % ██ [ Check for result ] ██

http_status_codes:
  type: procedure
  definitions: code
  debug: false
  script:
    - if <script.data_key[codes].contains[<[code]>]>:
      - determine <script.data_key[codes.<[code]>]>

    - choose <[code].char_at[1]>:
      - case 1:
        - determine "**`1xx`**` - Informational Response`"
      - case 2:
        - determine "**`2xx`**` - Success`"
      - case 3:
        - determine "**`3xx`**` - Redirection`"
      - case 4:
        - determine "**`4xx`**` - Client Errors`"
      - case 5:
        - determine "**`5xx`**` - Server Errors`"
      - default:
        - determine **<[code]>**
  codes:
# @ ██ [1xx - Informational response   ] ██
    100: "**`100`**` - Continue`"
    101: "**`101`**` - Switching Protocols`"
    102: "**`102`**` - Processing`"
    103: "**`103`**` - Early Hints`"

# @ ██ [2xx - Success                  ] ██
    200: "**`200`**` - OK`"
    201: "**`201`**` - Created`"
    202: "**`202`**` - Accepted`"
    203: "**`203`**` - Non-Authoritative Information`"
    204: "**`204`**` - No Content`"
    205: "**`205`**` - Reset Content`"
    206: "**`206`**` - Partial Content`"
    207: "**`207`**` - Multi-Status`"
    208: "**`208`**` - Already Reported`"
    226: "**`226`**` - IM Used`"

# @ ██ [3xx - Redirection              ] ██
    300: "**`300`**` - Multiple Choices`"
    301: "**`301`**` - Moved Permanently`"
    302: '**`302`**` - Found (Previously "Moved temporarily")`'
    303: "**`303`**` - See Other`"
    304: "**`304`**` - Not Modified`"
    305: "**`305`**` - Use Proxy`"
    306: "**`306`**` - Switch Proxy`"
    307: "**`307`**` - Temporary Redirect`"
    308: "**`308`**` - Permanent Redirect`"

# @ ██ [4xx - Client errors            ] ██`
    400: "**`400`**` - Bad Request`"
    401: "**`401`**` - Unauthorized`"
    402: "**`402`**` - Payment Required`"
    403: "**`403`**` - Forbidden`"
    404: "**`404`**` - Not Found`"
    405: "**`405`**` - Method Not Allowed`"
    406: "**`406`**` - Not Acceptable`"
    407: "**`407`**` - Proxy Authentication Required`"
    408: "**`408`**` - Request Timeout`"
    409: "**`409`**` - Conflict`"
    410: "**`410`**` - Gone`"
    411: "**`411`**` - Length Required`"
    412: "**`412`**` - Precondition Failed`"
    413: "**`413`**` - Payload Too Large`"
    414: "**`414`**` - URI Too Long`"
    415: "**`415`**` - Unsupported Media Type`"
    416: "**`416`**` - Range Not Satisfiable`"
    417: "**`417`**` - Expectation Failed`"
    418: "**`418`**` - I'm a teapot`"
    421: "**`421`**` - Misdirected Request`"
    422: "**`422`**` - Unprocessable Entity`"
    423: "**`423`**` - Locked`"
    424: "**`424`**` - Failed Dependency`"
    425: "**`425`**` - Too Early`"
    426: "**`426`**` - Upgrade Required`"
    428: "**`428`**` - Precondition Required`"
    429: "**`429`**` - Too Many Requests`"
    431: "**`431`**` - Request Header Fields Too Large`"
    444: "**`444`**` - No Response`"
    494: "**`494`**` - Request header too large`"
    495: "**`495`**` - SSL Certificate Error`"
    496: "**`496`**` - SSL Certificate Required`"
    497: "**`497`**` - HTTP Request Sent to HTTPS Port`"
    499: "**`499`**` - Client Closed Request`"
    451: "**`451`**` - Unavailable For Legal Reasons`"

# @ ██ [5xx Server errors              ] ██
    500: "**`500`**` - Internal Server Error`"
    501: "**`501`**` - Not Implemented`"
    502: "**`502`**` - Bad Gateway`"
    503: "**`503`**` - Service Unavailable`"
    504: "**`504`**` - Gateway Timeout`"
    505: "**`505`**` - HTTP Version Not Supported`"
    506: "**`506`**` - Variant Also Negotiates`"
    507: "**`507`**` - Insufficient Storage`"
    508: "**`508`**` - Loop Detected`"
    510: "**`510`**` - Not Extended`"
    511: "**`511`**` - Network Authentication Required`"
