module LeaverBot
  class Command
    class Leave
      class Sick < Leave
        COMMAND_REGEX = /^\/sakit/

        def self.matches(text)
          text =~ COMMAND_REGEX
        end

        def perform
          super('sakit')
        end
      end
    end
  end
end
