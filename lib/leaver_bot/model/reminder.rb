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
      commands = %w(cuti remote sakit dinas reset)
      {
        text: "Hai, hari ini masuk gak? kalo nggak kabarin ya~\n\n#{commands.map { |command| "/#{command}" }.join("\n")}",
        parse_mode: 'HTML'
      }
    end
  end
end
