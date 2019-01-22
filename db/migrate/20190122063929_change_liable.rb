class ChangeLiable < ActiveRecord::Migration
  def change
    rename_column :likes, :likeale_type, :likeable_type
  end
end
