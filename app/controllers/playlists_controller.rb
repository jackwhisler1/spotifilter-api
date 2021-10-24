class PlaylistsController < ApplicationController
  def index
    response = HTTP.auth("Bearer #{User.first.access_token}").get("https://api.spotify.com/v1/me/playlists")
    render json: response.parse(:json)["items"]
  end

  def create
    # response = HTTP.auth("Bearer #{User.first.access_token}").get("https://api.spotify.com/v1/me")
    # spotify_user_id = response.parse(:json)["id"]
    options = {
      "name": "Sent in Params",
      "description": "well lookie here"
    }
    response = HTTP.auth("Bearer #{User.first.access_token}").post("https://api.spotify.com/v1/users/jnwhisler/playlists", :json => options)
    @created_playlist_id = response.parse(:json)["id"]


    #parse through a given playlist and add selected tracks' uri string 
    uris_array = []
    playlist_source = HTTP.auth("Bearer #{User.first.access_token}").get("https://api.spotify.com/v1/playlists/1fnuSGnTALt3nEQkLjOPq8/tracks")
    playlist_source = playlist_source.parse(:json)
    playlist_source["items"].each do |item| 
      uris_array << item["track"]["uri"]
    end
    uris = {"uris": uris_array}

    HTTP.auth("Bearer #{User.first.access_token}").post("https://api.spotify.com/v1/users/jnwhisler/playlists/#{@created_playlist_id}/tracks", :json => uris)

    render json: response.parse(:json)

  end

  def show
    response = HTTP.auth("Bearer #{User.first.access_token}").get("https://api.spotify.com/v1/playlists/#{params["id"]}/tracks")  
    render json: response.parse(:json)
  end

  def update
    playlist_details = {
      "name": params["name"],
      "description": params["description"]
    }
    response = HTTP.auth("Bearer #{User.first.access_token}").put("https://api.spotify.com/v1/playlists/#{params["id"]}", :json => playlist_details)  

    render json: response
  end

  def destroy
    response = HTTP.auth("Bearer #{User.first.access_token}").delete("https://api.spotify.com/v1/playlists/#{params["id"]}/followers")  
    render json: response
  end
end
