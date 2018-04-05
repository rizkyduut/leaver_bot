require 'rake'
require 'redis'
require 'redis-namespace'
require 'sucker_punch'
require 'mongoid'
require 'mongoid-locker'
require 'telegram/bot'
require 'dotenv/load'

$LOAD_PATH << File.join(File.dirname(__FILE__), 'lib')
require 'leaver_bot'


Dir[File.dirname(__FILE__) + '/lib/tasks/*.rake'].each{ |file| import file }

def reload!
  Dir[File.dirname(__FILE__) + '/config/init.rb'].each{ |file| require file }
end

env = ENV['ENV'] ? ENV['ENV'] : 'development'
Mongoid.load!(File.dirname(__FILE__) + '/config/mongoid.yml', env)

namespace :leaver_bot do
  desc 'Load all code file'
  task :reload do
    reload!
  end

  desc 'Start bot'
  task start: :reload do
    LeaverBot.perform
  end

  desc 'Send daily reminder to subscriber'
  task remind: :reload do
    LeaverBot::reminder
  end

  desc 'Send snack daily reminder to group'
  task daily_snack: :reload do
    LeaverBot::daily_snack
  end
end

task default: 'leaver_bot:start'
