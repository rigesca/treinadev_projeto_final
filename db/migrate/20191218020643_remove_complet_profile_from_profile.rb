class RemoveCompletProfileFromProfile < ActiveRecord::Migration[5.2]
  def change
    remove_column :profiles, :complet_profile, :boolean
  end
end
