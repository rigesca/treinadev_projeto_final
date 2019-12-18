class CreateProfiles < ActiveRecord::Migration[5.2]
  def change
    create_table :profiles do |t|
      t.string :name
      t.string :social_name
      t.date :birth_date
      t.text :formation
      t.text :description
      t.text :experience
      t.boolean :complet_profile
      t.references :candidate, foreign_key: true

      t.timestamps
    end
  end
end
