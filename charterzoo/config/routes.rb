ActionController::Routing::Routes.draw do |map|


#This is a mandatory route used for rendering the simple_captcha image on the fly without storing on the filesystem.


  map.simple_captcha '/simple_captcha/:action', :controller => 'simple_captcha'
  map.ipn '/ipns/:action', :controller =>'ipns'

  # admin
  map.cactus_subcat_add '/cactus/subcategories/add', :controller => 'cactus/subcategories', :action => 'add'
  map.cactus_subcat_remove '/cactus/subcategories/:id/remove', :controller => 'cactus/subcategories', :action => 'remove'
  map.cactus_subcat_restore '/cactus/subcategories/:id/restore', :controller => 'cactus/subcategories', :action => 'restore'
  map.cactus_register '/cactus/admin/register', :controller => 'cactus/admin', :action => 'register'
  map.cactus_admin '/cactus/admin', :controller => 'cactus/admin', :action => 'index'
  map.cactus_rollcall '/cactus/admin/rollcall', :controller => 'cactus/admin', :action => 'rollcall'

 # map.cactus_subcat_index '/cactus/subcategories/index', :controller => 'cactus/subcategories', :action => 'index'


  map.cactus_subcat_edit '/cactus/subcategories/:id/edit', :controller => 'cactus/subcategories', :action => 'edit'
  map.cactus_posting_ddelete '/cactus/postings/:id/ddelete', :controller => 'cactus/postings', :action => 'ddelete'

 # map to admin namespace
     map.namespace :cactus do |cactus|
  	cactus.resources :locations, :has_many=>[:categories], :through=>:subcategories
  	cactus.resources :categories, :has_many=>[:locations], :through=>:subcategories
  	cactus.resources :subnames, :has_many=>[:subcategories]
  	cactus.resources :subcategories, :belongs_to=>[:locations, :categories, :subnames] 
        cactus.resources :butterwords
        cactus.resources :flags
        cactus.resources :flagnames
        cactus.resources :flagged_postings
	cactus.resources :postings
        cactus.resource  :session

     end

 

  map.resources :postings


  map.postings_search 'postings/search', :controller => 'postings', :action => 'search' 
  map.postings_flag 'postings/flag/:id/:flagname_id', :controller => 'postings', :action => 'flag'
  map.postings_manage 'postings/:id/manage', :controller => 'postings', :action => 'manage'

 # map.postings_search 'posts/search', :controller => 'postings', :action => 'search' 

  map.postings_submit 'postings/submit', :controller => 'postings', :action => 'submit' 
  map.posting_edit 'postings/:id/edit/:key', :controller => 'postings', :action => 'edit'
  map.posting_update 'postings/:id/update/:key', :controller => 'postings', :action => 'update'
  map.posting_change_status 'postings/:id/change_status/:key', :controller => 'postings', :action => 'change_status'
  map.user_delete 'postings/delete/:location_id/:id/', :controller => 'postings', :action => 'delete' 

 # New posts

  map.new_location_post ':location_id/post', :controller => 'locations', :action => 'post'

  map.new_location_category_post ':location_id/:category_id/post', :controller => 'categories', :action => 'post'

  map.new_location_category_subcategory_post ':location_id/:category_id/:subcategory_id/new', :controller => 'postings', :action => 'new'

  map.edit_location_category_subcategory_post ':location_id/:category_id/:subcategory_id/post/:id/edit', :controller => 'postings', :action => 'edit'

  map.preview_posting ':location_id/:category_id/:subcategory_id/preview', :controller => 'postings', :action => 'preview'

  map.submit_posting ':location_id/:category_id/:subcategory_id/submit', :controller => 'postings', :action => 'submit'

  map.confirm_posting 'post/confirm', :controller => 'postings', :action => 'confirm'

  map.thankyou_posting 'post/:id/thankyou/:key', :controller => 'postings', :action => 'thankyou'


 # Linkcodes
  map.linkcodes ':location_id/linkcodes', :controller => 'linkcodes', :action => 'index'
  map.check_linkcodes ':location_id/linkcodes/check', :controller => 'linkcodes', :action => 'check'


# List posts

  map.cat_postings_index ':location_id/:category_id', :controller => 'categories', :action => 'index'
  map.cat_postings_index_by_month ':location_id/:category_id/list/:year/:month', :controller => 'categories', :action => 'index'
  map.cat_postings_index_by_year ':location_id/:category_id/list/:year', :controller => 'categories', :action => 'index'
  #map.cat_postings ':location_id/:category_id/:query/query', :controller => 'categories', :action => 'index'

  map.subcat_postings_index ':location_id/:category_id/:subcategory_id', :controller => 'subcategories', :action => 'index'
  map.subcat_postings_index_by_month ':location_id/:category_id/:subcategory_id/list/:year/:month', :controller => 'subcategories', :action => 'index'
  map.subcat_postings_index_by_year ':location_id/:category_id/:subcategory_id/list/:year', :controller => 'subcategories', :action => 'index'

  #map.subcat_postings_Qindex ':location_id/:category_id/:subcategory_id/:query', :controller => 'subcategories', :action => 'index'

  map.subcat_postings ':location_id/:category_id/:subcategory_id', :controller => 'subcategories', :action => 'index'



 # Home

  map.home_location '/:id', :controller => 'locations', :action => 'index'

  map.resources :subnames

  map.resources :locations

  map.resources :subcategories

  map.resources :categories

  map.resources :locations do |locations|
        locations.resources :categories do |categories|
		categories.resources :subcategories
         end
  end


  map.resources :locations, :has_many=>[:categories], :through=>:subcategories
  map.resources :categories, :has_many=>[:locations], :through=>:subcategories
  map.resources :subnames, :has_many=>[:subcategories]
  map.resources :subcategories, :belongs_to=>[:locations, :categories, :subnames], :has_many=>[:postings]
  map.resources :postings, :belongs_to=>[:subcategories], :has_many=>[:flags]
  map.resources :flags, :has_many=>[:postings]


  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

 # map.root :controller => "locations", :id => "2", :action => "index"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
