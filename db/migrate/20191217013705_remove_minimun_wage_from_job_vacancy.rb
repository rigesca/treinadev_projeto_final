class RemoveMinimunWageFromJobVacancy < ActiveRecord::Migration[5.2]
  def change
    remove_column :job_vacancies, :minimun_wage, :float
    add_column :job_vacancies, :minimum_wage, :float 
  end
end
