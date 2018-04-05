module LeaverBot
  class Command
    class Sudo
      class Keys < Sudo
        COMMAND_REGEX = /^\/keys/

        def self.matches(text)
          text =~ COMMAND_REGEX
        end

        def perform
          super

          reply(LeaverBot::Leave.key)
        end
      end
    end
  end
end
