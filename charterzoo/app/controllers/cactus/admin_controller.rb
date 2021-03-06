class Cactus::AdminController < ApplicationController

 before_filter  :fetch_logged_in_user
 before_filter  :login_required, :except => :register
 before_filter  :master_login_required, :only => "register" 

 def index
    @subcategories = Subcategory.find(:all, :include => [:subname])
    @categories = Category.find(:all, :order=> :name)
    @locations = Location.find(:all, :order=> :name)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => [:cactus,@subcategories] }
    end
  end

  def register
    if request.post?
      @user = Administrator.new params[:user]
      if @user.save
        flash[:info] = 'You are registered now'
      end
    end
  end

 def rollcall
    @administrators = Administrator.find(:all)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => [:cactus,@administrators] }
    end
  end

end
