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
      code: "AQD8l9I88ptGCTQ9Qn0dXqq6NkYn3atCDTZsfPeClXs0_D40opQUg0GHxBZ6mSLdXHWvveLx_dr_4DRNjuKgdgOvqizK6FGBa_FBoxUMVlh5f-8s6kZctKIzAhbGZJPhNdcsWGjmeazawiunx51SxgXtCnpwobT-voipOPrp9CEr300Uvq9AX3d6g4rmsfgptyuGsJdItpxBTjsybLeH11lnrsLjXNVdMJ44cFEX44Krk3TL0EaHTx6cWSbXXGxIptYmFccX8nuYaLmTIgiLPlSgtfkCdMnhvvP3BH2e0f7MI_g1ML4hGgPJym0uVLwyzWio51dgpb2sNZJg2r2BLkJtw_Bb2b5t1ARdcs_QAw",
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
