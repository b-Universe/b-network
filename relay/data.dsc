bdata:
  type: data
  api:
    Discord:
      endpoint: https<&co>//discord.com/api/
      headers:
        Authorization: <secret[cbot]>
        Content-Type: application/json
        User-Agent: b
    OpenAI:
      endpoint:
        completions: https<&co>//api.openai.com/v1/completions
        image:
          edits: https<&co>//api.openai.com/v1/images/edits
          generation: https<&co>//api.openai.com/v1/images/generations
      headers:
        Authorization: <secret[ai]>
        Content-Type: application/json
        User-Agent: b
    GitHub:
      embed_image: https<&co>//cdn.discordapp.com/attachments/901618453746712665/911062223244374046/unknown.png
