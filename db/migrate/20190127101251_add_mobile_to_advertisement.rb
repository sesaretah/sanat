class AddMobileToAdvertisement < ActiveRecord::Migration
  def change
    add_column :advertisements, :mobile, :string
  end
end
