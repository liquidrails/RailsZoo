class Cactus::FlagnamesController < ApplicationController
  # GET /cactus_flagnames
  # GET /cactus_flagnames.xml
  def index
    @flagnames = Flagname.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @flagnames }
    end
  end

  # GET /flagnames/1
  # GET /flagnames/1.xml
  def show
    @flagname = Flagname.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @flagname }
    end
  end

  # GET /flagnames/new
  # GET /flagnames/new.xml
  def new
    @flagname = Flagname.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @flagname }
    end
  end

  # GET /cactus_flagnames/1/edit
  def edit
    @flagname = Flagname.find(params[:id])
  end

  # POST /flagnames
  # POST /flagnames.xml
  def create
    @flagname = Flagname.new(params[:flagname])

    respond_to do |format|
      if @flagname.save
        flash[:notice] = 'Flagname was successfully created.'
        format.html { redirect_to([:cactus,@flagname]) }
        format.xml  { render :xml => [:cactus,@flagname], :status => :created, :location => [:cactus,@flagname] }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @flagname.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /flagnames/1
  # PUT /flagnames/1.xml
  def update
    @flagname = Flagname.find(params[:id])

    respond_to do |format|
      if @flagname.update_attributes(params[:flagname])
        flash[:notice] = 'Flagname was successfully updated.'
        format.html { redirect_to([:cactus,@flagname]) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @flagname.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /flagnames/1
  # DELETE /flagnames/1.xml
  def destroy
    @flagname = Flagname.find(params[:id])
    @flagname.destroy

    respond_to do |format|
      format.html { redirect_to(cactus_flagnames_url) }
      format.xml  { head :ok }
    end
  end
end
