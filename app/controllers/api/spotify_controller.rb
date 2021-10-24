class Api::SpotifyController < ApplicationController
  # before_action :authenticate_user
  def spotify_authorize
    redirect_to "https://accounts.spotify.com/authorize?client_id=#{Rails.application.credentials.spotify_api_key[:client_id]}&response_type=code&redirect_uri=http://localhost:3000/api/spotify/callback&scope=playlist-modify-private"
  end

  def spotify_callback
    # code = params[:code]
    response = HTTP.post("https://accounts.spotify.com/api/token", 
    form: {
      grant_type: "authorization_code",
      code: "AQCeQFlfVyfmBiS1T1qcsnFphwouLDTcufKYESYM2dU3sGllndFafIlm5bAskwhWXF8T3wNLiUS0JKxAiLtbbceTWLEEW7OKKuvgjUYHTNIUABK9jOpgAcwhDuUgxbuwgURcpB3p1UxDV2YEoqZ-mwQ4KSt0AaQQWyOKF0upbhhVD2ygOS40mMbHWnMBof2-yWYLyek9vU07b2w65iINaXBOOIbV188",
      redirect_uri: "http://localhost:3000/api/spotify/callback",
      client_id: Rails.application.credentials.spotify_api_key[:client_id],
      client_secret: Rails.application.credentials.spotify_api_key[:client_secret]
    })
    access_token = response.parse["access_token"]
    refresh_token = response.parse["refresh_token"]
    # response = HTTP.auth("Bearer #{@access_token}").get("https://api.spotify.com/v1/me")
    # ? About how to test so that a user is logged in before I run the spotify_authorize
    current_user.update(access_token: access_token) 


    render json: response.parse
  end

  def spotify_refresh
    # Need to store access & refresh tokens (?)
    code = @refresh_token
    render json: code
  end

  def top_songs
    # Need to find a way to send this get request with authorization

    # Becomes "Bearer #{current_user.access_token}" once callback action works  
    response = HTTP.auth("Bearer #{User.first.access_token}").get("https://api.spotify.com/v1/me/playlists")

    # .get("https://api.spotify.com/v1/me/top/tracks?time_range=medium_term&limit=200&offset=5") 
    # Currently not sending any headers
    songs = []
    # response["items"].each do |song|
    #   songs << {
    #    "title": song["name"],
    #    "artist": song["artists"][0]["name"]
    #   }
    # end
    response = response.parse(:json)
    render json: response.as_json
  end
  # MVP
  # Get tokens 
  # Use tokens to get top tracks
  # Loop through tracks to check for 15 highest energy
  # Create new playlist with those songs
  

end
