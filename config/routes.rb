Rails.application.routes.draw do
  devise_for :headhunters
  root 'home#index'  
end
