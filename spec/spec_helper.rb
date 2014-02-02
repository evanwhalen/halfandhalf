require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

ENV['RACK_ENV'] ||= 'test'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'halfandhalf'

RSpec.configure do |config|
  
  config.before(:all) do
    Redis.current.select(1)
  end
  
  config.before(:each) do
    Redis.current.flushdb
  end
  
  config.after(:each) do
    Redis.current.flushdb
  end
end