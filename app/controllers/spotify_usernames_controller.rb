class SpotifyUsernamesController < ApplicationController
  def show
    response = HTTP.auth("Bearer #{User.first.access_token}").get("https://api.spotify.com/v1/me")
    render json: response.parse(:json)
  end
end
