class Location < ActiveRecord::Base
  validates_uniqueness_of :name
  has_many :subcategories
  has_many :categories, :through => :subcategories, :order => 'category.name'

  before_destroy  :check_subcategories_dont_exist


  #is_indexed  :fields => 'name', :eagerly_load =>[:subcategories, :categories]

  def to_param
        "#{id}-#{name.gsub(/[^a-z0-9]+/i, '-')}"
  end

  private

  def check_subcategories_dont_exist
    if !subcategories.empty?
      return false
    end
    return true
  end

end
