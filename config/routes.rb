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

  resources :proposals, only: [:index, :show] do
    get 'reject', on: :member
    post 'save_reject', on: :member

    get 'accept', on: :member
    post 'save_accept', on: :member
  end

  resources :job_vacancies, only: [:index,:show, :new, :create] do
    post 'apply', on: :member
    get 'candidate_list', on: :member, shallow: true

    get 'search', on: :collection

    post 'closes', on: :member
  end

  

end
