class SharedPlaylistSerializer < ActiveModel::Serializer
  belongs_to :user
  attributes :id, :playlist_id, :user_id
end
