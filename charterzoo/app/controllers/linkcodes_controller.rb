class LinkcodesController < ApplicationController


   def index
    @location = params[:location_id]
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @linkcodes }
    end
   end

   def check
    @location = params[:location_id]
    respond_to do |format|
      format.html { render :layout =>"linkcode_check" }# check.html.erb
      format.xml  { render :xml => @linkcodes, :layout =>"linkcode_check" }
    end
   end

end
