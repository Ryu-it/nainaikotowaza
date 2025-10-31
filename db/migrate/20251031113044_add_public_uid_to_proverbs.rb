class AddPublicUidToProverbs < ActiveRecord::Migration[7.2]
  def up
    add_column :proverbs, :public_uid, :uuid, default: "gen_random_uuid()", null: true
    add_index  :proverbs, :public_uid, unique: true

    # 既存レコードの穴埋め
    execute <<~SQL
      UPDATE proverbs SET public_uid = gen_random_uuid() WHERE public_uid IS NULL;
    SQL

    change_column_null :proverbs, :public_uid, false
  end

  def down
    remove_index  :proverbs, :public_uid
    remove_column :proverbs, :public_uid
  end
end
