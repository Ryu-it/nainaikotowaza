class ChangeNullColumnToRoom < ActiveRecord::Migration[7.2]
  def up
    change_column_null :proverbs, :room_id, true
  end

  def down
    change_column_null :proverbs, :room_id, false
  end
end
