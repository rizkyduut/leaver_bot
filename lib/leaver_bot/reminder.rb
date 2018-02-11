class LeaverBot::Reminder
  REMINDER_LIST_KEY = 'reminder_list'.freeze
  DEFAULT_MESSAGE_OPTIONS = {
    parse_mode: 'HTML'
  }.freeze

  def self.start
    options = {
      text: 'Hai, hari ini masuk gak? kalo nggak kabarin ya~',
      parse_mode: 'HTML'
    }

    Telegram::Bot::Client.run($telegram_bot_token) do |bot|

      usernames = $redis.smembers(REMINDER_LIST_KEY)
      usernames.each do |username|
        if user = LeaverBot::User.get(username)
          options[:chat_id] = user.user_id

          LeaverBot::MessageSender.perform_async(bot, options)
        end
      end
    end
  end

  def self.add(username)
    $redis.sadd(REMINDER_LIST_KEY, username)
  end

  def self.check(username)
    $redis.sismember(REMINDER_LIST_KEY, username)
  end

  def self.remove(username)
    $redis.srem(REMINDER_LIST_KEY, username)
  end
end
