class CreateUsers < ActiveRecord::Migration
  def change
    create_table :oauth_service_oauth_users do |t|
      t.string :name
      t.string :email

      t.timestamps null: false
    end

    create_table :oauth_service_oauth_clients do |t|
      t.string :name
      t.string :client_id
      t.string :client_secret
      t.string :redirect_uri

      t.timestamps null: false

      t.index :client_id, unique: true
      t.index :client_secret, unique: true
    end

    create_table :oauth_service_oauth_authorization_codes do |t|
      t.integer :oauth_user_id
      t.integer :oauth_client_id
      t.string :code
      t.datetime :code_expires
      t.string :refresh_token

      t.index :code, unique: true
      t.index :refresh_token, unique: true
      t.timestamps null: false
    end

    create_table :oauth_service_oauth_access_tokens do |t|
      t.integer :oauth_user_id
      t.integer :oauth_client_id
      t.string :access_token
      t.datetime :expires

      t.index :access_token, unique: true
      t.timestamps null: false
    end
  end
end
