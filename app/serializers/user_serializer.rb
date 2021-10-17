class UserSerializer < ActiveModel::Serializer
  has_many :shared_playlists
  attributes :id, :name, :email, :access_token, :refresh_token
end
