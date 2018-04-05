module LeaverBot
  class Command
    class Leave
      class Reset < Leave
        COMMAND_REGEX = /^\/reset/

        def self.matches(text)
          text =~ COMMAND_REGEX
        end

        def perform
          super('Reset')
        end
      end
    end
  end
end
