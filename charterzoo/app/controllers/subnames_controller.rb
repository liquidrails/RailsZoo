class SubnamesController < ApplicationController
  # GET /subnames
  # GET /subnames.xml
  def index
    @subnames = Subname.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @subnames }
    end
  end

  # GET /subnames/1
  # GET /subnames/1.xml
  def show
    @subname = Subname.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @subname }
    end
  end

  # GET /subnames/new
  # GET /subnames/new.xml
  def new
    @subname = Subname.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @subname }
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
        format.html { redirect_to(@subname) }
        format.xml  { render :xml => @subname, :status => :created, :location => @subname }
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
        format.html { redirect_to(@subname) }
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
    @subname.destroy

    respond_to do |format|
      format.html { redirect_to(subnames_url) }
      format.xml  { head :ok }
    end
  end
end
