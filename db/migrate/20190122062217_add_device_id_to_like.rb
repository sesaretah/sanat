class AddDeviceIdToLike < ActiveRecord::Migration
  def change
    add_column :likes, :device_id, :string
  end
end
