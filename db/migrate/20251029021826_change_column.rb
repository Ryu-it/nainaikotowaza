class ChangeColumn < ActiveRecord::Migration[7.2]
  def change
    change_column :users, :email, :string, default: nil, null: true
  end
end
