class Posting < ActiveRecord::Base
  #def before_save
  before_create validate
  before_save validate
  before_update validate
  validates_presence_of  :organizer, :email
  validates_format_of :email,
    :with => /^([^@s]+)@((?:[-a-z0-9]+.)+[a-z]{2,})$/i
  validates_confirmation_of :email
  validates_uniqueness_of :headline, :scope => [:email,:departure], :message =>  "; You already have a similar posting for this departure date"


  def validate
  # For Category = 1 ONLY  -- Trips
    if  1 == self.subcategory.category.id
      errors.add("Destination") if "" == self.headline
      errors.add(:return, "should not be blank") if self.return.nil?
      errors.add(:departure, "should not be blank") if self.departure.nil?
      errors.add("Please check whether you want to link this post to a website:  Field") if self.postlink.nil?
      if nil != self.departure
        errors.add(:departure, "cannot be in the past") if self.departure < Date.today
          if self.return?
            errors.add(:return, "must occur on or after departure") if self.duration < 1
          end
      end
      self.departure_year= self.departure.year
      self.departure_month=self.departure.month
    end  
    # END Category=1

    # For Category = 5 ONLY -- Specials
    if  1 == self.subcategory.category.id
      errors.add("Destination") if "" == self.headline
      errors.add(:return, "should not be blank") if self.return.nil?
      errors.add(:departure, "should not be blank") if self.departure.nil?
      if nil != self.departure
        errors.add(:return, "cannot be in the past") if self.departure < Date.today
          if self.return?
            errors.add(:return, "must occur on or after departure") if self.duration < 1
          end
      end
      self.departure_year= self.departure.year
      self.departure_month=self.departure.month
    end  
    # END Category=1

    errors.add("Please select how you would like to display a return email:  email inquiries field") if self.display_email.nil?

    # IPN Validation
      if 1 == self.postlink
        @ipntemp = Ipn.find(:first, :conditions => { :code => self.linkcode  } )
       if nil == @ipntemp
          logger.debug("\none\n")
          self.ipn_id = -99
          self.linkcode = nil
          self.linkemail = nil
       else
            if self.linkemail == @ipntemp.email
               self.ipn_id = @ipntemp.id
               self.postlink = 1
               self.linkcode = @ipntemp.code
               if @ipntemp.postings_count >= 10
                  errors.add("Linkcode has already been used in 10 postings.  To see which postings, click the link 'My Linked Posts' above.")
               end
            else
               self.ipn_id = -99
            end
        end
        errors.add("LINKCODE and/or LINK EMAIL ") if self.ipn_id == -99
      end 
    

    #filter content
    self.headline = self.headline.gsub(/www./i,'').gsub(/http:/i,'').gsub(/.com/,'').gsub(/.info/,'').gsub(/.org/,'').gsub(/\//,'').gsub('www','').gsub('com','')
    self.details = self.details.gsub(/www./i,'').gsub(/http:/i,'').gsub(/.com/,'').gsub(/.info/,'').gsub(/.org/,'').gsub(/\//,'').gsub('www','').gsub('com','')
    self.organizer = self.organizer.gsub(/www./i,'').gsub(/http:/i,'').gsub(/.com/,'').gsub(/.info/,'').gsub(/.org/,'').gsub(/\//,'').gsub('www','').gsub('com','')

  end


 # NAMED SCOPES   http://www.railsrocket.com/articles/rails-21-named-scope
  named_scope :active, :conditions => {:list_status => 1}


 # RELATIONSHIPS
  belongs_to  :subcategory, :counter_cache => true
  belongs_to  :ipn, :counter_cache => true
  belongs_to  :weblink, :counter_cache => true
  has_many  :flags
  has_many  :flagnames, :through => :flags

  is_indexed  :fields => [{:field=>'headline_sort',:sortable=>true}, {:field=>'organizer_sort',:sortable=>true}, {:field=>'details',:sortable=>true}, 'departure_month','departure_year', 'departure','duration', 'created_at', 'subcategory_id','key']    

 end
  
