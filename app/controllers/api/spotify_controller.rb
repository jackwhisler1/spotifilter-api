class Api::SpotifyController < ApplicationController
  before_action :authenticate_user
  require "base64"


  def spotify_callback
    code = params[:code]
    response = HTTP.post("https://accounts.spotify.com/api/token", 
    form: {
      grant_type: "authorization_code",
      code: code,
      redirect_uri: "https://spotifilter.netlify.app/spotify/callback",
      client_id: Rails.application.credentials.spotify_api_key[:client_id],
      client_secret: Rails.application.credentials.spotify_api_key[:client_secret]
    })
    access_token = response.parse["access_token"]
    refresh_token = response.parse["refresh_token"]

    current_user.update(access_token: access_token) 
    current_user.update(refresh_token: refresh_token)


    render json: response.parse
  end

  def spotify_refresh
    # Need to store access & refresh tokens (?)
    refresh_token = current_user[:refresh_token]
    refresh_auth = Base64.strict_encode64((Rails.application.credentials.spotify_api_key[:client_id]) + ":" + (Rails.application.credentials.spotify_api_key[:client_secret]))
    form = {
      grant_type: "refresh_token",
      refresh_token: refresh_token,
    }
    headers={
      Accept:'application/json',
      'Content-Type': 'application/x-www-form-urlencoded'
  }
    response = HTTP.auth("Basic " + refresh_auth).headers(headers).post("https://accounts.spotify.com/api/token", :params => form)

    access_token = response.parse["access_token"]
    current_user.update(access_token: access_token) 
    render json: response.parse(:json)
  end
end
