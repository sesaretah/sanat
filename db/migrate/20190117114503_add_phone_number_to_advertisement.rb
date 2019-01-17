class AddPhoneNumberToAdvertisement < ActiveRecord::Migration
  def change
    add_column :advertisements, :phone_number, :string
  end
end
