class Ipn < ActiveRecord::Base

  validates_uniqueness_of :transaction_id,
                          :on => :create
  has_many :postings
  serialize :params
 
end
