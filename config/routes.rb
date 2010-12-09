# better yet, just don't let people use . as part of a username.
# # by default rails considers '.' a separator, so override that
module ActionController::Routing
  SEPARATORS = %w( / ? )
end

Testeroni::Application.routes.draw do
  
  root :to => "home#index"
  
  devise_for :users, :controllers => {:registrations => 'registrations'}
  
  # from omniauth. this creates /auth/twitter and /auth/facebook, based on
  # contents of /config/initializers/omniauth
  resources :authentications
  
  match 'auth/:provider/callback' => 'authentications#create', :as => 'auth_callback'
  match 'auth/failure' => 'authentications#failure', :as => 'auth_failure'
  
  # instead of constraints, consider allowing . across the board (see top of file)
  match 'people/:username', :to => 'people#show', :as => 'people' #, :constraints => {:username => /[^\/]+/}
  match 'people', :to => "people#show", :as => 'user_root'
  resources :users
  
  match 'tests/new', :to => 'tsts#new', :as => 'new_test'
  match 'tests/:id/edit', :to => 'tsts#edit', :as => 'edit_test'
  match 'tests/:id/publish', :to => 'tsts#publish', :as => 'publish_test'
  match 'tests/:id/invite', :to => 'tsts#invite', :as => 'invite_test'
  match 'tests/:id/:permalink', :to => 'tsts#show', :as => 'test', :via => :get
  match 'tests/:id/:permalink', :to => 'tsts#destroy', :as => 'test', :via => :delete
  match 'tests/:id/:permalink/questions', :to => 'tsts#questions', :as => 'test_questions'
  match 'tests/:id/:permalink/questions/:question_id/:qpermalink', :to => 'tsts#show', :as => 'test_question', :via => :get
  match 'tests/:id/:permalink/questions/:question_id', :to => 'tsts#show', :via => :get
  match 'tests/:id/:permalink/results/:username/:take', :to => 'tsts#individual_results', :as => 'individual_test_results'
  match 'tests/:id/:permalink/results', :to => 'tsts#results', :as => 'test_results'
  resources :tsts

  match 'questions/answer', :to => 'questions#answer', :as => 'answer'
  resources :questions
  
  resources :results
  resources :comments
  
  match 'search', :to => 'search#results', :as => 'search'
  match 'search/:term', :to => 'search#results', :as => 'search_term'
  
  match 'tags/:id',:to => 'tags#show', :as => 'tag'
  resources :tags
  
  match 'about', :to => 'home#about', :as => 'about'
  match 'contact', :to => 'home#contact', :as => 'contact'
  match 'terms', :to => 'home#terms', :as => 'terms'
  match 'notes', :to => 'home#notes', :as => 'notes'
  match 'deck', :to => 'home#deck', :as => 'deck'
  # match 'test', :to => 'home#test', :as => 'test'

end
