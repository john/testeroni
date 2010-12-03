# better yet, just don't let people use . as part of a username.
# # by default rails considers '.' a separator, so override that
# module ActionController::Routing
#   SEPARATORS = %w( / ? )
# end

Testeroni::Application.routes.draw do
  
  root :to => "home#index"
  
  devise_for :users, :controllers => {:registrations => 'registrations'}
  
  resources :authentications
  match 'auth/set_session_and_go/:id' => 'authentications#set_session_and_go'
  match 'auth/:provider/callback' => 'authentications#create', :as => 'auth_callback'
  match 'auth/failure' => 'authentications#failure', :as => 'auth_failure'
  
  # instead of constraints, consider allowing . across the board (see top of file)
  match 'people/:username', :to => 'people#show', :as => 'people', :constraints => {:username => /[^\/]+/}
  match 'people', :to => "people#show", :as => 'user_root'
  resources :users
  
  match 'questions/answer', :to => 'questions#answer', :as => 'answer'
  resources :questions
  
  match 'tests/:id/publish', :to => 'tests#publish', :as => 'publish_test'
  match 'tests/:id/invite', :to => 'tests#invite', :as => 'invite_test'
  match 'tests/:id/:permalink/results/:username/:take', :to => 'tests#individual_results', :as => 'individual_test_results'
  match 'tests/:id/:permalink/results', :to => 'tests#results', :as => 'test_results'
  
  match 'tests/:id/:permalink/questions', :to => 'tests#questions', :as => 'test_questions'
  
  resources :tests
  
  match 'tests/:id/:permalink', :to => 'tests#show', :as => 'test', :via => :get
  match 'tests/:id/:permalink/questions/:question_id/:qpermalink', :to => 'tests#show', :as => 'test_question', :via => :get
  match 'tests/:id/:permalink/questions/:question_id', :to => 'tests#show', :via => :get
  match 'tests/:id/:permalink', :to => 'tests#destroy', :as => 'test', :via => :delete

  resources :results
  resources :comments
  
  match 'search', :to => 'search#results', :as => 'search'
  match 'search/:term', :to => 'search#results', :as => 'search_term'
  
  match 'about', :to => 'home#about', :as => 'about'
  match 'contact', :to => 'home#contact', :as => 'contact'
  match 'notes', :to => 'home#notes', :as => 'notes'
  match 'deck', :to => 'home#deck', :as => 'deck'

end
