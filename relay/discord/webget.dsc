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
          description: Specifies the HTTP method to use in your request
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

    - ~discordcommand id:b create name:webget "description:Gets the contents of a web page or API response" group:901618453356630046 options:<[options]>
