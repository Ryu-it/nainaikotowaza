class AddRoleToProverbContributors < ActiveRecord::Migration[7.2]
  def change
    add_column :proverb_contributors, :role, :integer
  end
end
