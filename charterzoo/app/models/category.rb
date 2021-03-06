class Category < ActiveRecord::Base
  validates_uniqueness_of :name
  before_destroy  :check_subcategories_dont_exist

  has_many :subcategories
  has_many :locations, :through => :subcategories

  def to_param
        "#{id}-#{name.gsub(/[^a-z0-9]+/i, '-')}"
  end

    def post
      render :action => "post", :layout => "postings"
    end

private
  def check_subcategories_dont_exist
    if !subcategories.empty?
      return false
    end
    return true 
  end


end
