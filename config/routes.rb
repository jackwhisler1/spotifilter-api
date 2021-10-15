Rails.application.routes.draw do
  #index
  get "/shared_playlists" => "shared_playlists#index"
  #create
  post "/users" => "users#create"
  post "/sessions" => "sessions#create"
  #show
  get "/users/:id" => "users#show"
  #update
  patch "/users/:id" => "users#update"
  #destroy
  delete "/users/:id" => "users#destroy"

end
