# better yet, just don't let people use . as part of a username.
# # by default rails considers '.' a separator, so override that
module ActionController::Routing
  SEPARATORS = %w( / ? )
end

Testeroni::Application.routes.draw do
  
  root :to => "home#index"
  
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks", :registrations => 'registrations' }
  # devise_for :users, :controllers => {:omniauth_callbacks => "users/omniauth_callbacks"}
  
  # devise_scope :user do
  #   get "sign_in", :to => "devise/sessions#new"
  #   get "sign_up", :to => "registrations#new"
  # end
  
  match 'people/:id', :to => 'people#show', :as => 'person'
  match 'people/:id/:display_name', :to => 'people#show', :as => 'person_with_name' #, :constraints => {:username => /[^\/]+/}
  match 'people/:id/follow/:object_type/:object_id', :to => 'people#follow', :as => 'follow'
  match 'people/:id/unfollow/:object_type/:object_id', :to => 'people#unfollow', :as => 'unfollow'
  
  resources :users
  
  match 'embed/:id/:permalink', :to => 'tsts#show', :as => 'embed_test', :via => :get
  
  match 'tests/new', :to => 'tsts#new', :as => 'new_test'
  match 'tests/:id/edit', :to => 'tsts#edit', :as => 'edit_test'
  match 'tests/:id/publish', :to => 'tsts#publish', :as => 'publish_test'
  match 'tests/:id/enable', :to => 'tsts#enable', :as => 'enable_test'
  match 'tests/:id/disable', :to => 'tsts#disable', :as => 'disable_test'
  match 'tests/:id/invite', :to => 'tsts#invite', :as => 'invite_test'
  
  match 'tests/:id/:permalink', :to => 'tsts#show', :as => 'test', :via => :get
  match 'tests/:id/:permalink/start', :to => 'tsts#show', :as => 'start_test', :via => :get
  
  match 'tests/:id/:permalink/start', :to => 'tsts#show', :as => 'test', :via => :get
  match 'tests/:id/:permalink', :to => 'tsts#destroy', :as => 'test', :via => :delete
  match 'tests/:id/:permalink/questions', :to => 'tsts#questions', :as => 'test_questions', :via => :get
  match 'tests/:id/:permalink/questions/:question_id/:qpermalink', :to => 'tsts#show', :as => 'test_question', :via => :get
  match 'tests/:id/:permalink/questions/:question_id', :to => 'tsts#show', :via => :get
  match 'tests/:id/:permalink/comments', :to => 'tsts#comments', :as => 'test_comments', :via => :get
  match 'tests/:id/:permalink/results/:user_id/:take', :to => 'tsts#individual_results', :as => 'individual_test_results'
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
  
  match 'hide_promo', :to => 'home#hide_promo', :as => 'hide_promo'
  
  match 'blohg', :to => 'home#blohg', :as => 'blohg'
  match 'about', :to => 'home#about', :as => 'about'
  match 'contact', :to => 'home#contact', :as => 'contact'
  match 'terms', :to => 'home#terms', :as => 'terms'
  match 'notes', :to => 'home#notes', :as => 'notes'
  match 'deck', :to => 'home#deck', :as => 'deck'
  match 'clear', :to => 'home#clear', :as => 'clear'
  # match 'test', :to => 'home#test', :as => 'test'

end
