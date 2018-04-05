ENV['ENV'] = 'test'

load 'Rakefile'
Rake::Task['leaver_bot:reload'].execute

require 'rspec'

Dir['spec/support/**/*.rb'].each { |f| require File.expand_path(f) }
