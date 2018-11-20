module LeaverBot
    class Command
      class Leave
        class Dinas < Leave
          COMMAND_REGEX = /^\/dinas/
  
          def self.matches(text)
            text =~ COMMAND_REGEX
          end
  
          def perform
            super('dinas')
          end
        end
      end
    end
  end
  