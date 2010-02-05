class PostingsController < ApplicationController

require 'will_paginate'
helper :date

before_filter :authorize, :only => [:edit, :change_status]
  
  # GET /postings
  # GET /postings.xml
  def index
    @category = Category.find(params[:category_id], :include => 'subcategories')
    @location = Location.find(params[:location_id])
    @subcat_array = @category.subcategories.select{|v| v.location_id == @location.id }
    a = []
    for subcat in @subcat_array
       a = [a, subcat.id]
    end
    if nil == params[:query]
      @query_string = ""
      @chunks = nil
    else
      @query = params[:query].strip
      @chunks = self.make_chunks(@query)
      x=0
      y=0

        for chunk in @chunks
          x = x+1
	    if x > 0 && x < @chunks.size && chunk != 'and' && chunk != 'or' && chunk != '^+' && chunk != '^-' && @chunks[x] != 'and' && @chunks[x] != 'or'
                @chunks[y] = chunk + ' or '
            else
		@chunks[y] = chunk + ' '
            end
            y = y+1              
         end
         @query_string = process_chunk(@chunks)
      end 
      filters = {} 
      filters['subcategory_id'] = a.flatten
      @search=Ultrasphinx::Search.new(:query => @query_string, :filters => filters)
      @search.run
      @results = @search.results
      @postings = @results.paginate :page => params[:page],:per_page =>2    

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @postings }
    end
  end


  # GET /postings/1
  # GET /postings/1.xml
  def show
    @posting = Posting.find(params[:id])
    @location = @posting.subcategory.location
    @flagnames = Flagname.find(:all)
    #bf=BloomFilter.new
    respond_to do |format|
      format.html { render :layout =>"postings_show_post"} # show.html.erb
      format.xml  { render :xml => @posting }
    end
  end

  # GET /postings/1
  # GET /postings/1.xml
  def thankyou
    @posting = Posting.find(params[:id])
    @subcategory=Subcategory.find(@posting.subcategory_id, :include=>[:category, :location])
    @location = @subcategory.location
    @category = @subcategory.category

    respond_to do |format|
      format.html {render :layout =>"postings_new_post" }# show.html.erb
      format.xml  { render :xml => @posting }
    end
  end


  # GET /postings/new
  # GET /postings/new.xml
  def new
    @posting = Posting.new
    @location = Location.find(params[:location_id])
    @category = Category.find(params[:category_id])
    @subcategory = Subcategory.find(params[:subcategory_id], :include => [:subname])

    respond_to do |format|
      format.html {render :layout =>"postings_new_post" } # post.html.erb
      format.xml  { render :xml => @posting }
    end
  end

  # GET /postings/1/edit
  def edit
    @posting = Posting.find(params[:id])
    @subcategory=Subcategory.find(@posting.subcategory_id, :include=>[:category, :location])
    @location = @subcategory.location
    @category = @subcategory.category
    logger.debug("\n\nhalloween category is #{@category.id}\n\n")
    respond_to do |format|
      format.html  { render :layout =>"postings_edit_post"}# post.html.erb
      format.xml  { render :xml => @posting }
    end
  end

  # GET /postings/1/flag
  def flag
    @flag = Flag.new
    @flag.posting_id = params[:id]
    @flag.flagname_id = params[:flagname_id]
    @flag.client_ip = request.remote_ip
    if @flag.save
        flash[:notice] = 'Listing was successfully flagged.'
    else
        flash[:notice] = 'Listing was not successfully flagged.'
    end

    respond_to do |format|
       format.html { redirect_to :controller=>'postings', :action=>'show', :id=>params[:id], :layout =>"postings_show_post" }
    end
  end


  # POST /postings/search
  def search
    opt = params[:category][:id].delete "'"
    opt_arr = opt.to_s.split(' ')
    @category = Category.find(opt_arr[1])
    @location = Location.find(params[:location])
    @month = (nil== params[:month] )? -99: params[:month] 
    @year = (nil==params[:year] )? Date.today.year: params[:year]
    if "" == params[:query]
      @query = ""
     if "c" == opt_arr[0]          
       respond_to do |format|
         if -99 == @month.to_i
           format.html { redirect_to( cat_postings_index_by_year_path(@location,@category,@year)) }
         else
           format.html { redirect_to( cat_postings_index_by_month_path(@location,@category,@year,@month)) }
         end
       end
     else
       @subcategory = Subcategory.find(opt_arr[2])
       respond_to do |format|
          if -99 == @month.to_i
            format.html { redirect_to( subcat_postings_index_by_year_path(@location,@category,@subcategory,@year)) }
          else
            format.html { redirect_to( subcat_postings_index_by_month_path(@location,@category,@subcategory,@year,@month)) }
          end
       end
     end
      
    else @query = params[:query]    
      if "c" == opt_arr[0]
        respond_to do |format|
         if -99 == @month.to_i
           format.html { redirect_to( cat_postings_index_by_year_path(@location,@category,@year,:query=>@query)) }
         else
           format.html { redirect_to( cat_postings_index_by_month_path(@location,@category,@year,@month,:query=>@query)) }
         end
        end
      else
        @subcategory = Subcategory.find(opt_arr[2])
        respond_to do |format|  
          if -99 == @month.to_i
            format.html { redirect_to(subcat_postings_index_by_year_path(@location,@category,@subcategory,@year,:query=>@query)) }
          else
            format.html { redirect_to(subcat_postings_index_by_month_path(@location,@category,@subcategory,@year,@month,:query=>@query)) }
          end
        end
      end
    end
  end
  


  # POST /postings
  # POST /postings.xml
  def preview 
    #require 'date'
    #require 'time'
    @subcategory=Subcategory.find(params[:posting][:subcategory_id], :include=>[:category, :location])
    @location = @subcategory.location
    @category = @subcategory.category
    @posting = Posting.new
    @aposting = Posting.new(params[:posting])
    if 1 == @category
      @aposting.duration=@aposting.return - @aposting.departure + 1
    end
    begin
      Posting.transaction do
        if @aposting.valid?
          # throw exception
           raise 'go to preview'  
        else
        @posting = @aposting
	render :action => :new, :layout=>"postings_new_post"      
        end
        Url.transaction(:requires_new => true) do 
          Url.create(:address => @aposting.link)
        end
     end
     rescue 
          flash[:notice] = 'Posting was temporarily created.'
          respond_to do |format|
     	    format.html {render :layout =>"postings_new_post" } # preview.html.erb
            format.xml  { render :xml => @posting, :status => :created }
	  end
       end
  end 
  
  # GET /postings/1
  # GET /postings/1.xml
  def manage
    @posting = Posting.find(params[:id])
    @subcategory = Subcategory.find(@posting.subcategory_id)
    @category=@posting.subcategory.category
    @location = Location.find(@posting.subcategory.location)
    respond_to do |format|
      format.html { render :layout =>"postings_publish_post"} # show.html.erb
      format.xml  { render :xml => @posting }
    end
  end


  # POST /postings
  # POST /postings.xml
  def submit
    @posting = Posting.new(params[:posting])
    if 1 == @posting.postlink && -99 != @posting.ipn_id
      @ipn = Ipn.find(params[:posting][:ipn_id])
      @posting.ipn = @ipn
    end
    @subcategory=Subcategory.find(params[:posting][:subcategory_id], :include=>[:category, :location])
    @location = @subcategory.location
    @category = @subcategory.category
    if params[:commit] == "edit"
	render :action => :new
     elsif params[:commit] == "post" #and simple_captcha_valid?
      if !simple_captcha_valid?
         @aposting=@posting
         flash[:notice] = 'Please reenter verification code.'
         render :action => :preview
         return
      end
     @posting.key = genRandomKey()
     @posting.headline_sort = params[:posting][:headline].downcase
     @posting.organizer_sort = params[:posting][:organizer].downcase
     
     if 1 == @posting.display_email.to_i #anonymize email
        logger.debug("\nDisplay Email is #{@posting.display_email+'dog'}\n")
        @posting.display_email = genRandomKey()+'@charterzoo.com'
     else
        logger.debug("\nDisplay Email is #{@posting.display_email+'cat'} and is NOT 1!\n")
        @posting.display_email = @posting.email
     end 
     respond_to do |format|
      if @posting.save
        flash[:notice] = 'Posting has been created.'
        format.html { redirect_to(thankyou_posting_path(@posting,  @posting.key)) }
        format.xml  { render :xml => @posting, :status => :created }
      else
        format.html { redirect_to(new_location_category_subcategory_post_path(@location, @category, @subcategory)) }
        format.xml  { render :xml => @posting.errors, :status => :unprocessable_entity }
      end
     end
    else
       render :action => :new      
    end
  end
  # PUT /postings/1
  # PUT /postings/1.xml

  def update
    @posting = Posting.find(params[:id])
    @subcategory=Subcategory.find(params[:posting][:subcategory_id], :include=>[:category, :location])
    @location = @subcategory.location
    @category = @subcategory.category
    logger.debug("\n\nChristmas category is #{@category.id} for posting #{@posting.id}\n\n")
    respond_to do |format|
      if @posting.update_attributes(params[:posting])
        flash[:notice] = 'Posting was successfully updated.'
        format.html { redirect_to(:action=>'show',:id=>@posting.id) }
        format.xml  { head :ok }
      else   #render form again like in preview
          flash[:notice] = 'Posting could not be updated.'
        format.html { render :action=>'edit',:id=>@posting.id,:key=>@posting.key,:layout =>"postings_edit_post" }
        format.xml  { head :ok }
      end
    end
  end


  # CHANGE_STATUS /postings/1
  # CHANGE_STATUS /postings/1.xml
  def change_status
    @posting = Posting.find(params[:id])
    if params[:commit] == "Delete"
       num = 2
       message = "Posting has been deleted"
    elsif params[:commit] == "Publish"
       num = 1
       message = "Posting has been published and will expire in 30 days"
    end 
    #@posting.update_attribute("expiration_date", Time.now)

    respond_to do |format|
      if @posting.update_attribute("status", num.to_i)
        flash[:notice] = message.to_s
        format.html { redirect_to(@posting) }
        format.xml  { head :ok }
      else
        #format.html { render :action => "edit" + key } find out about redirect_to path
        format.xml  { render :xml => @posting.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /postings/1
  # DELETE /postings/1.xml
  def destroy
    @posting = Posting.find(params[:id])
    @posting.destroy

    respond_to do |format|
      format.html { redirect_to(postings_url) }
      format.xml  { head :ok }
    end
  end

protected

  def genRandomKey
    def String.random_alphanumeric(size=16)
    (1..size).collect { (i=Kernel.rand(62); i+=((i<10)?48:((i<36)?55:61))).chr}.join
    end
    return String.random_alphanumeric()
  end

  def genRandomEmail
    def newpass(len= 8)
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    newpass = ""
    1.upto(len) { |i| newpass << chars[rand(chars.size-1)] }
    return newpass()
    end
  end

#---------------------------------------------------------


  # A chunk is a string of non-whitespace,
    # except that anything inside double quotes
    # is a chunk, including whitespace
    def make_chunks(s)
      chunks = []
      while s.length > 0
        next_interesting_index = (s =~ /\s|\"/)
        if next_interesting_index
          if next_interesting_index > 0
            chunks << s[0...next_interesting_index]
            s = s[next_interesting_index..-1]
          else
            if s =~ /^\"/
              s = s[1..-1]
              next_interesting_index = (s =~ /[\"]/)
              if next_interesting_index
                chunks << s[0...next_interesting_index]
                s = s[next_interesting_index+1..-1]
              elsif s.length > 0
                chunks << s
                s = ''
              end
            else
              next_interesting_index = (s =~ /\S/)
              s = s[next_interesting_index..-1]
            end
          end
        else
          chunks << s
          s = ''
        end
      end

      chunks
    end

def process_chunk(chunk)
      case chunk
      when /^-/
        if chunk.length  1
          [:not]
        else
          [:not, *process_chunk(chunk[1..-1])]
        end
      when /^\(.*\)$/
        if chunk.length  2
          [:left_paren, :right_paren]
       else          
[:left_paren].concat(process_chunk(chunk[1..-2])) << :right_paren
        end
      when /^\(/
        if chunk.length  1
          [:left_paren]
        else
          [:left_paren].concat(process_chunk(chunk[1..-1]))
        end
      when /\)$/
        if chunk.length  1
          [:right_paren]
        else
          process_chunk(chunk[0..-2]) << :right_paren
        end
      when 'and'
        [:and]
      when 'or'
        [:or]
      when 'not'
        [:not]
      else
        [chunk]
      end
    end

    def lex(s)
      tokens = []

      make_chunks(s).each { |chunk|
        tokens.concat(process_chunk(chunk))
      }

      tokens
    end


   def authorize
     @posting = Posting.find(params[:id])
     unless params[:key] == @posting.key
       render :nothing => true,:status => 404
       return false
     end
   end
end
