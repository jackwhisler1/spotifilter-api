class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.string :access_token
      t.string :refresh_token

      t.timestamps
    end
  end
end
