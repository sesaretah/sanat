class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.string :device_uuid
      t.string :fcm_token
      t.integer :user_id
      t.string :uuid

      t.timestamps null: false
    end
    add_index :devices, :device_uuid
    add_index :devices, :fcm_token
    add_index :devices, :user_id
    add_index :devices, :uuid, unique: true
  end
end
