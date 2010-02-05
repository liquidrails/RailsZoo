ActionController::Routing::Routes.draw do |map|

  # map to admin namespace
     map.namespace :cactus do |cactus|
  	cactus.resources :locations, :has_many=>[:categories], :through=>:subcategories
  	cactus.resources :categories, :has_many=>[:locations], :through=>:subcategories
  	cactus.resources :subnames, :has_many=>[:subcategories]
  	cactus.resources :subcategories, :belongs_to=>[:locations, :categories, :subnames] 
     end

  #map.resources :postings

  map.postings_search 'postings/search', :controller => 'postings', :action => 'search'    

  map.resources :subnames

  map.home_location '/:id', :controller => 'locations', :action => 'show'

  map.new_location_post ':location_id/new', :controller => 'locations', :action => 'new'

  map.new_location_category_post ':location_id/:category_id/new', :controller => 'categories', :action => 'new'

  map.new_location_category_subcategory_post ':location_id/:category_id/:subcategory_id/new', :controller => 'postings', :action => 'new'

  map.edit_location_category_subcategory_post ':location_id/:category_id/:subcategory_id/:id/edit', :controller => 'postings', :action => 'edit'

  map.subcat_postings ':location_id/:category_id/:subcategory_id', :controller => 'postings', :action => 'index'

  map.cat_postings ':location_id/:category_id/:query', :controller => 'categories', :action => 'show'

  map.cat_postings_index ':location_id/:category_id/', :controller => 'categories', :action => 'show'

  map.confirm_posting 'postings/confirm', :controller => 'postings', :action => 'confirm'

  map.preview_posting ':location_id/:category_id/:subcategory_id/postings/preview', :controller => 'postings', :action => 'preview'

  map.submit_posting ':location_id/:category_id/:subcategory_id/postings/submit', :controller => 'postings', :action => 'submit'

  map.thankyou_posting 'postings/:id/thankyou/:key', :controller => 'postings', :action => 'thankyou'

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
  map.resources :postings, :belongs_to=>[:subcategories]


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

  map.root :controller => "locations", :id => "2", :action => "show"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
