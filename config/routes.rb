Rails.application.routes.draw do
  # spotify api calls
  namespace :api do
    get "/spotify_authorize" => "spotify#spotify_authorize"
    get "/spotify/callback" => "spotify#spotify_callback"
  end

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
