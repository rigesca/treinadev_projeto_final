class CreateRegistereds < ActiveRecord::Migration[5.2]
  def change
    create_table :registereds do |t|
      t.references :candidate, foreign_key: true
      t.references :job_vacancy, foreign_key: true
      t.text :registered_justification

      t.timestamps
    end
  end
end
