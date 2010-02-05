class AddIndexToCategory < ActiveRecord::Migration
  def self.up
    add_index  :categories, :name
  end

  def self.down
    remove_index  :categories, :name
  end
end
