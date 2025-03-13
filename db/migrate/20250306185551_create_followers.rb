class CreateFollowers < ActiveRecord::Migration[8.0]
  def change
    create_table :followers do |t|
      t.references :follower, foreign_key: { to_table: :users }
      t.references :following, foreign_key: { to_table: :users }
      t.timestamps
    end
    add_index :followers, [ :follower_id, :following_id ], unique: true
    add_check_constraint :followers, 'follower_id != following_id', name: 'no_self_follow'
  end
end
