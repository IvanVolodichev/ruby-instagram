class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :username, limit: 50, null: false
      t.string :email, limit: 100, null: false
      t.string :encrypted_password, null: false
      t.text :bio, limit: 500
      t.timestamps
    end
    add_index :users, :username, unique: true
    add_index :users, :email, unique: true
  end
end
