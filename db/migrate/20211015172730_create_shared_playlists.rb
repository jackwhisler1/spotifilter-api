class CreateSharedPlaylists < ActiveRecord::Migration[6.1]
  def change
    create_table :shared_playlists do |t|
      t.string :playlist_id
      t.integer :user_id

      t.timestamps
    end
  end
end
