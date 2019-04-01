# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

# update crontab use whenever -w
# clear crontab use whenever -c

every :weekday, at: '6am' do
  rake 'leaver_bot:remind'
end

every :weekday, at: ['8:00 am', '11:00 am'] do
  rake 'leaver_bot:daily_snack'
end

every '00,15,30,45 7-20 * * 1-5' do
# every '* * * * 1-5' do
  rake 'leaver_bot:standup'
end
