class Cactus::SubnamesController < ApplicationController
  # GET /subnames
  # GET /subnames.xml
  def index
    @subnames = Subname.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => [:cactus,@subnames] }
    end
  end

  # GET /subnames/1
  # GET /subnames/1.xml
  def show
    @subname = Subname.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => [:cactus,@subname] }
    end
  end

  # GET /subnames/new
  # GET /subnames/new.xml
  def new
    @subname = Subname.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => [:cactus,@subname] }
    end
  end

  # GET /subnames/1/edit
  def edit
    @subname = Subname.find(params[:id])
  end

  # POST /subnames
  # POST /subnames.xml
  def create
    @subname = Subname.new(params[:subname])

    respond_to do |format|
      if @subname.save
        flash[:notice] = 'Subname was successfully created.'
        format.html { redirect_to([:cactus,@subname]) }
        format.xml  { render :xml => [:cactus,@subname], :status => :created, :location => @subname }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @subname.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /subnames/1
  # PUT /subnames/1.xml
  def update
    @subname = Subname.find(params[:id])

    respond_to do |format|
      if @subname.update_attributes(params[:subname])
        flash[:notice] = 'Subname was successfully updated.'
        format.html { redirect_to([:cactus,@subname]) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @subname.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /subnames/1
  # DELETE /subnames/1.xml
 def destroy
    @subname = Subname.find(params[:id])
    if @subname.destroy
      flash[:notice] = 'Subname successfully destroyed'
    else
      flash[:notice] = 'Could not delete subname'
    end
    #rescue ApplicationError => msg
    #  flash[:warning] = msg.to_s
    #end
    respond_to do |format|
      format.html { redirect_to(cactus_subnames_url) }
      format.xml  { head :ok }
      end
  end
end
