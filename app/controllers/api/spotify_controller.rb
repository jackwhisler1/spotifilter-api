class Api::SpotifyController < ApplicationController
  # before_action :authenticate_user
  def spotify_authorize
    scope = "playlist-read-private playlist-modify-private user-read-private user-read-email user-library-modify playlist-modify-public"
    redirect_to "https://accounts.spotify.com/authorize?client_id=#{Rails.application.credentials.spotify_api_key[:client_id]}&response_type=code&redirect_uri=http://localhost:3000/api/spotify/callback&scope=#{scope}"
  end

  def spotify_callback
    # code = params[:code]
    response = HTTP.post("https://accounts.spotify.com/api/token", 
    form: {
      grant_type: "authorization_code",
      code: "AQAhfhVnnfhxl7Zx9GBN6Pxzt9K39Tcd8iYphM1umtePHg5F6CjYSfJhVkxFJQTOSaiweCJWJMNXnJcHIijCShKIRmjrQEzXOK3pMq7AfOVSJktk5SEGPrQslKL7XAh94WqY3t053qkHTAqOUFVf2an-5m7o7VYypaIca46bX3NcA7ykXUDigEELtfuID_hZxE5j2x94czLWFGMYrGSPg8lmjLe21blLhxtI336MGm5ku5xVCLh6GtNInTMBeGehYsJsK3sdWkzwlUxlCyYRiwWOimgyoArHtulf7OLg9UvKxCmCQyC1OQ8e9G5Ep2ca4mhBuUj9yO2psZqF_4-rTDpprsNgIihiLhyf9YI3mQ",
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
