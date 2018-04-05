module LeaverBot
  class Command
    class Sudo
      class CacheType < Sudo
        COMMAND_REGEX = /^\/type/

        def self.matches(text)
          text =~ COMMAND_REGEX
        end

        def perform
          super

          reply(LeaverBot::Leave.cache_type(args))
        end
      end
    end
  end
end
