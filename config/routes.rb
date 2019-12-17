Rails.application.routes.draw do
  devise_for :headhunters
  
  root 'home#index'  

  resources :job_vacancies, only: [:index,:create,:new,:show]
end
