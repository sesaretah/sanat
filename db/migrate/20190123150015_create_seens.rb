class CreateSeens < ActiveRecord::Migration
  def change
    create_table :seens do |t|
      t.string :room_id
      t.integer :user_id
      t.string :uuid

      t.timestamps null: false
    end
    add_index :seens, :room_id
    add_index :seens, :uuid, unique: true
  end
end
