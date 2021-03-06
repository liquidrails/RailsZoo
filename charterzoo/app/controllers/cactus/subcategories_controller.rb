class Cactus::SubcategoriesController < ApplicationController

 before_filter  :fetch_logged_in_user
 before_filter  :login_required

  # GET /subcategories
  # GET /subcategories.xml
  def index
    @subcategories = Subcategory.find(:all, :include => [:subname], :order=>'name')
    @categories = Category.find(:all, :order=> :name)
    @locations = Location.find(:all, :order=> :name)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => [:cactus,@subcategories] }
    end
  end

  # GET /subcategories/1
  # GET /subcategories/1.xml
  def show
    @subcategory = Subcategory.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => [:cactus,@subcategory] }
    end
  end

  # GET /subcategories/new
  # GET /subcategories/new.xml
  def new
    @subcategory = Subcategory.new
    @subname = Subname.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => [:cactus,@subcategory] }
    end
  end

  # GET /subcategories/1/edit
  def edit
    @subcategory = Subcategory.find(params[:id])
    @subname = Subname.find(@subcategory.subname_id)
   
  end

  # POST /subcategories
  # POST /subcategories.xml
  def create
    @subcategory = Subcategory.new(params[:subcategory])
    @subname = Subname.new(params[:subname])
    respond_to do |format|
      if @subname.save 
 	if @subcategory.save 
             @subcategory.update_attributes(:subname_id => @subname.id)
             flash[:notice] = "Subcategory #{@subname.name} was successfully created."
             format.html { redirect_to([:cactus,@subcategory]) }
             format.xml  { render :xml => [:cactus,@subcategory], :status => :created, :location => @subcategory }
        end
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @subcategory.errors, :status => :unprocessable_entity }
      end
  end
end

def add
    @subcategory = Subcategory.new(params[:subcategory])

    respond_to do |format|
      if @subcategory.save
        flash[:notice] = 'Subcategory was successfully created.'
        format.html { redirect_to url_for(:controller =>"cactus/admin", :action => "index")  }
        format.xml  { head :ok }
      else
        flash[:notice] = 'Subcategory was not successfully created.'
        format.html { redirect_to url_for(:controller =>"cactus/admin", :action => "index") }
        format.xml  { render :xml => @subcategory.errors, :status => :unprocessable_entity }
      end
    end
  end

  
  # PUT /subcategories/1
  # PUT /subcategories/1.xml
  def update
    @subcategory = Subcategory.find(params[:id])
    @subname = Subname.find(@subcategory.subname_id)

    respond_to do |format|
      if @subcategory.update_attributes(params[:subcategory])
        if @subname.update_attributes(params[:subname])
        flash[:notice] = 'Subcategory was successfully updated.'
        format.html { redirect_to([:cactus,@subcategory]) }
        format.xml  { head :ok }
        end
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @subcategory.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /subcategories/1
  # DELETE /subcategories/1.xml

def destroy
#find all subcategories where subname id is = to given subname id
    @subcategories = Subcategory.find_all(:conditions => [":subname_id =?", subname_id])
#Go through each subcategory and see if it is removable
    for subcategory in @subcategories
       subcategory.destroy
    end
#then see whether the subname has any associated subcategories.  if it doesn't, destroy it.
    @subcategories = Subcategory.find_all(:conditions =>  [":subname_id =?", subname_id])
     if @subcategories.length>1
        @subname.destroy
     end
#end
      flash[:notice] = 'Operation complete'

    respond_to do |format|
      format.html { redirect_to url_for(:controller =>"cactus/admin", :action => "index") }
      format.xml  { head :ok }
      end
  end


  def remove
   Subcategory.update(params[:id], { :status => '0' })
   flash[:notice] = 'Subcategory successfully turned off'
   respond_to do |format|
      format.html { redirect_to url_for(:controller =>"cactus/admin", :action => "index") }
      format.xml  { head :ok }
   end
  end

  def restore
   Subcategory.update(params[:id], { :status => '1' })
   flash[:notice] = 'Subcategory successfully turned on'
   respond_to do |format|
      format.html { redirect_to url_for(:controller =>"cactus/admin", :action => "index") }
      format.xml  { head :ok }
   end
  end
   

  def ddestroy
    @subcategory = Subcategory.find(params[:id])
    if @subcategory.location_id == 0
        @subname = Subname.find(@subcategory.subname_id)
        @subcat_array = Subcategory.find(:all, :conditions => ['subname_id=?', 	@subcategory.subname_id])
        subcatName=@subname.name
      if @subcat_array.size > 1
     	flash[:notice] = 'Cannot delete subcategory.'
        redirect_to(cactus_subcategories_url) 
        return
      else
        @subname.destroy
      end
    end
    flash[:notice] = "Subcategory #{subcatName} has been deleted."
    @subcategory.destroy


    respond_to do |format|
      format.html { redirect_to(cactus_subcategories_url) }
      format.xml  { head :ok }
    end
  end

end
