class CreatePins < ActiveRecord::Migration
  def change
    create_table :pins do |t|
      t.string :advertisement_id
      t.string :uuid
      t.integer :user_id
      t.string :device_id

      t.timestamps null: false
    end
    add_index :pins, :advertisement_id
    add_index :pins, :uuid, unique: true
    add_index :pins, :device_id
  end
end
