class PlaylistsController < ApplicationController
  def index
    response = HTTP.auth("Bearer #{User.first.access_token}").get("https://api.spotify.com/v1/me/playlists")
    render json: response.parse(:json)["items"]
  end

  def show
    response = HTTP.auth("Bearer #{User.first.access_token}").get("https://api.spotify.com/v1/playlists/#{params["id"]}/tracks")  
    render json: response.parse(:json)
  end
end
