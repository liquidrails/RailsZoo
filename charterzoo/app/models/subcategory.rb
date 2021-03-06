class Subcategory < ActiveRecord::Base

validates_uniqueness_of :subname_id, :scope => [:location_id, :category_id]

before_destroy :removable?

  belongs_to  :location
  belongs_to  :category
  belongs_to  :subname
  has_many    :postings

  def to_param
        "#{id}-#{subname.name.gsub(/[^a-z0-9]+/i, '-')}"
  end

#remove if subcategory has no active postings to  it and if status is turned off
  def removable?
    if self.status == 0 && self.postings_count == 0  #move expired posts to another database 7 days after expiration date to get an accurate count
       return true
    elsif self.location_id ==0 && Subcategory.find_all_by_subname_id(self.subname_id).size == 1
      return true
    else
      return false     
    end
  end

end
