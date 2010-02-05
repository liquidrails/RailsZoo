class Flagname < ActiveRecord::Base
  has_many :flags
  has_many :postings, :through => :flags
end
