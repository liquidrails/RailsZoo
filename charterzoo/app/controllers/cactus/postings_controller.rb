class Cactus::PostingsController < ApplicationController

require 'will_paginate'
helper :date

  
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
      format.html # show.html.erb
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
       format.html { redirect_to :controller=>'postings', :action=>'show', :id=>params[:id] }
    end
  end


  # POST /postings/search
  def search
    opt = params[:category][:id].delete "'"
    opt_arr = opt.to_s.split(' ')
    @category = Category.find(opt_arr[1])
    @location = Location.find(params[:location])
    logger.debug("Opt arr [0] = #{opt_arr[0]}")
    if "" == params[:query]
      @query = ""
     if "c" == opt_arr[0]          
       respond_to do |format|
         format.html { redirect_to( cat_postings_index_path(@location,@category)) }
       end
     else
       @subcategory = Subcategory.find(opt_arr[2])
       respond_to do |format|
         format.html { redirect_to( subcat_postings_index_path(@location,@category,@subcategory)) }
       end
     end
      
    else @query = params[:query] 
      if "c" == opt_arr[0]
        respond_to do |format|
        format.html { redirect_to( cat_postings_index_path(@location,@category,:query=>@query)) }
        end
      else
        @subcategory = Subcategory.find(opt_arr[2])
        respond_to do |format|
        format.html { redirect_to( subcat_postings_index_path(@location,@category,@subcategory,:query=>@query)) }
        end
      end
    end
  end
  
  # POST /postings
  # POST /postings.xml
  def preview
    #require 'date'
    #require 'time'
    @posting = Posting.new
    @aposting = Posting.new(params[:posting])
    @subcategory=Subcategory.find(params[:posting][:subcategory_id], :include=>[:category, :location])
    @location = @subcategory.location
    @category = @subcategory.category
    begin
      Posting.transaction do
        if @aposting.valid?
          # throw exception
           raise 'go to preview'  
        else
        @posting = @aposting
	render :action => :new, :layout=>"postings_new_post"      
        end
     end
     rescue 
          @aposting.duration=@aposting.return - @aposting.departure + 1
          flash[:notice] = 'Posting was temporarily created.'
          respond_to do |format|
     	    format.html {render :layout =>"postings_new_post" } # preview.html.erb
            format.xml  { render :xml => @posting, :status => :created }
	  end
       end
  end 
  

  # POST /postings
  # POST /postings.xml
  def submit
    @posting = Posting.new(params[:posting])
    @subcategory=Subcategory.find(params[:posting][:subcategory_id], :include=>[:category, :location])
    @location = @subcategory.location
    @category = @subcategory.category
    if params[:commit] == "edit"
	render :action => :new
     elsif params[:commit] == "post"
     @posting.key = genRandomKey()
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

    respond_to do |format|
      if @posting.update_attributes(params[:posting])
        flash[:notice] = 'Posting was successfully updated.'
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
  def ddelete
    @posting = Posting.find(params[:id])
    flash[:notice] = 'Posting can be deleted.'

    respond_to do |format|
      format.html { redirect_to(cactus_flagged_postings_path) }
      format.xml  { head :ok }
    end
  end

  def genRandomKey
    def String.random_alphanumeric(size=16)
    (1..size).collect { (i=Kernel.rand(62); i+=((i<10)?48:((i<36)?55:61))).chr}.join
    end
    return String.random_alphanumeric()
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


end
