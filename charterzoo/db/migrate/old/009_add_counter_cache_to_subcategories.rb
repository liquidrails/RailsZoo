class AddCounterCacheToSubcategories < ActiveRecord::Migration
  def self.up
    add_column :subcategories, :postings_count, :integer, :default => 0
    Subcategory.find(:all).each do |s|
      s.update_attribute :postings_count, s.postings.length
    end
  end

  def self.down
    remove_column :subcategories, :postings_count
  end
end
