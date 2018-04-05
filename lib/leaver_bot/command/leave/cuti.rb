module LeaverBot
  class Command
    class Leave
      class Cuti < Leave
        COMMAND_REGEX = /^\/cuti/

        def self.matches(text)
          text =~ COMMAND_REGEX
        end

        def perform
          super('Cuti')
        end
      end
    end
  end
end
