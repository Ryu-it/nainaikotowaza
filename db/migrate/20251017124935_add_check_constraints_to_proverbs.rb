class AddCheckConstraintsToProverbs < ActiveRecord::Migration[7.2]
  def up
    # 1) ドラフト作成を許すために NOT NULL を外す
    change_column_null :proverbs, :word1,   true
    change_column_null :proverbs, :word2,   true
    change_column_null :proverbs, :title,   true
    change_column_null :proverbs, :meaning, true
    # example は既に NULL 許容なので変更不要

    # 2) status の値域を固定（draft:0, in_progress:1, completed:2）
    add_check_constraint :proverbs,
      "status IN (0,1,2)",
      name: "proverbs_status_enum"

    # 3) in_progress / completed では word1, word2 が必須＆長さ制限
    add_check_constraint :proverbs, <<~SQL.squish, name: "proverbs_words_required_when_in_progress_or_completed"
      (status IN (1,2)) IS NOT TRUE
      OR (
        word1 IS NOT NULL AND char_length(word1) <= 10 AND
        word2 IS NOT NULL AND char_length(word2) <= 10
      )
    SQL

    # 4) completed では title, meaning も必須＆長さ制限
    add_check_constraint :proverbs, <<~SQL.squish, name: "proverbs_title_meaning_required_when_completed"
      (status = 2) IS NOT TRUE
      OR (
        title   IS NOT NULL AND char_length(title)   <= 50 AND
        meaning IS NOT NULL AND char_length(meaning) <= 100
      )
    SQL

    # 5) example の最大長（NULL は許容）
    add_check_constraint :proverbs, <<~SQL.squish, name: "proverbs_example_max_length"
      (example IS NULL) OR (char_length(example) <= 300)
    SQL
  end

  def down
    # 5) example 長さ制約の解除
    remove_check_constraint :proverbs, name: "proverbs_example_max_length"

    # 4) completed 用制約の解除
    remove_check_constraint :proverbs, name: "proverbs_title_meaning_required_when_completed"

    # 3) in_progress/completed 用制約の解除
    remove_check_constraint :proverbs, name: "proverbs_words_required_when_in_progress_or_completed"

    # 2) status 値域制約の解除
    remove_check_constraint :proverbs, name: "proverbs_status_enum"

    # 1) NOT NULL を元に戻す（元のスキーマに復帰）
    change_column_null :proverbs, :meaning, false
    change_column_null :proverbs, :title,   false
    change_column_null :proverbs, :word2,   false
    change_column_null :proverbs, :word1,   false
  end
end
