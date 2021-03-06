class Cactus::ButterwordsController < ApplicationController
before_filter  :fetch_logged_in_user

  # GET /butterwords
  # GET /butterwords.xml
  def index
    @butterwords = Butterword.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @butterwords }
    end
  end

  # GET /butterwords/1
  # GET /butterwords/1.xml
  def show
    @butterword = Butterword.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @butterword }
    end
  end

  # GET /butterwords/new
  # GET /butterwords/new.xml
  def new
    @butterword = Butterword.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @butterword }
    end
  end

  # GET /butterwords/1/edit
  def edit
    @butterword = Butterword.find(params[:id])
  end

  # POST /butterwords
  # POST /butterwords.xml
  def create
    @butterword = Butterword.new(params[:butterword])

    respond_to do |format|
      if @butterword.save
        flash[:notice] = 'Butterword was successfully created.'
        format.html { redirect_to([:cactus,@butterword]) }
        format.xml  { render :xml => [:cactus,@butterword], :status => :created, :location => [:cactus,@butterword] }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @butterword.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /butterwords/1
  # PUT /butterwords/1.xml
  def update
    @butterword = Butterword.find(params[:id])

    respond_to do |format|
      if @butterword.update_attributes(params[:Butterword])
        flash[:notice] = 'Butterword was successfully updated.'
        format.html { redirect_to(@Butterword) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @Butterword.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /butterwords/1
  # DELETE /butterwords/1.xml
  def destroy
    @butterword = Butterword.find(params[:id])
    @butterword.destroy

    respond_to do |format|
      format.html { redirect_to(cactus_butterwords_url) }
      format.xml  { head :ok }
    end
  end
end
