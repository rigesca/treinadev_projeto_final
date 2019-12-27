class CreateProposals < ActiveRecord::Migration[5.2]
  def change
    create_table :proposals do |t|
      t.date :start_date
      t.float :salary
      t.text :benefits
      t.text :note

      t.timestamps
    end
  end
end
