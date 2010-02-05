class Subname < ActiveRecord::Base

  before_destroy  :check_subcategories_dont_exist

  has_many :subcategories

private
  def check_subcategories_dont_exist
    if !subcategories.empty?
      return false
    end
    return true 
  end

end
