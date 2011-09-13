$:.push File.expand_path('../../app', __FILE__)

require 'rspec'
require 'factory_girl'
require 'vidibus-uuid'

require 'vidibus-category_tag'

require File.dirname(__FILE__) + '/../spec/factories.rb'

Mongoid.configure do |config|
  name = 'vidibus-category_tag_test'
  host = 'localhost'
  config.master = Mongo::Connection.new.db(name)
end

RSpec.configure do |config|
  config.before :each do
    Mongoid.master.collections.select {|c| c.name !~ /system/ }.each(&:drop)
  end
end
