# **Contributing to B**

Thanks for taking the time to contribute to the projects here. Whether it's just reporting a bug or adding something huge for the community, all levels of contribution are appreciated. It wouldn't be where we go without the people. This guide is made to establish good guidelines for consistency in code to follow when contributing, not rules. Feel free to ask questions if you need clarity; no question is a bad question if it's at all helpful to someone. It's primarily asked that you use your best judgement and common sense when working with B.

---

## 🌮 **Table of Contents** 🌮

- [`[Intro]`](https://github.com/bUniverse/b-network/blob/master/contributing.md#intro)
  - [`[Questions]`](https://github.com/bUniverse/b-network/blob/master/contributing.md#questions)
  - [`[Code of Conduct]`](https://github.com/bUniverse/b-network/blob/master/contributing.md#Code&20of&20Conduct)
- [`[What to know before getting started]`](https://github.com/bUniverse/b-network/blob/master/contributing.md#What&20to&20know&20before&20getting&20started)
  - [`[Repositories and URLs]`](https://github.com/bUniverse/b-network/blob/master/contributing.md#)
  - [`[Design Decisions]`](https://github.com/bUniverse/b-network/blob/master/contributing.md#)
- [`[How can I contribute?]`](https://github.com/bUniverse/b-network/blob/master/contributing.md#)
  - [`[Reporting bugs]`](https://github.com/bUniverse/b-network/blob/master/contributing.md#)

--- 

  - [`[Suggesting enhancements]`](https://github.com/bUniverse/b-network/blob/master/contributing.md#)
  - [`[Your first code contribution]`](https://github.com/bUniverse/b-network/blob/master/contributing.md#)
  - [`[Issues]`](https://github.com/bUniverse/b-network/blob/master/contributing.md#)
  - [`[Pull requests]`](https://github.com/bUniverse/b-network/blob/master/contributing.md#)
- [`[Styleguides]`](https://github.com/bUniverse/b-network/blob/master/contributing.md#)
  - [`[Grammar and verbiage]`](https://github.com/bUniverse/b-network/blob/master/contributing.md#)
  - [`[Git commit messages]`](https://github.com/bUniverse/b-network/blob/master/contributing.md#)
  - [`[Documentation styleguide]`](https://github.com/bUniverse/b-network/blob/master/contributing.md#)
- [`[Additional notes]`](https://github.com/bUniverse/b-network/blob/master/contributing.md#)
  - [`[Issue and pull request labels]`](https://github.com/bUniverse/b-network/blob/master/contributing.md#)


---

- [`[Footnotes]`](https://github.com/bUniverse/b-network/blob/master/contributing.md#footnotes) - Notated through this document contains noted<sup>🌮(#)</sup> relevant information down here!

<!--

placeholder note: https://github.com/bUniverse/b-network/blob/master/contributing.md#
  - [`[]`]()

 -->
---

## **Intro | Basic information first!**

### **Questions**

The projects within this organization and the repository sites are made for productive content. If you only have general inqueries or questions, we ask that you directly communicate on the [`[Discord]`](https://behr.dev/Discord). Issues that do not productively contribute to the project will be closed, ignored, or asked for clarification.

### **Code of Conduct**

For all code implemention, please make sure this is your own work that you would like to be donated fully to B. While notating that this is a donation, it should be fully transparent that this code is also available to the public in it's fullest for the best benefit of the Minecraft community. In the case that someone has asked you, or you are someone requesting a current active contributor to implement your contribution, we ask that who-ever has created the content to contribute this themselves from their own GitHub account. As mentioned in the intro, please don't be afraid to ask if not knowing how prevents you from contributing.

While crediting yourself is not necessary, any contribution efforts will absolutely be made if you'd like the Minecraft community who learned anything or was influenced and inspired by your content know who you are. 

Content must verifiably be functional, or be evident that it would work. Testing is the best way to verify that something you've made works; Avoid evidence such as "this works perfectly <[Here]>, and it perfectly follows working syntax!". A good rule of thumb is that if you can provide evidence (eg, a screenshot or a video) of the feature working, you likely won't be questioned whether or not you've tested this. That adequate time to thuroughly verify your content works; Even a single active developer for a scripting language that they primarily coordinate the design and function for will typically cross-reference their documentation and meta for content when working with their own language. If you need help, ask for a friend on B!

Lastly, while this guide is meant to be guideline for contribution, abiding consistent code styles within the code here will eliminate confusion of functionality and formatting of scripts. As this is supposed to benefit the community of Minecraft as well as B, by no means obfuscate any content. If you don't want to share or help others, don't offer to donate some of it.<sup>🌮1</sup>

---

## **What to know before getting started**

### **Repositories and URLs**

- [`[B-Universe]`](https://github.com/b-Universe) - The organization repository
  - [`[B-Network]`](https://github.com/b-Universe/b-network) - The repository for everything that doesn't belong in the datapack or resource pack 
  - [`[B-Resource]`](https://github.com/b-Universe/b-resource) - The repository for all resource-pack related content
  - [`[B-Datapack]`](https://github.com/b-Universe/b-datapack) - The repository for all data-pack related content
- [`[metacognition]`](https://github.com/b-Universe/b-network/blob/main/metacognition.md) - Documentation on permissions, flags, and other scripting data
- [`[https://api.behr.dev]`](https://api.behr.dev/) - The B API is the endpoint used for all endpoints targeting the B network<sup>🌮2</sup>
- [`[https://behr.dev]`](https://behr.dev) The homepage to B's network<sup>🌮3</sup>
- [`[Leveling Dashboard]`](https://stat.icecapa.de/grafana/public-dashboards/90a220f38928488a8a091d7f377b4548?orgId=1) - The IceBear Leveling Dashboard for B - designed by Icecapade!

### **Design Decisions**

When making a significant decision in how to maintain the projects and what we can or cannot support, we should document it in the [`[metacognition]`](https://github.com/b-Universe/b-network/blob/main/metacognition.md). Things like flags, sub-flags, "permissions"<sup>🌮4</sup>, and commands should be consistent in notating their names, descriptions, and optimally usage. If you have a question about how to be consistent, check to see if anything relevant may exist. If it is not documented there, asking in our [`[Development]`](https://discord.com/channels/901618453356630046/901618453746712656) Discord channel is probably the fastest way to determine how to document it. Else-wise, utilizing your best common sense and judgement will always be appreciated.

---

## **How can I contribute?**

### **Reporting bugs**

This section guiides you through submitting bug reports. Following these guidelines helps maintainers and the community understand your report, verifiably replicate the issue if possible, and/or find related reports.

Before creating a bug report, Verify against [`[this check-list]`](https://github.com/bUniverse/b-network/blob/master/contributing.md#Before%20submitting%20a%20bug%20report) to determine the type of bug this is. If this happens because you did something you noticed would explicitly fail to work properly, it's more appreciated to reference and indicate this bug before performing it and causing damage. Malicious intent is never helpful.

### **Before submitting a bug report**

Both check and reference syntax, meta, and any documentation:

- If the root cause is because of something such as \[\[uneven brackets] for example, we can indicate the syntax is being broken.
- If the meta indicates usage is not valid, is not documented, or is purely made up, this may be an indicator this is a valid bug.
- If the documentation explicitly states something should be used differently or it is not documented at all, this could indicate the problem was over-looked when we wrote it.
Verify script names, definition names, and flags used within scripts or files.
- For scripts, we can simply verify a script is both valid and exists, or is being used properly:
  - The script referenced for `run` or `inject` commands both exist and are used correctly.
  - Script definitions are at least truthy when attempted to use or will always function as needed.
  - Flags exist when referenced unless checking to see if they exist first or are at least truthy.
  - Flags are being used correctly (eg, a flag formatted as a [`[MapTag]`](https://meta.denizenscript.com/Docs/ObjectTypes/map#maptag) is being used as MapTag and not as some other object).
- For resource pack files, we can cross-reference the appropriate texture and model file references to verify:
  - The file is formatted correctly (ie, lowercase-only filenames, correct extension(s)).
  - The referenced model or texture file exists.
  - The files referenced are appropriately targeted in the resource pack atlas.
- For all other language files that utilize \<tag>opening and closing tags<\tag>, that they are correctly closed.

--- 

### **Suggesting enhancements**

#### The Open-Ended Approach

We welcome any ideas you have for improving this project! Whether it's a new feature, a bug fix, or a documentation tweak, we're happy to hear your thoughts. Feel free to open an issue and describe your suggestion in detail. We'll discuss it with the community and see if it aligns with our vision for the project.

#### Specific Categories
If you have a cool idea for a new feature or improvement, we'd love to hear it! Here are some areas where we're particularly interested in suggestions:

- Feature enhancements: Can you think of ways to make existing features more powerful or user-friendly?
- Performance improvements: Do you have ideas for optimizing the code or reducing memory usage?
- Documentation improvements: Can you spot any outdated or unclear information in the docs?
- Accessibility considerations: Can we make the project more accessible to users with disabilities?
- Other: (Share any other specific areas you'd like suggestions for)

#### Provide Prompts
Have you ever wished the project could do X? Or thought it would be awesome if it had Y? Share your "dream features" with us! Even if they seem outlandish, we appreciate your feedback and it might spark inspiration for a new direction.

### **Your first code contribution**
Explore the codebase to familiarize yourself with the project's structure and conventions. As referenced above in the [**What to know before getting started: Repositories and URLs**] section, different categories of the codebase may suit your expertise or interest more specifically than others. If you own significant experience and knowledge in a category, you can emphasis this by sharing what youve contributed to or have made. Otherwise, there's no shame in expressing a lack of experience when there's the interest to learn another! Do keep in mind you're welcome to check out any existing issues for tasks that might be a good fit for your skills and interests, or even to ask for guidance in the discussions or reach out to maintainers. 

<!-- 
### **Issues**
When creating issues, follow the templates in place.

<!--- Delete Inapplicable/Unnecessary Sections                            --->
<!--- Text wrapped in arrow-tags are Notes and may be deleted --->
<!--- If you haven't already, please review our Contribution Section's write-up on Feature Requests Here: <link to literally this contributing guide>

> **Describe the feature**:
<!--- This is key for you to differentiate between people that have deeply thought about what you're requesting, or what this will solve for users versus those that are just in love with their idea. 


> **Command Syntax**
<!--- Specify the exact usage this command would be used as well as what the command would do. Additionally, specify each sub-command / argument's usage if applicable.


> **Miscellaneous Arguments**
<!--- Specify any non-pertinent or miscellaneous features that would be either helpful or not explicitly related to the commands direct usage - such as: `/dcommand Help` | Would display a helpful syntax with explaination of usage and syntax of the command and it's sub-commands / arguments.


> **Command Flags**
<!--- Similar to arguments, specify flags (optimally with short-hands available) to change the outcome of data or information returned, if applicable.


> **Features to Implement**
<!--- Specific features that would be required to make this command work, if you are familiar with them.


> **Resources Needed**
<!--- If you are aware of specific conditions or features that we do not have access to, specify them here in a checklist formatted like this:
- [ ] To-Do | We need this because it's to-do.
This is not referring to scripts needed to be written in Denizen, but only explicitly features we do not currently have access to presently.

<!--- Remove any sections that don't apply or you have inadequate information for.
> **Describe the bug**:
<!--- A clear and concise description of what the bug is.


> **How To Reproduce**:
<!--- Provide how to reproduce the issue, or explain how you found it
Example:
Steps to reproduce the behavior:
1. Go to '...'
2. Click on '....'
3. Scroll down to '....'
4. See error


> **Expected behavior**:
<!--- A clear and concise description of what you expected to happen.


> **Screenshots**:
<!--- If applicable, add screenshots to help explain your problem.


> **Additional context**:
<!--- Add any other context about the problem here.

<!--- Delete Inapplicable/Unnecessary Sections                            --->
<!--- Text wrapped in arrow-tags are Notes and may be deleted --->
<!--- If you haven't already, please review our Contribution Section's write-up on Feature Requests Here:
<this page, again>
> **The Type of request**:
<!--- describe if this a one-off feature or a series of features


> **Who is requesting this**:
<!--- Identify yourself and who you represent, so that you can easily follow up with them as a major contributing producer to the idea.


> **Describe the feature**:
<!--- This is key for you to differentiate between people that have deeply thought about what you're requesting, or what this will solve for users versus those that are just in love with their idea.


> **Describe the impact**: 
<!--- Articulate how solving this problem will make yours and the other player’s life better. You can add impact categories that matter to you to ensure consistency.


> **Describe the reach of this feature**:
<!--- You could describe how many users will be positively impacted or leverage this feature.


> **Describe the cost of not doing this request**: 
<!--- Describe the problems that would occur if this need was not addressed. To ensure consistency add categories that matter to us such as happier players, or adequate equality of other existing features or mechanics of the game.


> **Describe which goals this helps**: 
<!--- Enumerate our current goals and tie the feature to it - Expansion and dynamistic game-play is key for an awesome player-base and game-play environment.


> **Describe the evidence that you have on the need for this request**: 
<!--- Validation of user problem and desired outcome is statistically(no pun intended) the only way to argue with me if you believe I wouldn't agree else-wise.


> **Describe if you have any ideas on how we may solve this**: 
<!--- Giving the space to help and suggest ideas are great for creating structural or dynamic features, mini-games and commands.


> **Describe how urgent this is and why**: 
<!--- Explain the space to give insight into the urgency of this issue and why.


### **Pull requests**
-->
---

## **Styleguides**

To ensure readability, maintainability, and collaboration, we've established style guidelines for our code. Please follow these conventions when contributing:

### Key Principles:

- Readability First: Code should be clear and easy to understand for both current and future contributors
- Consistency is Key: Maintain a uniform style throughout the codebase for a cohesive experience
- Standards for Clarity: Adhere to established conventions for formatting, naming, and structures

### Specific Guidelines:

Indentation:
- Use 2 spaces for indentation
- Align code blocks consistently and make any attempt to maintain minimal indentation as much as possible throughout code

Whitespace:
Always include a NLAEOF (Newline At End Of File). This isn't for compatibility reasons, but eliminates some files having it and others not. Some users who have settings configured for managing other languages may have this configured to by default include this, which can result in their modification in a file including this insignificant addition to the file in a difference report.

Variable Naming:
- For definitions and flag names:
  - prefer snake_case
  - use literal and specific terminology (eg: `material_name` when specifically referencing a material's name, and `material` for a `MaterialTag` object that could contain a material's name and/or other properties)
- For arguments and constants, prefer lowercase over UPPERCASE enum definitions

Error Handling:
Use the following standardized error-handling structure:
Prefer any condition checking format combination(s):
- `if (!)<[condition]>:`
  - don't use the `.not` subtag<sup>🌮5</sup>
- `if <[thing]> (!)in <[list]>:`
  - avoid the `contains[]` and `.contains_any[]` subtags<sup>🌮5</sup>
- `if <[thing]> (!)matches/==/!= <[another_thing]>:`
  - don't use the `.equals`/`does_not_equal[]` tags<sup>🌮5</sup>
  - avoid the `is_more_than[]`/`is_less_than[]` comparison type subtags<sup>🌮5</sup>

If a condition can stop a script entirely, use it as a stepping stone. Prefer providing a reason why the condition failed:
```yml
- if <[condition]>:
  - define reason "This condition should be X, or needs to be any of X, Y, and Z"
  - inject command_error
```

Otherwise, use the `command_syntax_error` script injection to provide the syntax as a reason-less error response:
```yml
- inject command_syntax_error if:<[condition]>
```

Player Input:

Expect the unexpected and protect code from player shenanigans. Never underestimate the ingenuity of players to break things. Here's how to gracefully handle player input in commands in some instances:

Numbers and Decimals:
- Use strict type checking to ensure input is actually a number; if a decimal is valid, verify `<[input].is_decimal>` - otherwise, verify `<[input].is_integer>`.
- Define acceptable ranges or precision limits for both integers and decimals
- Anticipate unusual decimal inputs like `1.000009` or `.0001`; Decide whether to round, truncate, or reject such values based on gameplay context
- Inform players of invalid input with specific error messages, guiding them towards correct usage

Player Names:
For online players, pre-define player names under the `player_name` definition and inject the `command_online_player_verification` for online players and `command_player_verification` for all other players if the command should not run if the player name is not a full valid player. This defines the player as `<[player]>` to be used later in scripts.

Example:
```yml
# Check the command usage /command <player_name>
- define player_name <context.args.first>
- inject command_online_player_verification
- teleport <[player]> <[location]>
- narrate "<&e><[player_name]> <&a>was teleported!"
```
And secondly, note whether or not the player is specifying themselves, if applicable. Verbiage in narration is nice to be fluent to the intended viewer.

Example:
```yml
# Tell the player(s) what happened
- if <[player]> != <player>:
  - narrate "<&e><[player_name]> <&a>was healed" targets:<player>
- narrate "<&a>You were healed" targets:<[player]>
```

### **Grammar and verbiage**

 Prioritize short, impactful statements over complete sentences when conveying clear error messages. Omit periods in contexts where their absence enhances clarity and brevity. Examples like "<[player]> isn't a valid player online," "Number can't be negative," or "<[world]> not loaded or doesn't exist" effectively deliver the message without superfluous phrasing. This approach helps users quickly grasp the issue while minimizing visual clutter in code and documentation. Remember, less is often more when it comes to effective error communication.

### **Git commit messages**

Similar to grammar and verbiage use in scripts, prioritize brevity and clarity. Write commit messages that succinctly describe the changes made, keeping them as concise as possible while still conveying the essential information. In most cases, omit periods at the end of commit message lines to enhance readability and maintain a consistent style.

Refrain from using symbols like # and @ to reference users, issues, or pull requests within commit messages. Instead, provide clear descriptions of the changes without relying on external references (unless explicitly targeting an issue you're engaging in with this commit)

Time travel's off-limits here (You know who you are, you time traveling wizards!)! Commit messages recount the present, a chronicle of changes freshly forged. Embrace the active voice – let verbs like "add", "fix", and "update" shine. "Added" and "fixed" belong to dusty tomes, leaving our history crisp and clear, each commit a snapshot of progress, forever vibrant.

And lastly, utilize consistent verbiage for specific types of changes, such as "consistency updates" for modifications aimed at aligning code with existing codebase conventions.

Examples:
Good: "Add player health display"
Good: "Fix negative number error"
Better: "Prevent negative number input"
Good: "Consistency updates in player movement scripts"
Write commit messages in the present tense and imperative mood (eg: "Add feature" not "Added feature").
Wrap lines at 72 characters - longer detailed messages, documentation, or explainations belong in pull requests, issues, and referencable discussions.

### **Documentation styleguide**

Reference the current [`[metacognition]`](https://github.com/b-Universe/b-network/blob/main/metacognition.md) documentation; Verify that the table input matches current use and that it's documented similarly to the previous documentation.

---

#### **Footnotes**:
- <sup>🌮1</sup> `Regarding obfuscation`**`:`** This excludes explicitly secret information like client tokens, oAuth keys, passwords, etc.
- <sup>🌮2</sup> `The B API`**`:`** This endpoint will always require explicit authorization to be used.
- <sup>🌮3</sup> `The `<u>`https://Behr.dev`</u>` homepage`**`:`** At the time of writing this, the site is an orphan and does not have a home page yet.
- <sup>🌮4</sup> `Permissions`**`:`** B does not implement literal bukkit permissions. There is the occasional use of operator, but permissions are truly just flags.
- <sup>🌮5</sup> `Subtags`**`:`** Excluding within `filter[]` and `filter_tag[]` tags
  <!-- below is drafted placeholders
- <sup>🌮6</sup> `header`**`:`** text
- <sup>🌮7</sup> `header`**`:`** text
- <sup>🌮8</sup> `header`**`:`** text
- <sup>🌮9</sup> `header`**`:`** text
- <sup>🌮10</sup> `header`**`:`** text
 -->
