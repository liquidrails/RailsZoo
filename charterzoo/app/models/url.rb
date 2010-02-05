class Url < ActiveRecord::Base
  validates_uniqueness_of :address
  before_destroy  :check_postings_dont_exist

  has_many :postings

private
  def check_postings_dont_exist
    if !postings.empty?
      return false
    end
    return true 
  end


end
