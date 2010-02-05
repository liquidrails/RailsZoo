class Flag < ActiveRecord::Base

  belongs_to  :posting, :counter_cache => true
  belongs_to  :flagname, :counter_cache => true

end
