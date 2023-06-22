404_page:
  type: task
  debug: true
  script:
    # % ██ [ standard definitions               ] ██:
    - determine passively code:200
    - definemap headers:
        Content-Type: text/html
        charset: utf-8
        #Cache-Control: max-age=86400
        Cache-Control: max-age=1
        X-Content-Type-Options: nosniff
    - define /a <&lt>/a<&gt>
    - define /div <&lt>/div<&gt>
    - define br/ <&lt>br/<&gt>
    - define active_dropdown_pages <map>

    - determine headers:<[headers]> passively


    # % ██ [ create the body and content-header ] ██:
    - define data.body <list_single[<&lt>div class=<&dq>body<&dq><&gt>]>
    - define data.body <[data.body].include_single[<&lt>div class=<&dq>content-header<&dq><&gt>]>


    # % ██ [ set the background                 ] ██:
    - define data.body <script[site_data].parsed_key[global.body]>

    # % ██ [ create the navbar                  ] ██:
    - define data.body <[data.body].include_single[<&lt>div class=<&dq>navbar<&dq><&gt>]>

    # % ██ [ create the buttons                 ] ██:
    - define pages <script[site_data].parsed_key[global.pages]>
    - foreach <[pages]> key:page_name as:page:
      # % ██ [ add normal button                ] ██:
      - if !<[page].contains[dropdown]>:
        - define data.body <[data.body].include_single[<&lt>a href=<&dq><[page.site]><&dq><&gt><[page_name].to_titlecase><[/a]>]>

      # % ██ [ add button with dropdown         ] ██:
      - else:
        #- define data.body <[data.body].include_single[<&lt>a href=<&dq><[page.site]><&dq><&gt><[page_name]><[/a]>]>
        - define data.body <[data.body].include_single[<&lt>div class=<&dq>dropdown<&dq><&gt>]>

        # % ██ [ create the button                  ] ██:
        - define data.body <[data.body].include_single[<&lt>button class=<&dq>dropbtn<&dq><&gt><[page_name].to_titlecase>]>
        - define data.body <[data.body].include_single[<&lt>i class=<&dq>fa fa-caret-down<&dq><&gt><&lt>/i<&gt>]>
        - define data.body <[data.body].include_single[<&lt>/button<&gt>]>

        # % ██ [ create the dropdown for the button ] ██:
        # % ██ [ header for dropdown                ] ██:
        - define data.body <[data.body].include_single[<&lt>div class=<&dq>dropdown-content<&dq><&gt>]>
        - define data.body <[data.body].include_single[<&lt>div class=<&dq>header<&dq><&gt>]>
        - define data.body <[data.body].include_single[<&lt>h2<&gt><[page_name]> - <[page.description]><&lt>/h2<&gt>]>
        - define data.body <[data.body].include_single[<[/div]>]>

        # % ██ [ create the page's dropdown columns ] ██:
        # % ██ [ todo: move to pages data structure ] ██:
        - define active_categories <list[Minecraft]>
        - define data.body <[data.body].include_single[<&lt>div class=<&dq>row<&dq><&gt>]>
        - repeat 3:
          - foreach <[active_categories]> as:category_name:
            # % ██ [ add to dropdown pages list for references   ] ██:
            - define active_dropdown_pages <[active_dropdown_pages].include[<[page.dropdown]>]>

            # % ██ [ start the column and tab, create the header ] ██:
            - define data.body <[data.body].include_single[<&lt>div class=<&dq>column<&dq><&gt>]>
            - define data.body <[data.body].include_single[<&lt>div class=<&dq>tab<&dq><&gt>]>
            - define category_loop_index <[loop_index]>
            - define data.body <[data.body].include_single[<&lt>h3<&gt><[category_name].to_titlecase><&lt>/h3<&gt>]>

            # % ██ [ create the page's column's page links       ] ██:
            - foreach <[page.dropdown]> key:project_name as:project:
              - define project_loop_index <[loop_index]>

              - define data.body <[data.body].include_single[<&lt>a href=<&dq><[project.site]><&dq><&lt>button class=<&dq>tablinks<&dq> onmouseover=<&dq>openTab(event, <&sq><[project_name].replace_text[ ].with[_]><&sq>)<&dq><&gt><[project_name].replace_text[_].with[ ]>]>
              - define data.body <[data.body].include_single[<&lt>/button<&gt><[/a]>]>

            # % ██ [ close the tab and column                    ] ██:
            - define data.body <[data.body].include_single[<[/div].repeat[2]>]>

        # % ██ [ create the reference image column  ] ██:
        - define data.body <[data.body].include_single[<&lt>div class=<&dq>column_image<&dq><&gt>]>

        #- define active_dropdown_pages <[active_dropdown_pages].filter_tag[<[filter_value].contains[dropdown]>]>
        #- define active_dropdown_pages <[active_dropdown_pages].filter_tag[<[filter_value.dropdown].filter_tag[<[filter_value.categories].shared_contents[<[active_categories]>].is_empty.not>].is_empty.not>]>

        # % ██ [ create the image column hover un-displayed    ] ██:
        - foreach <[active_dropdown_pages]> key:page_name as:page:
          - define data.body <[data.body].include_single[<&lt>div id=<&dq><[page_name].replace_text[ ].with[_]><&dq> class=<&dq>tabcontent<&dq> style=<&dq>display<&co> none<&dq><&gt>]>
          - define data.body <[data.body].include_single[<&lt>h3<&gt> <[page_name]> <&lt>/h3<&gt>]>
          - define data.body <[data.body].include_single[<&lt>div class=<&dq>menu_preview_image<&dq><&gt><[/div]>]>

          - define data.body <[data.body].include_single[<&lt>img src=<&dq><[page.image]><&dq> alt=<&dq>A reference image for the project <[page_name]><&dq> width=<&dq>100<&dq> height=<&dq>100<&dq> <&gt>]>
          - define data.body <[data.body].include_single[<&lt>br<&gt><&lt>br<&gt><[page.description]>]>
          - define data.body <[data.body].include_single[<[/div]>]>

        # % ██ [ close the image column                        ] ██:
        - define data.body <[data.body].include_single[<[/div]>]>

        # % ██ [ close the dropdown, dropdown-content, and row ] ██:
        - define data.body <[data.body].include_single[<[/div].repeat[3]>]>


    # % ██ [ close the row and dropdown           ] ██:
    - define data.body <[data.body].include_single[<[/div].repeat[2]>]>

    # % ██ [ close the navbar                     ] ██:
    - define data.body <[data.body].include_single[<[/div]>]>

    # % ██ [ close the content-header             ] ██:
    - define data.body <[data.body].include_single[<[/div]>]>


    # % ██ [ add the scripts pre-javascript-filed ] ██:
    - define data.body <[data.body].include_single[<&lt>script src=<&dq>js/open_tab.js<&dq><&gt><&lt>/script<&gt>]>

    # % ██ [ close the content ] ██:
    - define data.body <[data.body].include_single[<&lt>div class=<&dq>content<&dq><&gt>]>

    # % ██ [ main content ] ██:
    #- define data.body <[data.body].include_single[<&lt>p class=<&dq>invaders-center<&dq><&gt>Space Invadors destroyed this page! Take revenge on them!]>

    #                                                                                                                                                                                                                                             <&lt>button class=<&dq>custom-btn btn-7<&dq><&gt><&lt>span<&gt>Read More<&lt>/span<&gt><&lt>/button<&gt>
    # old: - define data.body <[data.body].include_single[<&lt>br/<&gt> Use <&lt>span class=<&dq>label label-danger<&dq><&gt>Space<&lt>/span<&gt> to shoot and <&lt>span class=<&dq>label label-danger<&dq><&gt>←<&lt>/span<&gt>&<&ns>160;<&lt>span class=<&dq>label label-danger<&dq><&gt>→<&lt>/span<&gt> to move!&<&ns>160;&<&ns>160;&<&ns>160;<&lt>button class=<&dq>btn btn-default btn-xs<&dq> id=<&dq>restart<&dq><&gt>Restart<&lt>/button<&gt><&lt>/p<&gt>]>
    #- define data.body <[data.body].include_single[<&lt>br/<&gt> Use <&lt>span class=<&dq>label label-danger<&dq><&gt>Space<&lt>/span<&gt> to shoot and <&lt>span class=<&dq>label label-danger<&dq><&gt>←<&lt>/span<&gt>&<&ns>160;<&lt>span class=<&dq>label label-danger<&dq><&gt>→<&lt>/span<&gt> to move!&<&ns>160;&<&ns>160;&<&ns>160;<[br/]><&lt>button class=<&dq>custom-btn btn-7<&dq> id=<&dq>restart<&dq><&gt>Restart<&lt>/button<&gt><&lt>/p<&gt>]>
    - define data.body <[data.body].include_single[<&lt>canvas id=<&dq>space-invaders<&dq><&gt><&lt>/canvas<&gt>]>
    - define data.body <[data.body].include_single[<&lt>script src=<&dq>js/404_invader.js<&dq><&gt><&lt>/script<&gt>]>
    # % ██ [ close the content ] ██:
    - define data.body <[data.body].include_single[<[/div]>]>

    # % ██ [ start the footer ] ██:
    - define data.body <[data.body].include_single[<[/div]>]>

    # % ██ [ close the body and the footer ] ██:
    - define data.body <[data.body].include_single[<[/div]>]>

    - flag server temp.head:<script[site_data].parsed_key[global.header].separated_by[<n>]> expire:1s
    - flag server temp.body:<[data.body].separated_by[<n>]> expire:1s
    - determine parsed_file:index.html
