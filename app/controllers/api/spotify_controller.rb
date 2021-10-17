class Api::SpotifyController < ApplicationController
  def spotify_authorize
    redirect_to "https://accounts.spotify.com/authorize?client_id=#{Rails.application.credentials.spotify_api_key[:client_id]}&response_type=code&redirect_uri=http://localhost:3000/api/spotify/callback&scope=playlist-modify-private"
  end

  def spotify_callback
    code = params[:code]
    response = HTTP.post("https://accounts.spotify.com/api/token", 
    form: {
      grant_type: "authorization_code",
      code: code,
      redirect_uri: "http://localhost:3000/api/spotify/callback",
      client_id: Rails.application.credentials.spotify_api_key[:client_id],
      client_secret: Rails.application.credentials.spotify_api_key[:client_secret]
    })
    render json: response.parse
    @access_token = response.parse["access_token"]
    @refresh_token = response.parse["refresh_token"]
    # @access_token = response.parse["access_token"]
    # # response = HTTP.auth("Bearer #{@access_token}").get("https://api.spotify.com/v1/me")
    # render json: response.parse
  end
end
