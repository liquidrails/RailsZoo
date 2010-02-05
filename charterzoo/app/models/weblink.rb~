class Weblink < ActiveRecord::Base

  #before_create validate
  #before_save validate
  #before_update validate
  #validates_uniqueness_of :address
  #before_destroy  :check_postings_dont_exist
  has_many :postings, :dependent => :destroy


 def validate
    logger.debug("\n\nIn weblink model validate method!!\n\n")
    errors.add(:address, "must be specified") if self.address.nil?
 end

private
  def check_postings_dont_exist
    if !postings.empty?
      return false
    end
    return true 
  end

end
