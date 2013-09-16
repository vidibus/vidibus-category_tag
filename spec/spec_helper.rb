$:.unshift File.expand_path('../../app', __FILE__)

require 'rspec'
require 'factory_girl'
require 'vidibus-uuid'

require 'vidibus-category_tag'
require 'models/tag_category'
require 'factories'

Mongoid.configure do |config|
  config.connect_to('vidibus-category_tag_test')
end

RSpec.configure do |config|
  config.mock_with :rr
  config.before(:each) do
    Mongoid::Sessions.default.collections.
      select {|c| c.name !~ /system/}.each(&:drop)
  end
end