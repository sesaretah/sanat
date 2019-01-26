class CreateProvinces < ActiveRecord::Migration
  def change
    create_table :provinces do |t|
      t.string :name
      t.string :uuid

      t.timestamps null: false
    end
    add_index :provinces, :uuid, unique: true
  end
end
