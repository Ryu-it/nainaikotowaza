module Ai
  class ProverbsGenerator
    def self.call(word1:, word2:)
      prompt = <<~PROMPT
        「以下の条件で、日本語の新しいことわざを作ってください。

        - 「#{word1}」と「#{word2}」の2つの言葉を必ず使う。
        - 現実味のある内容で、意味が理解しやすいものにする。
        - 少しユーモラスでも良いが、意味が通じることを重視する。
        - 実際にありそうな日本のことわざ風の表現にする。
        - 難しすぎる言葉や、文法的におかしい言い回しは避ける。
        必ず以下のJSON形式で応答してください。

        {
          "proverb": "作成したことわざ",
          "meaning": "そのことわざの意味や教訓",
          "example": "日常会話での使用例"
        }
      PROMPT

      client = OpenAI::Client.new

      response = client.chat(
        parameters: {
          model: "gpt-4o-mini",
          messages: [ { role: "user", content: prompt } ],
          temperature: 1.0
        }
      )

      content = response.dig("choices", 0, "message", "content")
      JSON.parse(content, symbolize_names: true)
    rescue JSON::ParserError
      { proverb: "", meaning: "", example: "" }
    end
  end
end
