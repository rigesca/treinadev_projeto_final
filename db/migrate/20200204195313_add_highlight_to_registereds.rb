class AddHighlightToRegistereds < ActiveRecord::Migration[5.2]
  def change
    add_column :registereds, :highlight, :integer, default: 0
  end
end
]