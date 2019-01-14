class AddParentIdToCategory < ActiveRecord::Migration
  def change
    add_column :categories, :parent_id, :string
    add_index :categories, :parent_id
  end
end
