class CreateProverbContributors < ActiveRecord::Migration[7.2]
  def change
    create_table :proverb_contributors do |t|
      t.references :user, null: false, foreign_key: true
      t.references :proverb, null: false, foreign_key: true

      t.timestamps
    end
  end
end
