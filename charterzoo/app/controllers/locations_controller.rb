class LocationsController < ApplicationController
  # GET /locations
  # GET /locations.xml

  # GET /locations/1
  # GET /locations/1.xml
  def index
    if nil == params[:id]
       params[:id] = 2
    end

   @postings=Posting.find(:all)
   for post in @postings
     if nil != post.organizer
       post.update_attribute(:organizer_sort,post.organizer.downcase)
     end
   end


    @locations = Location.find(:all, :order => 'name')
    @location = Location.find(params[:id], :include => [:categories], :order=> 'categories.order')
    @categories = @location.categories
    @subcategories = @location.subcategories

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @location }
    end
  end



  # GET /locations/1
  # GET /locations/1.xml
  def show
    if nil == params[:id]
       params[:id] = 2
    end
    @locations = Location.find(:all, :order => 'name')
    #@location = Location.find(params[:id], :include => [:categories, {:subcategories=> [:subname, :category]}])
    @location = Location.find(params[:id], :include => [:categories])
    @categories = @location.categories
    @subcategories = @location.subcategories


    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @location }
    end
  end

  # GET /locations/new
  # GET /locations/new.xml
  def post
    @posting = Posting.new
  @location = Location.find(params[:location_id], :include => [:categories, :subcategories], :order => "categories.name")
    @categories = @location.categories

    respond_to do |format|
      format.html {render :layout =>"locations_new_post" }  # new.html.erb 
      format.xml  { render :xml => @location }
    end
  end


  # GET /locations/1/edit
  def edit
    @location = Location.find(params[:id])
  end

  # POST /locations
  # POST /locations.xml
  def ccreate
    @location = Location.find(params[:id])  
    @category = Category.find(params[:posting][:temp])
    respond_to do |format|
      #if @location.save
        #flash[:notice] = 'Location was successfully created.'
        format.html { redirect_to(new_location_category_post_path(@location,@category)) }
        #format.xml  { render :xml => @location, :status => :created, :location => @location }
      #else
        #.html { render :action => "new" }
        #format.xml  { render :xml => @location.errors, :status => :unprocessable_entity }
      #end
    end
  end

  # PUT /locations/1
  # PUT /locations/1.xml
  def update
    @location = Location.find(params[:id])

    respond_to do |format|
      if @location.update_attributes(params[:location])
        flash[:notice] = 'Location was successfully updated.'
        format.html { redirect_to(@location) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @location.errors, :status => :unprocessable_entity }
      end
    end
  end

  
end
