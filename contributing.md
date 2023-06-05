# **Contributing to B**

Thanks for taking the time to contribute to the projects here. Whether it's just reporting a bug or adding something huge for the community, all levels of contribution are appreciated. It wouldn't be where we go without the people. This guide is made to establish good guidelines for consistency in code to follow when contributing, not rules. Feel free to ask questions if you need clarity; no question is a bad question if it's at all helpful to someone. It's primarily asked that you use your best judgement and common sense when working with B.

---

## 🌮 **Table of Contents** 🌮

- [`[Intro]`](https://github.com/bUniverse/b-network/blob/master/contributing.md#intro)
  - [`[Questions]`](https://github.com/bUniverse/b-network/blob/master/contributing.md#questions)
  - [`[Code of Conduct]`](https://github.com/bUniverse/b-network/blob/master/contributing.md#Code&20of&20Conduct)
- [`[What to know before getting started]`](https://github.com/bUniverse/b-network/blob/master/contributing.md#What&20to&20know&20before&20getting&20started)
  - [`[Repositories and URLs]`]()
  - [`[Design Decisions]`]()

--- 
> **_NOTE:_** The following is drafted contributing information not-yet written.
  <details>
  <summary> ( Show / Hide ) </summary>

- [`[How can I contribute?]`]()
  - [`[Reporting bugs]`]()
  - [`[Suggesting enhancements]`]()
  - [`[Your first code contribution]`]()
  - [`[Issues]`]()
  - [`[Pull requests]`]()
- [`[Styleguides]`]()
  - [`[Grammar and verbiage]`]()
  - [`[Git commit messages]`]()
  - [`[Specs styleguide]`]()
  - [`[Documentation styleguide]`]()
- [`[Additional notes]`]()
  - [`[Issue and pull request labels]`]()
</details>

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
  - [`[B-Network]`](https://github.com/b-Universe/b-network) - The repository for everything not-resource-pack related content, but specifically related to 
  - [`[B-Resource]`](https://github.com/b-Universe/b-resource) - The repository for all resource-pack related content
- [`[`<u>`https://api.behr.dev`</u>`]`](https://api.behr.dev/) - The B API is the endpoint used for all endpoints targeting the B network<sup>🌮2</sup>
- [`[`<u>`https://behr.dev`</u>`]`](https://behr.dev) The homepage to B's network<sup>🌮3</sup>
- [`[`Leveling Dashboard`]`](https://stat.icecapa.de/grafana/public-dashboards/90a220f38928488a8a091d7f377b4548?orgId=1) - The IceBear Leveling Dashboard for B - designed by Icecapade!

### **Design Decisions**

When making a significant decision in how to maintain the projects and what we can or cannot support, we should document it in the [`[metacognition]`](https://github.com/b-Universe/b-network/blob/main/metacognition.md). Things like flags, sub-flags, "permissions"<sup>🌮4</sup>, and commands should be consistent in notating their names, descriptions, and optimally usage. If you have a question about how to be consistent, check to see if anything relevant may exist. If it is not documented there, asking in our [`[Development]`](https://discord.com/channels/901618453356630046/901618453746712656) Discord channel is probably the fastest way to determine how to document it. Else-wise, utilizing your best common sense and judgement will always be appreciated.

---
  <!-- below is drafted placeholders -->
> **_NOTE:_** The following is drafted contributing information not-yet written.

<details>

<summary>( Show / Hide )</summary>  

## **How can I contribute?**
### **Reporting bugs**
### **Suggesting enhancements**
### **Your first code contribution**
### **Issues**
### **Pull requests**

---

## **Styleguides**
### **Grammar and verbiage**
### **Git commit messages**
### **Specs styleguide**
### **Documentation styleguide**

---

## **Additional notes**

### **Issue and pull request labels**

</details>

---

#### **Footnotes**:
- <sup>🌮1</sup> `Regarding obfuscation`**`:`** This excludes explicitly secret information like client tokens, oAuth keys, passwords, etc.
- <sup>🌮2</sup> `The B API`**`:`** This endpoint will always require explicit authorization to be used.
- <sup>🌮3</sup> `The `<u>`https://Behr.dev`</u>` homepage`**`:`** At the time of writing this, the site is an orphan and does not have a home page yet.
- <sup>🌮4</sup> `Permissions`**`:`** B does not implement literal bukkit permissions. There is the occasional use of operator, but permissions are truly just flags.
  <!-- below is drafted placeholders
- <sup>🌮5</sup> `header`**`:`** text
- <sup>🌮6</sup> `header`**`:`** text
- <sup>🌮7</sup> `header`**`:`** text
- <sup>🌮8</sup> `header`**`:`** text
- <sup>🌮9</sup> `header`**`:`** text
- <sup>🌮10</sup> `header`**`:`** text
 -->
