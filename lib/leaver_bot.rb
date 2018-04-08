require 'leaver_bot/command'
require 'leaver_bot/error'
require 'leaver_bot/message'
require 'leaver_bot/message_sender'
require 'leaver_bot/input'

require 'leaver_bot/model/group'
require 'leaver_bot/model/leave'
require 'leaver_bot/model/snack'
require 'leaver_bot/model/user'
require 'leaver_bot/model/reminder'

module LeaverBot
  REMINDER_LIST_KEY = 'reminder_list'.freeze
  HOLIDAY_KEY = 'holiday'.freeze
  @log = Logger.new(File.dirname(__FILE__) + "/log/#{Date.today.strftime("%Y-%m")}.log")

  def self.perform
    Telegram::Bot::Client.run($telegram_bot_token) do |bot|
      bot.listen do |message|
        LeaverBot::Input.perform_async(bot, message)
      end
    end
  rescue Faraday::TimeoutError, Faraday::ConnectionFailed => e
    puts 'TIMEOUT'
    sleep(2)
    retry
  rescue StandardError => e
    @log.error e.inspect
    retry
  end

  def self.reminder
    return if $redis.get(HOLIDAY_KEY) == 'y'

    Telegram::Bot::Client.run($telegram_bot_token) do |bot|
      options   = LeaverBot::Reminder.options
      usernames = $redis.smembers(REMINDER_LIST_KEY)
      usernames.each do |username|
        user = LeaverBot::User.get(username)
        if user && !LeaverBot::Leave.check_leave(username)
          options[:chat_id] = user.user_id

          @log.info("Send reminder to #{username}")
          LeaverBot::MessageSender.perform_async(bot, options)
        end
      end
    end
  end

  def self.daily_snack
    return if $redis.get(HOLIDAY_KEY) == 'y'

    Telegram::Bot::Client.run($telegram_bot_token) do |bot|
      snack_groups = LeaverBot::Snack.all.to_a
      snack_groups.each do |snack_group|
        options   = LeaverBot::Snack.options
        usernames = snack_group.today
        replies   = []

        usernames.each do |username|
          replies.push("@#{username}") unless LeaverBot::Leave.check_leave(username)
        end

        if replies.present?
          options[:text] += replies.join(', ')
          options[:chat_id] = snack_group.group.group_id

          LeaverBot::MessageSender.perform_async(bot, options)
        end
      end
    end
  end

  def self.logger
    @log
  end
end
