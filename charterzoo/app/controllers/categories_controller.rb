class CategoriesController < ApplicationController
  

  # GET /postings
  # GET /postings.xml
  def index   
    @category = Category.find(params[:category_id], :include => 'subcategories')
    if 1 == @category.id
      @field_sort = (nil == params[:field_sort] )? 'departure' : params[:field_sort]
    elsif 5 == @category.id
      @field_sort = (nil == params[:field_sort] )? 'departure' : params[:field_sort]
    else 
      @field_sort = (nil == params[:field_sort] )? 'organizer_sort' : params[:field_sort]
    end 
    @list_mode = (nil == params[:list_mode] )? 'descending' : params[:list_mode]
    @month = (nil== params[:month] )? -99: params[:month] 
    @year = (nil==params[:year] )? Date.today.year: params[:year]
 

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
            if 0 ==y
              @chunks[y] = chunk
            else
	      @chunks[y] = ' ' + chunk
            end
            y = y+1              
         end
         @query_string = process_chunk(@chunks)
      end 
      filters = {} 
      filters['subcategory_id'] = a.flatten
      if @category.id.to_i == 1
        filters['departure_year'] = @year.to_i
        if -99 != @month.to_i
          filters['departure_month'] = @month.to_i
        end
      end
      @search=Ultrasphinx::Search.new(:query => @query_string, :filters => filters, :sort_by => @field_sort, :sort_mode=>@list_mode)
      @search.run
      @results = @search.results
      @postings = @results.paginate :page => params[:page],:per_page =>PER_PAGE, :month=>params[:month], :year=>params[:year] , :query=>params[:query]
    if @chunks != nil and @postings.size <1   
      flash[:notice] = "No search results found for this query. All words must match when searching by keyword."
    end

    respond_to do |format|
      if @category.id.to_i == 1
	format.html # index.html.erb
      else
        format.html {render :layout =>"categories_directory" } # index.html.erb
      end
      format.xml  { render :xml => @postings }
    end
  end


  # GET /categories/new
  # GET /categories/new.xml
  def post
    @posting = Posting.new
    @location = Location.find(params[:location_id], :include => [:categories], :order => "categories.name")
    @categories = @location.categories
    @category = Category.find(params[:category_id], {:include => [:subcategories=> :subname], :conditions => ['subcategories.status=? AND subcategories.location_id = ?',true,  @location]})
    @subcategories = @category.subcategories.sort{|a,b| a.subname.name <=> b.subname.name} 

    respond_to do |format|
      format.html {render :layout =>"categories_new_post" } # post.html.erb
      format.xml  { render :xml => @location, :layout => false }
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



 
end
