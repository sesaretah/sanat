class AddIntegerIdToAdvertisement < ActiveRecord::Migration
  def change
    add_column :advertisements, :integer_id, :integer
  end
end
