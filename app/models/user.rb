class User < ApplicationRecord
  has_secure_password
  validates :email, presence: true, uniqueness: true
  # These are breaking the app for some reason
  # validates :password, presence: true, on: :create
  # validates :password_confirmation, presence: true, on: :update
  has_many :shared_playlists
end
