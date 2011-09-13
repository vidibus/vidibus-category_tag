require 'active_support'
require 'mongoid'

require 'vidibus/category_tag'

if defined?(Rails)
  module Vidibus::CategoryTag
    class Engine < ::Rails::Engine; end
  end
end
