class LeaverBot

  ADMIN_REDIS_KEY = 'admins'.freeze
  ADMINS = -> { $redis.lrange(ADMIN_REDIS_KEY, 0, -1) }

  def self.start
    Telegram::Bot::Client.run($telegram_bot_token) do |bot|
      bot.listen do |message|
        LeaverBot::InputProcessor.perform_async(message, bot)
      end
    end
  rescue StandardError => e
    puts e.message
    retry
  end
end
