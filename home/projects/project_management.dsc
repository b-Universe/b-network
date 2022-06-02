project_command:
  type: command
  debug: false
  name: project
  usage: /project
  description: Adds, modifies data for, or removes projects
  permission: behr.essentials.contributor_coordinator
  tab completions:
    1: add|modify|remove|list
  script:
    - if <context.args.is_empty>:
      - narrate "<&c>need to specify an action to handle the project with, the project name, and a description"
      - stop
    - else if <context.args.size> == 1:
      - if <context.args.first> == list:
        - narrate "<&a>Active projects<&co> <gray>(hover for description)<n><&a><server.flag[behr.projects].keys.parse_tag[<[parse_value].on_hover[<server.flag[behr.projects.<[parse_value]>]>]>].separated_by[<&e>, <&a>]>"
      - else:
        - narrate "<&c>Need to specify the project name and a decription"
      - stop
    - else if <context.args.size> == 2:
      - narrate "<&c>Need to specify a short description of the project"
      - stop

    - define project.name <context.args.get[2]>
    - define project.description <context.args.get[3].to[last].space_separated>

    - choose <context.args.first>:
      - case add:
        - if !<server.has_flag[behr.projects.<[project.name]>]>:
          - flag server behr.projects.<[project.name]>:<[project.description]>
          - narrate "<&a><[project.name]> was added as a project with the description<&co><n><&e><[project.description]>"
        - else:
          - narrate "<&c><[project.name]> is already a project added - did you mean to modify it<&sq>s description?"

      - case modify:
        - if <server.has_flag[behr.projects.<[project.name]>]>:
          - flag server behr.projects.<[project.name]>:<[project.descripton]>
          - narrate "<&a><[project.name]> was updated with the description<&co><n><&e><[project.description]>"
        - else:
          - narrate "<&c><[project.name]> is not a valid project saved"

      - case remove:
        - if <server.has_flag[behr.projects.<[project.name]>]>:
          - flag server behr.projects.<[project.name]>:!
          - narrate "<&a><[project.name]> was removed"
        - else:
          - narrate "<&c><[project.name]> is not a valid project saved or was already removed"
