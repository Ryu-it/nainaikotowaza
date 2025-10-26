module Ai
  class WordsGenerator
    def self.call
      prompt = <<~PROMPT
        日本語の「名詞」を2つ提案してください。
        前回と同じような言葉は避け、なるべく異なるジャンルや印象の言葉を出してください。
        基本的には日常的で分かりやすい言葉で構いませんが、
        ユニークで面白い言葉も混ぜてください。
        バランスよく多様な表現を出してください。
        必ず以下のJSON形式で出力してください：

        {
          "word1": "最初の単語",
          "word2": "二つ目の単語"
        }
      PROMPT

      client = OpenAI::Client.new

      response = client.chat(
        parameters: {
          model: "gpt-4o-mini",
          messages: [ { role: "user", content: prompt } ],
          temperature: 1.2
        }
      )

      content = response.dig("choices", 0, "message", "content")
      JSON.parse(content, symbolize_names: true)
    end
  end
end
