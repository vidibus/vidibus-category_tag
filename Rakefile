require 'bundler'
require 'rdoc/task'
require 'rspec'
require 'rspec/core/rake_task'

Bundler::GemHelper.install_tasks

$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'vidibus/category_tag/version'

Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "vidibus-category_tag #{Vidibus::CategoryTag::VERSION}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
  rdoc.options << '--charset=utf-8'
end
