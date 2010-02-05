## vendor/plugins/ultrasphinx_customizations/lib/eager_loading.rb
 
# Allows specifying eager loading options as e.g.
# Ultrasphinx::Search.client_options[:include]['MyKlass'] => [:user]
# or directly in is_indexed like
# is_indexed ..., :eagerly_load => [:user]
 
Ultrasphinx::Search.client_options.merge!(HashWithIndifferentAccess.new({
  :finder_methods => ['find_all_by_id_with_eager_loading'],
  :include => {}
}))
 
 
class ActiveRecord::Base
 
  def self.find_all_by_id_with_eager_loading(*ids)
    includes = Ultrasphinx::Search.client_options['include'][self.name]
    args = ids + [:include => includes]
    find_all_by_id(*args)
  end
 
  def self.is_indexed_with_include_option(options)
    Ultrasphinx::Search.client_options['include'][self.name] = options.delete(:eagerly_load)
    is_indexed_without_include_option(options)
  end
  class << self; alias_method_chain :is_indexed, :include_option; end
 
end
