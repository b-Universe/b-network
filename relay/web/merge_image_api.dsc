merge_image_api_task:
  type: task
  script:
    - define data <context.body.parse_yaml>
    - define headers <context.headers>
    - define combine_api_url http://localhost:8000/api/v1.0/merge-image

    - ~webget <[combine_api_url]> data:<[data].to_json> headers:<[headers]> save:response
    - if <entry[response].failed>:
      - definemap response:
          message: The API failed for... some reason.
          reason: failed
      - determine passively code:400
      - inject web_debug.webget_response
      - determine raw_text_content:<[response].to_json>

    - else:
      - determine passively code:400
      - narrate <n><entry[result_headers].to_yaml>
