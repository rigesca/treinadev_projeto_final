Rails.application.routes.draw do
  devise_for :candidates
  devise_for :headhunters
  
  root 'home#index'  

  resources :job_vacancies, only: [:index,:create,:new,:show] do
    post 'apply', on: :member
  end
  resources :profiles, only: [:show, :new, :create, :edit, :update]
  resources :registereds,only: [:index] 

end
