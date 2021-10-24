class PlaylistsController < ApplicationController
  def index
    response = HTTP.auth("Bearer #{User.first.access_token}").get("https://api.spotify.com/v1/me/playlists")
    render json: response.parse(:json)["items"]
  end

  def create
    # response = HTTP.auth("Bearer #{User.first.access_token}").get("https://api.spotify.com/v1/me")
    # spotify_user_id = response.parse(:json)["id"]
    options = {
      "name": "Sent in Params"
    }
    response = HTTP.auth("Bearer #{User.first.access_token}").post("https://api.spotify.com/v1/users/jnwhisler/playlists", :json => options)
    render json: response.parse(:json)

  end

  def show
    response = HTTP.auth("Bearer #{User.first.access_token}").get("https://api.spotify.com/v1/playlists/#{params["id"]}/tracks")  
    render json: response.parse(:json)
  end
end
