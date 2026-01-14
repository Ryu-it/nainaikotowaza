class ChangeRoomsOwnerIdToBigint < ActiveRecord::Migration[7.2]
  def up
    # 外部キーを外す
    remove_foreign_key :rooms, column: :owner_id

    # 型変更
    change_column :rooms, :owner_id, :bigint, null: false

    # 外部キーを付け直す
    add_foreign_key :rooms, :users, column: :owner_id
  end

  def down
    remove_foreign_key :rooms, column: :owner_id
    change_column :rooms, :owner_id, :integer, null: false
    add_foreign_key :rooms, :users, column: :owner_id
  end
end
