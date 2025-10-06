class CreateRooms < ActiveRecord::Migration[7.2]
  def change
    create_table :rooms do |t|
      t.integer :owner_id

      t.timestamps
    end

    add_foreign_key :rooms, :users, column: :owner_id
  end
end
