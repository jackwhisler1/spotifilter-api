Rails.application.routes.draw do
  #index
  get "/shared_playlists" => "shared_playlists#index"
  #create
  post "/users" => "users#create"
  post "/sessions" => "sessions#create"
  post "/shared_playlists" => "shared_playlists#create"
  #show
  get "/users/:id" => "users#show"
  get "/shared_playlists/:id" => "shared_playlists#show"
  #update
  patch "/users/:id" => "users#update"
  patch "/shared_playlists/:id" => "shared_playlists#update"
  #destroy
  delete "/users/:id" => "users#destroy"
  delete "/shared_playlists/:id" => "shared_playlists#destroy"

end
