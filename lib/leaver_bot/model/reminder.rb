module LeaverBot
  class Reminder
    REMINDER_LIST_KEY = 'reminder_list'.freeze
    HOLIDAY_KEY = 'holiday'.freeze

    def self.add(username)
      $redis.sadd(REMINDER_LIST_KEY, username)
    end

    def self.check(username)
      $redis.sismember(REMINDER_LIST_KEY, username)
    end

    def self.remove(username)
      $redis.srem(REMINDER_LIST_KEY, username)
    end

    def self.options
      {
        text: 'Hai, hari ini masuk gak? kalo nggak kabarin ya~',
        parse_mode: 'HTML'
      }
    end
  end
end
