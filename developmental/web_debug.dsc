web_debug:
  type: task
  debug: false
  script:
    - announce "<&e>Web debug is<&6><&co> <&a><server.has_flag[behr.developmental.debugging]>"
    - ~webget https://api.behr.dev/status save:response

    - if <entry[response].failed>:
      - announce "<&e>API endpoint status<&6><&co> <&a>Online"
    - else:
      - announce "<&e>API endpoint status<&6><&co> <&c>Offline"

    - inject web_debug.webget_response if:<server.has_flag[behr.developmental.debugging]>

  webget_response:
    - define content <list_single[<n>]>
    - define content <[content].include_single[<&3>-- <queue.script.name||<&c>invalid> <&3>- WebGet_Response ------]>
    - define content <[content].include_single[<&6><&lt><&e>entry<&6>[<&e>response<&6>].<&e>failed<&6><&gt> <&b>| <&3><entry[response].failed||<&c>Invalid> <&b>| <&a>returns whether the webget failed. A failure occurs when the status is no...]>
    - define content <[content].include_single[<&6><&lt><&e>entry<&6>[<&e>response<&6>].<&e>result<&6><&gt> <&b>| <&3><entry[response].result||<&c>Invalid> <&b>| <&a>returns the result of the webget. This is null only if webget failed to connect to the url.]>
    - define content <[content].include_single[<&6><&lt><&e>entry<&6>[<&e>response<&6>].<&e>status<&6><&gt> <&b>| <&3><entry[response].status||<&c>Invalid> <&b>| <&a>returns the HTTP status code of the webget. This is null only if webget failed to connect to the url.]>
    - define content <[content].include_single[<&6><&lt><&e>entry<&6>[<&e>response<&6>].<&e>time_ran<&6><&gt> <&b>| <&3><entry[response].time_ran||<&c>Invalid> <&b>| <&a>returns a DurationTag indicating how long the web connection processing took.]>
    - define content <[content].include_single[<&6><&lt><&e>entry<&6>[<&e>response<&6>].<&e>result_headers<&6><&gt> <&b>| <&3><entry[response].result_headers.proc[web_header_formatting].if_null[<&c>invalid]> <&b>| <&a>returns a MapTag of the headers returned from the webserver. Every value in the result is a list.]>
    - define content <[content].include_single[<&3>----------------------------------------------]>
    - announce to_console <[content].separated_by[<n>]>

  web_request:
    - define content <list_single[<n>]>
    - define content <[content].include_single[<dark_purple>__________________________________________________________________________]>
    - define content <[content].include_single[<&6><&lt>context<&6>.<&e>method<&6><&gt> <&b>| <&3><context.method.if_null[<&c>invalid]> <&b>| <&a>returns the method that was used (such as GET or POST).]>
    - define content <[content].include_single[<&6><&lt>context<&6>.<&e>path<&6><&gt> <&b>| <&3><context.path.if_null[<&c>invalid]> <&b>| <&a>returns the path requested (such as <&dq>/index.html<&dq>).]>
    - define content <[content].include_single[<&6><&lt>context<&6>.<&e>port<&6><&gt> <&b>| <&3><context.port.if_null[<&c>invalid]> <&b>| <&a>returns the port connected to.]>
    - define content <[content].include_single[<&6><&lt>context<&6>.<&e>remote_address<&6><&gt> <&b>| <&3><context.remote_address.if_null[<&c>invalid]> <&b>| <&a>returns the IP address that connected.]>
    - define content <[content].include_single[<&6><&lt>context<&6>.<&e>query<&6><&gt> <&b>| <&3><context.query.to_yaml.replace_text[- ].with[<&e>- <&3>].replace_text[<&co>].with[<&e><&co> <&3>].if_null[<&c>invalid]> <&b>| <&a>returns a MapTag of the query data (if no query, returns empty map).]>
    - define content <[content].include_single[<&6><&lt>context<&6>.<&e>raw_query<&6><&gt> <&b>| <&3><context.raw_query.if_null[<&c>invalid]> <&b>| <&a>returns the raw query input (if no query, returns null).]>
    - define content <[content].include_single[<&6><&lt>context<&6>.<&e>raw_user_info<&6><&gt> <&b>| <&3><context.raw_user_info.if_null[<&c>invalid]> <&b>| <&a>returns the raw user info input (if any) (this is a historical HTTP system that allows sending username/password over query).]>
    - define content <[content].include_single[<&6><&lt>context<&6>.<&e>headers<&6><&gt> <&b>|<n><&3><context.headers.proc[web_header_formatting].if_null[<&c>invalid]> <&b>| <&a>returns a MapTag of all input headers, where the key is the header name and the value is a ListTag of header values for that name.]>
    - define content <[content].include_single[<&6><&lt>context<&6>.<&e>body<&6><&gt> <&b>| <&3><context.body.if_null[<&c>invalid]> <&b>| <&a>returns the text content of the body that was sent, if any. Particularly for POST requests.]>
    - define uuid <util.random.duuid>
    - define content <[content].include_single[<&e>Saved as<&6><&co> <&a>behr<&2>.<&a>web<&2>.<&a>requests<&2>.<&a><[uuid]><&2>.<&a>body]>
    - flag server behr.web.requests.<[uuid]>.body:<context.body> expire:1d

    #- announce to_console "<&6><&lt>context<&6>.<&e>body_binary<&6><&gt> <&b>| <&3><context.body_binary.if_null[<&c>invalid]> <&b>| <&a>returns the raw binary content body that was sent, if any. Particularly for POST requests."
    - define content <[content].include_single[<&6><&lt>context<&6>.<&e>has_response<&6><&gt> <&b>| <&3><context.has_response.if_null[<&c>invalid]> <&b>| <&a>returns true if a response body determination (raw_text_content, file, or cached_file) was applied, or false if not.]>
    - announce to_console <[content].separated_by[<n>]>

web_header_formatting:
  type: procedure
  definitions: headers
  debug: false
  script:
    - if !<[headers].if_null[null].is_truthy>:
      - determine <&c>invalid

    - define formatted_headers <list>
    - foreach <[headers]> key:header as:values:
      - if <[values].size> == 1:
        - define formatted_headers <[formatted_headers].include_single[<&3><[header]><&e><&co> <&3><[values].unseparated>]>
      - else:
        - define formatted_headers <[formatted_headers].include_single[<&3><[header]><&e><&co><n><&e>- <&3><[values].separated_by[<n><&e>- <&3>]>]>

    - determine <[formatted_headers].separated_by[<n>]>
