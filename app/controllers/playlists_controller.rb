class PlaylistsController < ApplicationController
  def index
    response = HTTP.auth("Bearer #{User.first.access_token}").get("https://api.spotify.com/v1/me/playlists")
    render json: response.parse(:json)["items"]
  end

  def create
    # response = HTTP.auth("Bearer #{User.first.access_token}").get("https://api.spotify.com/v1/me")
    # spotify_user_id = response.parse(:json)["id"]
    options = {
      "name": "#{params["name"]} Filtered",
      "description": "Exercise Playlist created by SpotiFilter"
    }
    response = HTTP.auth("Bearer #{User.first.access_token}").post("https://api.spotify.com/v1/users/jnwhisler/playlists", :json => options)
    @created_playlist_id = response.parse(:json)["id"]


    #parse through a given playlist and add selected tracks' uri string 
    uris_array = []
    track_ids = ""
    playlist_source = HTTP.auth("Bearer #{User.first.access_token}").get("https://api.spotify.com/v1/playlists/#{params["id"]}/tracks")
    playlist_source = playlist_source.parse(:json)
    # render json: playlist_source.parse(:json)
    playlist_source["items"].each do |song| 
      uris_array << song["track"]["uri"]
      track_ids += "#{song["track"]["id"].to_s},"
    end
    track_ids = track_ids.delete_suffix(',')
    uris = {"uris": uris_array}
    # render json: {string: track_ids}

    # Get audio features for all tracks
    response = HTTP.auth("Bearer #{User.first.access_token}").get("https://api.spotify.com/v1/audio-features?ids=#{track_ids}")
    # Sort by highest energy 
    audio_features = response.parse(:json)["audio_features"]
    audio_features = audio_features.sort! {|a, b| b["energy"] <=> a["energy"] }
    
    # Limits to top 20
    audio_features = audio_features[0..19]
    final_playlist = []
    audio_features.each do |song|
      final_playlist << song["uri"]
    end
    final_playlist_object = {"uris": final_playlist}

    # Create playlist with top 20 energy
    HTTP.auth("Bearer #{User.first.access_token}").post("https://api.spotify.com/v1/users/jnwhisler/playlists/#{@created_playlist_id}/tracks", :json => final_playlist_object)


    # get new playlist
    created_playlist = HTTP.auth("Bearer #{User.first.access_token}").get("https://api.spotify.com/v1/playlists/#{@created_playlist_id}")
    #
    render json: created_playlist.parse(:json)

  end

  def show
    response = HTTP.auth("Bearer #{User.first.access_token}").get("https://api.spotify.com/v1/playlists/#{params["id"]}")
    render json: response.parse(:json)
  end

  def update
    playlist_details = {
      "name": params["name"],
      "description": params["description"]
    }
    HTTP.auth("Bearer #{User.first.access_token}").put("https://api.spotify.com/v1/playlists/#{params["id"]}", :json => playlist_details)  

    response = HTTP.auth("Bearer #{User.first.access_token}").get("https://api.spotify.com/v1/playlists/#{params["id"]}/tracks")  
    render json: response.parse(:json)
  end

  def destroy
    response = HTTP.auth("Bearer #{User.first.access_token}").delete("https://api.spotify.com/v1/playlists/#{params["id"]}/followers")  
    render json: {message: "Playlist unfollowed (API doesn't allow for permanent deletion)"}
  end
end
