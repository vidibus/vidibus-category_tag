require 'active_support'
require 'mongoid'

require 'vidibus/category_tag'

if defined?(Rails)
  module Vidibus::Tags
    class Engine < ::Rails::Engine; end
  end
end
