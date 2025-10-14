class CreateNotifications < ActiveRecord::Migration[7.2]
  def change
    create_table :notifications do |t|
      t.references :actor, null: false, foreign_key: { to_table: :users }
      t.references :recipient, null: false, foreign_key: { to_table: :users }
      t.string :action, null: false
      t.boolean :is_checked, null: false, default: false
      t.string  :notifiable_type, null: false
      t.bigint  :notifiable_id,   null: false

      t.timestamps
    end

    add_index :notifications, [ :recipient_id, :is_checked ]
    add_index :notifications, [ :notifiable_type, :notifiable_id ]
  end
end
