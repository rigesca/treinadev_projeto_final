Rails.application.routes.draw do
  devise_for :candidates
  devise_for :headhunters
  
  root 'home#index'  

  resources :profiles, only: [:show, :new, :create, :edit, :update] do
    get 'comments_list', on: :member, shallow: true
    post 'register_comment', on: :member
  end
  
  resources :registereds,only: [:index] do
    post 'mark', on: :member
    
    get 'cancel', on: :member
    post 'save_canceled', on: :member

    get 'proposal', on: :member, controller: 'proposals', action: :new
    post 'send_proposal', on: :member, controller: 'proposals', action: :create
  end

  resources :proposals, only: [:index, :show]

  resources :job_vacancies, only: [:index,:show, :new, :create] do
    post 'apply', on: :member
    get 'candidate_list', on: :member, shallow: true

    get 'search', on: :collection
  end

  

end
