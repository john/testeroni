# better yet, just don't let people use . as part of a username.
# # by default rails considers '.' a separator, so override that
# module ActionController::Routing
#   SEPARATORS = %w( / ? )
# end

Testeroni::Application.routes.draw do
  
  root :to => "home#index"
  
  devise_for :users, :controllers => {:registrations => 'registrations'}
  
  #  instead of constraints, allowing . across the board (see top of file)
  # match 'people/:username', :to => 'people#show', :as => 'people', :constraints => {:username => /[^\/]+/}
  match 'people/:username', :to => 'people#show', :as => 'people', :constraints => {:username => /[^\/]+/}
  match 'people', :to => "people#show", :as => 'user_root'
  resources :users
  
  match 'questions/answer', :to => 'questions#answer', :as => 'answer'
  resources :questions
  
  match 'tests/:id/publish', :to => 'tests#publish', :as => 'publish_test'
  match 'tests/:id/invite', :to => 'tests#invite', :as => 'invite_test'
  match 'tests/:id/:permalink/results/:username/:take', :to => 'tests#individual_results', :as => 'individual_test_results'
  match 'tests/:id/:permalink/results', :to => 'tests#results', :as => 'test_results'
  
  resources :tests
  
  match 'tests/:id/:permalink', :to => 'tests#show', :as => 'test', :via => :get
  # match 'tests/:id/:permalink/questions/:question_id', :to => 'tests#show', :as => 'test_question', :via => :get
  match 'tests/:id/:permalink/questions/:question_id/:qpermalink', :to => 'tests#show', :as => 'test_question', :via => :get
  match 'tests/:id/:permalink/questions/:question_id', :to => 'tests#show', :via => :get
  match 'tests/:id/:permalink', :to => 'tests#destroy', :as => 'test', :via => :delete

  resources :results
  resources :comments
  
  # match 'auth' => 'authentications#index'
  # match 'auth' => 'authentications#index', :as => 'sign_in'
  match 'auth/:provider' => 'authentications#create', :as => 'auth'
  match 'auth/:provider/callback' => 'authentications#create', :as => 'auth_callback'
  match 'last_step' => 'registrations#last_step'
  
  match 'search', :to => 'search#results', :as => 'search'
  match 'search/:term', :to => 'search#results', :as => 'search_term'
  
  match 'about', :to => 'home#about', :as => 'about'
  match 'contact', :to => 'home#contact', :as => 'contact'
  match 'notes', :to => 'home#notes', :as => 'notes'
  match 'deck', :to => 'home#deck', :as => 'deck'

end
