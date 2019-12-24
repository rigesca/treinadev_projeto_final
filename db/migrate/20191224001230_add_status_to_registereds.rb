class AddStatusToRegistereds < ActiveRecord::Migration[5.2]
  def change
    add_column :registereds, :status, :integer, default: 0
  end
end
