class CreateJobVacancies < ActiveRecord::Migration[5.2]
  def change
    create_table :job_vacancies do |t|
      t.string :title
      t.text :vacancy_description
      t.text :ability_description
      t.float :maximum_wage
      t.float :minimun_wage
      t.integer :level , default: 0
      t.date :limit_date
      t.string :region
      t.integer :status, default: 0
      t.references :headhunter, foreign_key: true

      t.timestamps
    end
  end
end
