class SharedPlaylist < ApplicationRecord
  belongs_to :user
  # This assoc. will be a custom method
  # belongs_to :playlist
end
