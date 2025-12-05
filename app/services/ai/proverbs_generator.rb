module Ai
  class ProverbsGenerator
    def self.build_prompt(word1:, word2:)
      <<~PROMPT
        以下の条件で、日本語の新しいことわざを作ってください。

        - 「#{word1}」と「#{word2}」の2つの言葉を必ず使う。
        - 現実味のある内容で、意味が理解しやすいものにする。
        - 少しユーモラスでも良いが、意味が通じることを重視する。
        - 実際にありそうな日本のことわざ風の表現にする。
        - 難しすぎる言葉や、文法的におかしい言い回しは避ける。

        出力形式は必ず次の形にしてください（JSONではなく、この区切りを含むテキスト）:

        [title]
        ここにことわざ本体

        [meaning]
        ここに意味

        [example]
        ここに用例
      PROMPT
    end

    # チャンクごとに現在の全文を送り、すべて生成し終わったら最終結果（ハッシュ）を返す
    def self.stream(word1:, word2:)
      client  = OpenAI::Client.new
      prompt  = build_prompt(word1: word1, word2: word2)
      buffer  = +""

      client.chat(
        parameters: {
          model: "gpt-4o-mini",
          messages: [ { role: "user", content: prompt } ],
          temperature: 1.0,
          stream: proc do |chunk, _bytes|
            delta = chunk.dig("choices", 0, "delta", "content")
            next if delta.nil?

            buffer << delta

            sections = parse_sections(buffer)
            # 現在までに生成されたテキスト（まだ途中）を送る
            yield :chunk, sections if block_given?
          end
        }
      )
      # 全てのテキストを送る
      final_sections = parse_sections(buffer)
      yield :final, final_sections if block_given?
      final_sections
    end

    # [title] / [meaning] / [example] で区切られたテキストをパースしてハッシュで返す
    def self.parse_sections(text)
      title = meaning = example = ""

      if text =~ /\[title\](.*?)(\[meaning\]|\z)/m
        title = Regexp.last_match(1).strip
      end

      if text =~ /\[meaning\](.*?)(\[example\]|\z)/m
        meaning = Regexp.last_match(1).strip
      end

      if text =~ /\[example\](.*)/m
        example = Regexp.last_match(1).strip
      end

      { title: title, meaning: meaning, example: example }
    end
  end
end
