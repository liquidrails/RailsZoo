class Cactus::SessionsController < ApplicationController
  def new
  end

  def create  
	@current_user = Administrator.find_by_login(params[:login])

	if @current_user and @current_user.password_is? params[:password]
          @current_user.update_attributes(:last_login=> Time.now)
	  session[:user_id] = @current_user.id
	  #if session[:return_to]
	  #  redirect_to session[:return_to]
          #  session[:return_to] = nil
          #else
            redirect_to cactus_admin_path
          #end
	else
	  render  :action =>'new'
	end
  end

  def destroy
    session[:user_id] = @current_user = nil
  end

end

