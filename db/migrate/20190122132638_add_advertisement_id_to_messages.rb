class AddAdvertisementIdToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :advertisement_id, :string
    add_index :messages, :advertisement_id
  end
end
