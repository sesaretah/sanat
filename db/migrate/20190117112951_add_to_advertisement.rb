class AddToAdvertisement < ActiveRecord::Migration
  def change
    add_column :advertisements, :address, :string
    add_column :advertisements, :province_id, :string
    add_column :advertisements, :city, :string
    add_column :advertisements, :email, :string
    add_column :advertisements, :telegram_channel, :string
    add_column :advertisements, :instagram_page, :string
    add_column :advertisements, :website, :string
  end
end
