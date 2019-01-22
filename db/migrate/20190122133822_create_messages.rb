class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :user_id
      t.string :room_id
      t.string :content
      t.string :uuid

      t.timestamps null: false
    end
    add_index :messages, :room_id
    add_index :messages, :uuid, unique: true
  end
end
