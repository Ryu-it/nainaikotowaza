class Ai::ProverbsController < ApplicationController
  def generate
    result = Ai::ProverbsGenerator.call(
      word1: params[:word1],
      word2: params[:word2]
    )

    @proverb = Proverb.new(
      word1: params[:word1],
      word2: params[:word2],
      title: result[:proverb],
      meaning: result[:meaning],
      example: result[:example]
    )

    render turbo_stream: turbo_stream.update(
      "proverb_form",
      partial: "proverbs/form",
      locals: { proverb: @proverb }
    )
  end
end
