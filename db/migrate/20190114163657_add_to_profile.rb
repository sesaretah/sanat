class AddToProfile < ActiveRecord::Migration
  def change
      add_column :profiles, :address, :string
      add_column :profiles, :province_id, :string
      add_column :profiles, :city, :string
      add_column :profiles, :email, :string
      add_column :profiles, :telegram_channel, :string
      add_column :profiles, :instagram_page, :string
      add_column :profiles, :website, :string
  end
end
