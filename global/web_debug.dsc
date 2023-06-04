web_debug:
  type: task
  debug: false
  script:
    - announce "<&e>Web debug is<&6><&co> <&a><server.has_flag[behr.developmental.debugging]>"
    - ~webget http://api.behr.dev save:response
    - announce "<&e>API endpoint is<&6><&co> <&a><entry[response].failed>"
    - inject web_debug.webget_response

  webget_response:
    - define content <list_single[<n>]>
    - define content <[content].include_single[<&3>-- <queue.script.name||invalid> - WebGet_Response ------]>
    - define content <[content].include_single[<&6><&lt><&e>entry<&6>[<&e>response<&6>].<&e>failed<&6><&gt> <&b>| <&3><entry[response].failed||<&c>Invalid> <&b>| <&a>returns whether the webget failed. A failure occurs when the status is no...]>
    - define content <[content].include_single[<&6><&lt><&e>entry<&6>[<&e>response<&6>].<&e>result<&6><&gt> <&b>| <&3><entry[response].result||<&c>Invalid> <&b>| <&a>returns the result of the webget. This is null only if webget failed to connect to the url.]>
    - define content <[content].include_single[<&6><&lt><&e>entry<&6>[<&e>response<&6>].<&e>status<&6><&gt> <&b>| <&3><entry[response].status||<&c>Invalid> <&b>| <&a>returns the HTTP status code of the webget. This is null only if webget failed to connect to the url.]>
    - define content <[content].include_single[<&6><&lt><&e>entry<&6>[<&e>response<&6>].<&e>time_ran<&6><&gt> <&b>| <&3><entry[response].time_ran||<&c>Invalid> <&b>| <&a>returns a DurationTag indicating how long the web connection processing took.]>
    - define content <[content].include_single[<&6><&lt><&e>entry<&6>[<&e>response<&6>].<&e>result_headers<&6><&gt> <&b>| <&3><entry[response].result_headers.to_yaml.replace_text[-].with[<&e>- <&3>].replace_text[<&co>].with[<&e><&co> <&3>]||<&c>Invalid> <&b>| <&a>returns a MapTag of the headers returned from the webserver. Every value in the result is a list.]>
    - define content <[content].include_single[<&3>----------------------------------------------]>
    - narrate <[content].separated_by[<n>]>

  web_request:
    - define content <list_single[<n>]>
    - define content <[content].include_single[<dark_purple>__________________________________________________________________________]>
    - define content <[content].include_single[<&6><&lt>context<&6>.<&e>method<&6><&gt> <&b>| <&3><context.method.if_null[<&c>invalid]> <&b>| <&a>returns the method that was used (such as GET or POST).]>
    - define content <[content].include_single[<&6><&lt>context<&6>.<&e>path<&6><&gt> <&b>| <&3><context.path.if_null[<&c>invalid]> <&b>| <&a>returns the path requested (such as "/index.html").]>
    - define content <[content].include_single[<&6><&lt>context<&6>.<&e>port<&6><&gt> <&b>| <&3><context.port.if_null[<&c>invalid]> <&b>| <&a>returns the port connected to.]>
    - define content <[content].include_single[<&6><&lt>context<&6>.<&e>remote_address<&6><&gt> <&b>| <&3><context.remote_address.if_null[<&c>invalid]> <&b>| <&a>returns the IP address that connected.]>
    - define content <[content].include_single[<&6><&lt>context<&6>.<&e>query<&6><&gt> <&b>| <&3><context.query.to_yaml.if_null[<&c>invalid]> <&b>| <&a>returns a MapTag of the query data (if no query, returns empty map).]>
    - define content <[content].include_single[<&6><&lt>context<&6>.<&e>raw_query<&6><&gt> <&b>| <&3><context.raw_query.if_null[<&c>invalid]> <&b>| <&a>returns the raw query input (if no query, returns null).]>
    - define content <[content].include_single[<&6><&lt>context<&6>.<&e>raw_user_info<&6><&gt> <&b>| <&3><context.raw_user_info.if_null[<&c>invalid]> <&b>| <&a>returns the raw user info input (if any) (this is a historical HTTP system that allows sending username/password over query).]>
    - define content <[content].include_single[<&6><&lt>context<&6>.<&e>headers<&6><&gt> <&b>|<n><&3><context.headers.to_yaml.replace_text[-].with[<&e>- <&3>].replace_text[<&co>].with[<&e><&co> <&3>].if_null[<&c>invalid]> <&b>| <&a>returns a MapTag of all input headers, where the key is the header name and the value is a ListTag of header values for that name.]>
    - define content <[content].include_single[<&6><&lt>context<&6>.<&e>body<&6><&gt> <&b>| <&3><context.body.if_null[<&c>invalid]> <&b>| <&a>returns the text content of the body that was sent, if any. Particularly for POST requests.]>
    #- announce to_console "<&6><&lt>context<&6>.<&e>body_binary<&6><&gt> <&b>| <&3><context.body_binary.if_null[<&c>invalid]> <&b>| <&a>returns the raw binary content body that was sent, if any. Particularly for POST requests."
    - define content <[content].include_single[<&6><&lt>context<&6>.<&e>has_response<&6><&gt> <&b>| <&3><context.has_response.if_null[<&c>invalid]> <&b>| <&a>returns true if a response body determination (raw_text_content, file, or cached_file) was applied, or false if not.]>
    - narrate <[content].separated_by[<n>]>
