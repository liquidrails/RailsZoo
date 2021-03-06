# Be sure to restart your server when you modify this file

# Uncomment below to force Rails into production mode when
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'
 ENV['RAILS_ENV'] ||= 'development'

# Specifies gem version of Rails to use when vendor/rails is not present
#RAILS_GEM_VERSION = '2.0.2' unless defined? RAILS_GEM_VERSION
RAILS_GEM_VERSION = '2.3.5' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')



Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.
  # See Rails::Configuration for more options.

  # Skip frameworks you're not going to use (only works if using vendor/rails).
  # To use Rails without a database, you must remove the Active Record framework
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Only load the plugins named here, in the order given. By default, all plugins 
  # in vendor/plugins are loaded in alphabetical order.
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Force all environments to use the same logger level
  # (by default production uses :info, the others :debug)
  # config.log_level = :debug

  # Your secret key for verifying cookie session data integrity.
  # If you change this key, all old sessions will become invalid!
  # Make sure the secret is at least 30 characters and all random, 
  # no regular words or you'll be exposed to dictionary attacks.
  config.action_controller.session = {
    :session_key => '_charterzoo_session',
    :secret      => '520afcde094212221e3b436040293d5fd99f91cacc9bfecf1badd29d63f57c120964eeb6cc393cdf56efe67dbeb0bc7aaa72d4abb3f62f147637db258b92c125'
  }

  # Use the database for sessions instead of the cookie-based default,
  # which shouldn't be used to store highly confidential information
  # (create the session table with 'rake db:sessions:create')
  # config.action_controller.session_store = :active_record_store

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper,
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector

  # Make Active Record use UTC-base instead of local time
  # config.active_record.default_timezone = :utc

  config.gem 'will_paginate'

end


  #gem 'mislav-will_paginate', '~> 2.2'
  #require 'will_paginate'


  #Global constant for this application
  TABLE_WIDTH = 910 
  TD_LEFT = 360 
  TD_RIGHT = TABLE_WIDTH - TD_LEFT 
  SIDEBAR_WIDTH = 137 
  PER_PAGE = 10
  LIST_COLOR1 = "ddffde"
  LIST_COLOR2 = "ffb"
  CHARTER_COLOR = "ff9"
  SHUTTLE_COLOR = "ff9"
  TRIP_COLOR = "df9"
  TTRIP_COLOR = "dfc"
  SPORT_COLOR = "ff9"
  SPECIAL_COLOR = "dcf"

#ActionMailer
ActionMailer::Base.default_charset = "utf-8"
ActionMailer::Base.raise_delivery_errors = false  #true -> mail will be delivered normally
