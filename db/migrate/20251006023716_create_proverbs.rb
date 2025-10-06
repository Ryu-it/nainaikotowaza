class CreateProverbs < ActiveRecord::Migration[7.2]
  def change
    create_table :proverbs do |t|
      t.string :word1
      t.string :word2
      t.string :title
      t.string :meaning
      t.text :example
      t.integer :status
      t.references :room, null: false, foreign_key: true

      t.timestamps
    end
  end
end
