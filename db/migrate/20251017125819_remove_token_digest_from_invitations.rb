class RemoveTokenDigestFromInvitations < ActiveRecord::Migration[7.2]
  def change
    remove_column :invitations, :token_digest, :string, null: false
  end
end
