class CreateLikes < ActiveRecord::Migration
  def change
    create_table :likes do |t|
      t.string :likeable_id
      t.string :likeale_type
      t.string :uuid

      t.timestamps null: false
    end
    add_index :likes, :likeable_id
    add_index :likes, :likeale_type
    add_index :likes, :uuid, unique: true
  end
end
