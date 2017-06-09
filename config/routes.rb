Rails.application.routes.draw do
  root 'pages#home'
  get '/about', to: 'pages#about'
  get '/help', to: 'pages#help'

  # get '/todos', to: 'todos#index'
  # get '/todos/new', to: 'todos#new'
  # post '/todos', to: 'todos#create'
  # get '/todos/:id', to: 'todos#show'
  # get '/todos/:id/edit', to: 'todos#edit'
  # patch '/todos/:id', to: 'todos#update'
  # delete '/todos/:id', to: 'todos#destroy'
  get '/signup', to: 'users#new'
  resources :users, except: [:new]
  resources :todos
end
