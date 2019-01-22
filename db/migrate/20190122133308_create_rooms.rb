class CreateRooms < ActiveRecord::Migration
  def change
    create_table :rooms do |t|
      t.string :advertisement_id
      t.integer :user_id
      t.string :uuid

      t.timestamps null: false
    end
    add_index :rooms, :advertisement_id
    add_index :rooms, :uuid, unique: true
  end
end
