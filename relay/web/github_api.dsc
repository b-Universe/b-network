github_api_task:
  type: task
  debug: true
  script:
    - inject web_debug.web_request
    - define data <util.parse_yaml[<context.body>].if_null[null]>
    - if !<[data].is_truthy>:
      - announce to_console "<&c>context.body conversion invaild<&co> <&b><context.body.if_null[invalid]>"
      - stop

    - define action <[data.action].if_null[<[headers].get[X-github-event].first>]>

    - choose <[action]>:
      - case default:
        - discordmessage id:c channel:901618453746712664 "<&lt>@194619362223718400<&gt> Reference this hook<&co> <util.time_now>"
        - stop

      - case push:
        - if !<[data].contains[commits]>:
          - discordmessage id:c channel:901618453746712664 "<&lt>@194619362223718400<&gt> Reference this hook<&co> <util.time_now>"
          - stop

        - definemap embed_data:
            color: <color[0,254,255]>
            author_name: <[data.sender.login]>
            author_url: <[data.sender.html_url]>
            author_icon_url: <[data.sender.avatar_url]>
            title: "`[<[data.repository.name]>]` | <[data.commits].size.proc[commit_count_format]>"
            title_url: <[data.repository.html_url]>
            thumbnail: https://cdn.discordapp.com/attachments/901618453746712665/911062223244374046/unknown.png

        - define description <list>
        - define hash <[data.head_commit.id].substring[0,7]>
        - define url <[data.head_commit.url]>
        - define hash_link <&lb>`<&lb><[hash]><&rb>`<&rb>(<[url]>)
        - foreach <[data].get[commits]> as:commit:
          - flag server test2:<[commit]>
          - define message <[commit.message]>
          - define line "- **<[hash_link]>** <[message]>"
          - define description <[description].include_single[<[line]>]>
        - define embed_data.description <[description].separated_by[<n>]>
        - narrate <[embed_data]>
        - discordmessage id:c channel:901618453746712664 <discord_embed[<[embed_data]>]>
        - stop

      - case created:
        - if !<[data].contains[repository]>:
          - discordmessage id:c channel:901618453746712664 "<&lt>@194619362223718400<&gt> Reference this hook<&co> <util.time_now>"
          - stop

        - definemap embed_data:
            color: <color[0,254,255]>
            author_name: <[data.sender.login]>
            author_url: <[data.sender.html_url]>
            author_icon_url: <[data.sender.avatar_url]>
            title_url: <[data.repository.html_url]>
            thumbnail: https://cdn.discordapp.com/attachments/901618453746712665/911062223244374046/unknown.png

        - define description <list_single[<[data.repository.description]>]>
        - if <[data.repository.fork]>:
          - ~webget <[data.repository.url]> save:response
          - define response <entry[response].result.parse_yaml.if_null[null]>
          - if !<entry[response].failed> && <[response].is_truthy>:
            - define embed_data.author_name <[response.source.owner.login]>
            - define embed_data.author_url <[response.source.owner.html_url]>
            - define embed_data.author_icon_url <[response.source.owner.avatar_url]>

          - define embed_data.title "`[<[data.repository.name]>]` Fork Created"
        - else:
          - discordmessage id:c channel:901618453746712664 "<&lt>@194619362223718400<&gt> Reference this hook<&co> <util.time_now>"
          - stop

        - define embed_data.description <[description].separated_by[<n>]>
        - narrate <[embed_data]>
        - discordmessage id:c channel:901618453746712664 <discord_embed[<[embed_data]>]>
        - stop

commit_count_format:
  type: procedure
  definitions: int
  script:
    - if <[int]> > 1:
      - determine "<[int]> new commits"
    - else:
      - determine "<[int]> new commit"
