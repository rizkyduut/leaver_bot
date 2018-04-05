require 'rspec'
require 'dotenv/load'
require 'sucker_punch'
require 'mongoid'
require 'mongoid-locker'

require 'leaver_bot'

Mongoid.load!(File.join(File.dirname(__FILE__), '..', 'config', 'mongoid.yml'), :test)

#Dir['spec/support/**/*.rb'].each { |f| require File.expand_path(f) }
