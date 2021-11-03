class PlaylistsController < ApplicationController
  def index
    options = {
      limit: 50,
      offset: 0
    }
    response = HTTP.auth("Bearer #{User.first.access_token}").get("https://api.spotify.com/v1/me/playlists", :params => options)
    playlists = response.parse(:json)["items"]
    total_playlists = response.parse(:json)["total"].to_i
    total_playlists = total_playlists - 50

    while total_playlists > 0
      options[:offset] += 50
      response = HTTP.auth("Bearer #{User.first.access_token}").get("https://api.spotify.com/v1/me/playlists", :params => options)
      playlists += response.parse(:json)["items"]
      total_playlists = total_playlists - 50
    end

    render json: playlists
  end

  def create
    # response = HTTP.auth("Bearer #{User.first.access_token}").get("https://api.spotify.com/v1/me")
    # spotify_user_id = response.parse(:json)["id"]
    options = {
      "name": "#{params["name"]} (#{params["filter"]})",
      "description": "#{params["filter"]} Playlist created by SpotiFilter"
    }
    response = HTTP.auth("Bearer #{User.first.access_token}").post("https://api.spotify.com/v1/users/jnwhisler/playlists", :json => options)
    @created_playlist_id = response.parse(:json)["id"]


    #parse through a given playlist and add selected tracks' uri string 
    uris_array = []
    track_ids = ""
    playlist_source = HTTP.auth("Bearer #{User.first.access_token}").get("https://api.spotify.com/v1/playlists/#{params["id"]}")
    playlist_source = playlist_source.parse(:json)["tracks"]["items"]
    # render json: playlist_source.parse(:json)
    playlist_source.each do |song| 
      uris_array << song["track"]["uri"]
      track_ids += "#{song["track"]["id"].to_s},"
    end
    track_ids = track_ids.delete_suffix(',')
    uris = {"uris": uris_array}
    # render json: {string: track_ids}

    # Get audio features for all tracks
    response = HTTP.auth("Bearer #{User.first.access_token}").get("https://api.spotify.com/v1/audio-features?ids=#{track_ids}")
    # Sort by audio features 
    audio_features = response.parse(:json)["audio_features"]

    # Choose filter attribute
    if params["filter"] === "High Energy"
      audio_features = audio_features.sort! {|a, b| b["energy"] <=> a["energy"] }
    elsif params["filter"] === "Calm"
      audio_features = audio_features.sort! {|a, b| a["energy"] <=> b["energy"] }
    elsif params["filter"] === "Dance"
      audio_features = audio_features.sort! {|a, b| b["danceability"] <=> a["danceability"] }
    elsif params["filter"] === "Faster Tempo"
      audio_features = audio_features.sort! {|a, b| b["tempo"] <=> a["tempo"] }
    elsif params["filter"] === "Slower Tempo"
      audio_features = audio_features.sort! {|a, b| a["tempo"] <=> b["tempo"] }
    end
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

    response = HTTP.auth("Bearer #{User.first.access_token}").get("https://api.spotify.com/v1/playlists/#{params["id"]}")  
    render json: response.parse(:json)
  end

  def destroy
    response = HTTP.auth("Bearer #{User.first.access_token}").delete("https://api.spotify.com/v1/playlists/#{params["id"]}/followers")  
    render json: {message: "Playlist unfollowed (API doesn't allow for permanent deletion)"}
  end
end
