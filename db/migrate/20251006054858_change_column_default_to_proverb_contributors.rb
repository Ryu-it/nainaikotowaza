class ChangeColumnDefaultToProverbContributors < ActiveRecord::Migration[7.2]
  def change
    change_column_default :proverb_contributors, :role, from: nil, to: 0
  end
end
