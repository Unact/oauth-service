class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :access_token
      t.date   :access_token_expires

      t.timestamps null: false

      t.index :access_token, unique: true
    end
  end
end
