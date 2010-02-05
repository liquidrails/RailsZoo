class Cactus::WeblinksController < ApplicationController
  # GET /weblinks
  # GET /weblinks.xml
  def index
    @weblinks = Weblink.find(:all)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => [:cactus,@weblinks] }
    end
  end

  def show
     @weblink = Weblink.find(params[:id], :include => [:postings])
     @postings = @weblink.postings
     respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => [:cactus,@weblinks] }
    end
  end

  def approve
    weblinks=params[:weblink]
    Weblink.update(weblinks.keys,weblinks.values)
    respond_to do |format|
      format.html { redirect_to url_for(:controller =>"cactus/weblinks", :action => "index") }
      format.xml  { head :ok }
    end 
  end

end
