# better yet, just don't let people use . as part of a username.
# # by default rails considers '.' a separator, so override that
# module ActionController::Routing
#   SEPARATORS = %w( / ? )
# end

Testeroni::Application.routes.draw do
  
  root :to => "home#index"
  
  devise_for :users, :controllers => {:registrations => 'registrations'}
  resources :users
  resources :questions
  resources :tests
  resources :results
  
  # match 'auth' => 'authentications#index'
  # match 'auth' => 'authentications#index', :as => 'sign_in'
  
  match 'auth/:provider' => 'authentications#create', :as => 'auth'
  match 'auth/:provider/callback' => 'authentications#create', :as => 'auth_callback'
  match 'last_step' => 'registrations#last_step'
  
  #  instead of constraints, allowing . across the board (see top of file)
  # match 'people/:username', :to => 'people#show', :as => 'people', :constraints => {:username => /[^\/]+/}
  match 'people/:username', :to => 'people#show', :as => 'people', :constraints => {:username => /[^\/]+/}
  match 'people', :to => "people#show", :as => 'user_root'
  
  match 'tests/:id/publish', :to => 'tests#publish', :as => 'publish_test'
  match 'tests/:id/results/:username', :to => 'tests#individual_results', :as => 'individual_results'
  match 'tests/:id/results', :to => 'tests#aggregated_results', :as => 'aggregated_results'
  
  match 'questions/answer', :to => 'questions#answer', :as => 'answer'
  
  match 'about', :to => 'home#about', :as => 'about'
  match 'contact', :to => 'home#contact', :as => 'contact'
  match 'notes', :to => 'home#notes', :as => 'notes'
  match 'deck', :to => 'home#deck', :as => 'deck'

end
