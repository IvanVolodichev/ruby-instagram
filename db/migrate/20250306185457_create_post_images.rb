class CreatePostImages < ActiveRecord::Migration[8.0]
  def change
    create_table :post_images do |t|
      t.references :post, null: false, foreign_key: { on_delete: :cascade }
      t.string :image_url, null: false, limit: 255
      t.timestamps
    end
  end
end
