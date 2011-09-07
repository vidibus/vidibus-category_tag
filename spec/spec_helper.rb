$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "..", "lib"))

require "rubygems"
require "rspec"
require "rr"
require "vidibus-tags_with_context"

RSpec.configure do |config|
  config.mock_with :rr
end
