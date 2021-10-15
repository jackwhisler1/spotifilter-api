class SharedPlaylistsController < ApplicationController
  def index
    playlists = SharedPlaylist.all
    render json: playlists
  end

  def create
    playlist = SharedPlaylist.new(
      playlist_id: params[:playlist_id],
      user_id: params[:user_id]
    )
    if playlist.save
      render json: { message: "Shared playlist created successfully" }, status: :created
    else 
      render json: { errors: user.errors.full_messages }, status: :bad_request
    end
  end

  def show
    playlist = SharedPlaylist.find(params[:id])
    render json: playlist
  end

  def update
    playlist = SharedPlaylist.find(params[:id])
    playlist.playlist_id = params[:playlist_id] || playlist.playlist_id
    playlist.user_id = params[:user_id] || playlist.user_id
    if playlist.save
      render json: playlist
    else
      render json: { errors: playlist.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    playlist = SharedPlaylist.find(params[:id])
    playlist.destroy
    render json: { message: "Shared Playlist successfully deleted." }
  end
end
