class Ai::ProverbsController < ApplicationController
  include ActionController::Live

  def generate
    response.headers["Content-Type"] = "text/event-stream"
    word1 = params[:word1]
    word2 = params[:word2]

    Ai::ProverbsGenerator.stream(word1: word1, word2: word2) do |event_type, payload|
      case event_type
      when :chunk
        # payloadにはsections（ハッシュ）が入る
        # { title: "...", meaning: "...", example: "..." }
        data = {
          event:   "chunk",
    title: payload[:title],
    meaning: payload[:meaning],
    example: payload[:example]
        }
        response.stream.write("data: #{data.to_json}\n\n")

      when :final
        result = payload

        @proverb = Proverb.new(
          word1: word1,
          word2: word2,
          title:   result[:title],
          meaning: result[:meaning],
          example: result[:example]
        )

        # 最終の全文をブラウザに送る
        data = {
          event: "final",
          result: {
            title:   result[:title],
            meaning: result[:meaning],
            example: result[:example]
          }
        }
        response.stream.write("data: #{data.to_json}\n\n")
      end
    end
  ensure
    response.stream.close
  end
end
