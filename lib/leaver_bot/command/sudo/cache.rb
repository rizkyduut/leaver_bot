module LeaverBot
  class Command
    class Sudo
      class Cache < Sudo
        COMMAND_REGEX = /^\/cache/

        def self.matches(text)
          text =~ COMMAND_REGEX
        end

        def perform
          super

          reply(LeaverBot::Leave.cache(args))
        end
      end
    end
  end
end
