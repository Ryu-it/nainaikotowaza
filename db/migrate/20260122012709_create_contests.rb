class CreateContests < ActiveRecord::Migration[7.2]
  def change
    create_table :contests do |t|
      t.string   :title,        null: false
      t.text     :description
      t.string   :fixed_word,   null: false
      t.datetime :starts_at,    null: false
      t.datetime :ends_at,      null: false
      t.string   :thumbnail

      t.timestamps
    end

    add_index :contests, :starts_at
    add_index :contests, :ends_at
  end
end
