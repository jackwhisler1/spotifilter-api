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
    @access_token = response.parse["access_token"]
    render json: response.parse
    # refresh_token = response.parse["refresh_token"]
    # access_token = ("access_token", @access_token)
    # response = HTTP.auth("Bearer #{@access_token}").get("https://api.spotify.com/v1/me")
    # render json: response.parse
  end

  def spotify_refresh
    # Need to store access & refresh tokens (?)
    code = @refresh_token
    render json: code
  end

  def top_songs
    # Need to find a way to send this get request with authorization
    response = HTTP.auth("Bearer #{@access_token} ").get("https://api.spotify.com/v1/me/top/tracks?time_range=medium_term&limit=200&offset=5" 
    response.parse
    songs = []
    response["items"].each do |song|
      songs << {
       "title": song["name"],
       "artist": song["artists"][0]["name"]
      }
    end
  #   render json: reponse
  # end
  # MVP
  # Get tokens 
  # Use tokens to get top tracks
  # Loop through tracks to check for 15 highest energy
  # Create new playlist with those songs
  

end
