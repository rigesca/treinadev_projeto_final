class AddHighlightToRegistered < ActiveRecord::Migration[5.2]
  def change
    add_column :registereds, :highlight, :boolean, default: false
  end
end
