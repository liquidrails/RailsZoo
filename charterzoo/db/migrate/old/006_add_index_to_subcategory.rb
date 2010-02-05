class AddIndexToSubcategory < ActiveRecord::Migration
  def self.up
    add_index  :subcategories, [:location_id, :category_id]
  end

  def self.down
    remove_index  :subcategories, [:location_id, :category_id]
  end
end
