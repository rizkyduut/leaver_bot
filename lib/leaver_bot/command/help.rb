module LeaverBot
  class Command
    class Help < Command
      COMMAND_REGEX = /^\/help/

      def self.matches(text)
        text =~ COMMAND_REGEX
      end

      def perform
        if in_private?
          reply(LeaverBot::Message.help_text)
        else
          reply('Japri aja ya')
        end
      end
    end
  end
end
