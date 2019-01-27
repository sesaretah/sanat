class AddPriceToAdvertisement < ActiveRecord::Migration
  def change
    add_column :advertisements, :price, :string
  end
end
