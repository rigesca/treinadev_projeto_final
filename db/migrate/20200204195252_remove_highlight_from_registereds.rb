class RemoveHighlightFromRegistereds < ActiveRecord::Migration[5.2]
  def change
    remove_column :registereds, :highlight, :boolean
  end
end
