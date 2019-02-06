# better yet, just don't let people use . as part of a username.
# # by default rails considers '.' a separator, so override that
# module ActionController::Routing
#   SEPARATORS = %w( / ? )
# end

Rails.application.routes.draw do

  root to: "home#index"

  devise_for :users, controllers: { registration: 'registrations', session: 'sessions' }

  resources :tsts, path: :tests, as: :tests do
    resources :questions
  end
  # match 'tests/:id/:slug/start', :to => 'tsts#show', :as => 'start_test', :via => :get
  match 'tests/:id/:permalink/comments', :to => 'tsts#comments', :as => 'test_comments', :via => :get

  match 'people/:id/tests', :to => 'people#tests', :as => 'person_tests', :via => :get
  match 'people/:id/:slug', :to => 'people#show', :as => 'person', :via => :get
  # match 'people/:id/:name', :to => 'people#show', :as => 'person_with_name', :via => :get #, :constraints => {:username => /[^\/]+/}
  match 'people/:id/follow/:object_type/:object_id', :to => 'people#follow', :as => 'follow', :via => :get
  match 'people/:id/unfollow/:object_type/:object_id', :to => 'people#unfollow', :as => 'unfollow', :via => :get

  # resources :users

  match 'embed/:id/:permalink', :to => 'tsts#show', :as => 'embed_test', :via => :get

  # # match 'tests/new', :to => 'tsts#new', :as => 'new_test', :via => :get
  # # match 'tests/:id/edit', :to => 'tsts#edit', :as => 'edit_test', :via => :get
  # match 'tests/:id/publish', :to => 'tsts#publish', :as => 'publish_test', :via => :get
  # match 'tests/:id/enable', :to => 'tsts#enable', :as => 'enable_test', :via => :get
  # match 'tests/:id/disable', :to => 'tsts#disable', :as => 'disable_test', :via => :get
  # match 'tests/:id/invite', :to => 'tsts#invite', :as => 'invite_test', :via => :get
  # # match 'tests/:test_id/questions/new', :to => 'questions#new', :as => 'invite_test', :via => :get
  #
  # match 'tests/:id/:slug', :to => 'tsts#show', :as => 'test', :via => :get
  #
  # # match 'tests/:id/:permalink/start', :to => 'tsts#show', :as => 'test', :via => :get
  #
  # # match 'tests/:id/:permalink', :to => 'tsts#destroy', :as => 'test', :via => :delete
  # # match 'tests/:id/:permalink/questions', :to => 'tsts#questions', :as => 'test_questions', :via => :get
  # # match 'tests/:id/:permalink/questions/:question_id/:qpermalink', :to => 'tsts#show', :as => 'test_question', :via => :get
  # # match 'tests/:id/:permalink/questions/:question_id', :to => 'tsts#show', :via => :get
  # match 'tests/:id/:permalink/results/:user_id/:take', :to => 'tsts#individual_results', :as => 'individual_test_results', :via => :get
  # match 'tests/:id/:permalink/results', :to => 'tsts#results', :as => 'test_results', :via => :get

  match 'questions/answer', :to => 'questions#answer', :as => 'answer', :via => :post
  resources :questions

  resources :results
  # resources :comments

  # match 'search', :to => 'search#results', :as => 'search', :via => :get
  # match 'search/:term', :to => 'search#results', :as => 'search_term', :via => :get

  # match 'tags/:id',:to => 'tags#show', :as => 'tag', :via => :get
  # resources :tags

  # match 'hide_promo', :to => 'home#hide_promo', :as => 'hide_promo', :via => :get

  match 'blohg', :to => 'home#blohg', :as => 'blohg', :via => :get
  match 'about', :to => 'home#about', :as => 'about', :via => :get
  match 'contact', :to => 'home#contact', :as => 'contact', :via => :get
  match 'terms', :to => 'home#terms', :as => 'terms', :via => :get
  match 'notes', :to => 'home#notes', :as => 'notes', :via => :get
  match 'deck', :to => 'home#deck', :as => 'deck', :via => :get
  match 'clear', :to => 'home#clear', :as => 'clear', :via => :get
  # match 'test', :to => 'home#test', :as => 'test'

end
