module LeaverBot
  class Command
    class Sudo
      class Holiday < Sudo
        COMMAND_REGEX = /^\/holiday/
        HOLIDAY_KEY   = 'holiday'.freeze

        def self.matches(text)
          text =~ COMMAND_REGEX
        end

        def perform
          super

          $redis.set(HOLIDAY_KEY, args)
          reply(state == 'y' ? 'Libur' : 'Masuk')
        end
      end
    end
  end
end
