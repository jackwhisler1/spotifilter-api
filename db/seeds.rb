# user = User.new(
#   "name": "Bob",
#   "email": "bob@gmail.com",
#   "password": "password",
#   "password_confirmation": "password"
# )
# user.save()
playlist = SharedPlaylist.new(
  "playlist_id": "asdfui2384jkasdfl",
  "user_id": 1
)
playlist.save()
playlist = SharedPlaylist.new(
  "playlist_id": "aASDERas4jkasdfl",
  "user_id": 1
)
playlist.save()
playlist = SharedPlaylist.new(
  "playlist_id": "aJFIENV38dfl",
  "user_id": 2
)
playlist.save()
