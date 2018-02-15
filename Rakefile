require 'rake'
require 'redis'
require 'redis-namespace'
require 'sucker_punch'
require 'mongoid'
require 'mongoid-locker'
require 'telegram/bot'

def reload!
  Dir[File.dirname(__FILE__) + '/config/init.rb'].each{ |file| load file }
  Dir[File.dirname(__FILE__) + '/lib/leaver_bot.rb'].each{ |file| load file }
  Dir[File.dirname(__FILE__) + '/lib/leaver_bot/**/*.rb'].each{ |file| load file }
end

Mongoid.load!(File.dirname(__FILE__) + '/config/mongoid.yml', :production)

namespace :leaver_bot do
  task :reload do
    reload!
  end

  task start: :reload do
    LeaverBot.start
  end

  task remind: :reload do
    LeaverBot::Reminder.start
  end

  task daily_snack: :reload do
    LeaverBot::Snack.daily_snack
  end
end

task default: 'leaver_bot:start'
