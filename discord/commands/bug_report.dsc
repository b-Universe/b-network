bug_report_command_create:
  type: task
  debug: true
  script:
    - ~discordcommand id:b create name:bug_report "description:Begins a bug report to submit" group:901618453356630046

bug_report_command_handler:
  type: world
  debug: false
  enabled: false
  events:
    on discord slash command name:bug_report group:901618453356630046:
      - definemap rows:
          0:
              0: <discord_text_input.with[id].as[bug_title].with[label].as[A brief title of the 🐞bug✨].with[style].as[short]>
          1:
              1: <discord_text_input.with[id].as[bug_describe].with[label].as[Describe the bug - what's the issue?].with[style].as[paragraph]>
          2:
              2: <discord_text_input.with[id].as[bug_reproduce].with[label].as[How to reproduce - how did you do it?].with[style].as[paragraph]>
          3:
              3: <discord_text_input.with[id].as[bug_expected].with[label].as[Expected Behavior - What did you expect?].with[style].as[paragraph]>
          4:
              4: <discord_text_input.with[id].as[bug_extra].with[label].as[Extra Info - Anything else?].with[style].as[paragraph]>
      - discordmodal interaction:<context.interaction> name:bug_report "title:🐞Bug Report" rows:<[rows]>

    on discord modal submitted group:901618453356630046 name:bug_report:
      - definemap issue_data:
          title: <&lb> 🐞 Bug <&rb> <context.values.get[bug_title]>
          body: <script.parsed_key[data.body_layout].separated_by[<n>]>
          assignees:
            - BehrRiley
          labels:
            - Bork
            - Discord Submission
          #milestone: Number of the milestone to associate the issue with (optional)

      - define url https://api.github.com/repos/b-Universe/b-network/issues
      - definemap headers:
          Authorization: <secret[github_api_token]>
          User-Agent: B
          Content-Type: Application/json
      - ~webget <[url]> data:<[issue_data].to_json> headers:<[headers]> save:response
      - inject web_debug.webget_response

  data:
    body_layout:
      - <&gt> **🐞 Describe the Bug**<&co>
      - <n>
      - <context.values.get[bug_describe]>
      - <n>
      - <&gt> **🔁 How To Reproduce**<&co>
      - <n>
      - <context.values.get[bug_reproduce]>
      - <n>
      - <&gt> **📗 Expected Behavior**<&co>
      - <n>
      - <context.values.get[bug_expected]>
      - <n>
      - <&gt> **📒 Additional context**<&co>
      - <n>
      - <context.values.get[bug_extra]>
      - <n>
      - <&gt> **📒 Submission Data**<&co>
      - - Report submit from `Discord`
      - - submit by `<context.interaction.user.name>` (`<context.interaction.user.id>`)
