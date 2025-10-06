class ChangeColumnNullToProverbs < ActiveRecord::Migration[7.2]
  def change
    change_column_null :proverbs, :word1, false
    change_column_null :proverbs, :word2, false
    change_column_null :proverbs, :title, false
    change_column_null :proverbs, :meaning, false
    change_column_null :proverbs, :status, false
  end
end
