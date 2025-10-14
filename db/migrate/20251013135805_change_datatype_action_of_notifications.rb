class ChangeDatatypeActionOfNotifications < ActiveRecord::Migration[7.2]
  def up
    # 既存の string を integer に変換（キャスト）
    execute <<~SQL
      ALTER TABLE notifications
      ALTER COLUMN action TYPE integer USING action::integer;
    SQL

    # 必要に応じて NOT NULL や DEFAULT も追加
    change_column_default :notifications, :action, 0
    change_column_null :notifications, :action, false
  end

  def down
    # ロールバックで string に戻す
    change_column :notifications, :action, :string, null: false
  end
end
