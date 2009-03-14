
ENV['RAILS_ENV'] = 'test'
require File.expand_path(File.dirname(__FILE__) + "/../../../../config/environment")
require 'test_help'
require 'mocha'
require 'redgreen'

##
# Test with different DB settings
#
connection = case ENV['DB']
             when /mysql/
               { :adapter => 'mysql', 
                 :username => 'root', 
                 :database => 'typus_test' }
             when /postgresql/
               { :adapter => 'postgresql', 
                 :encoding => 'unicode', 
                 :database => 'typus_test' }
             else
               { :adapter => 'sqlite3', 
                 :dbfile => ':memory:' }
             end

ActiveRecord::Base.establish_connection(connection)
ActiveRecord::Base.logger = Logger.new(File.dirname(__FILE__) + '/debug.log')

##
# Remove the application load_paths for app/models to avoid conflicts.
#
ActiveSupport::Dependencies.load_paths = []

##
# We want to have our own controllers, helpers and models to be able 
# to test the plugin without touching the application.
#
%w( models controllers helpers ).each do |folder|
  ActiveSupport::Dependencies.load_paths << File.join(Rails.root, 'vendor/plugins/typus/app', folder)
  ActiveSupport::Dependencies.load_paths << File.join(Rails.root, 'vendor/plugins/typus/test/fixtures/app', folder)
end

##
# Load only the plugin view_paths to be able to test extensions.
#
ActionController::Base.view_paths = []
%w( app/views test/fixtures/app/views ).each do |folder|
  ActionController::Base.append_view_path(File.join(Rails.root, 'vendor/plugins/typus', folder))
end

require File.dirname(__FILE__) + '/schema'

class ActiveSupport::TestCase
  self.fixture_path = File.dirname(__FILE__) + '/fixtures'
  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = false
  fixtures :all
end

class ApplicationController < ActionController::Base
  helper :all
end