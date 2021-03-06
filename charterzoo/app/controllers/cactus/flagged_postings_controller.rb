class Cactus::FlaggedPostingsController < ApplicationController

# GET /cactus_flagged_postings
# GET /cactus_flagged_postings.xml
  def index
    @flagged_postings = Posting.find(:all, :conditions => "flags_count > '0'")
    @flagnames = Flagname.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @flagged_postings }
    end
  end

end
