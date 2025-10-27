class Ai::WordsController < ApplicationController
  def generate
    result = Ai::WordsGenerator.call
    @proverb = Proverb.new(result)
    render turbo_stream: turbo_stream.update("proverb_form", partial: "proverbs/form", locals: { proverb: @proverb })
  end
end
