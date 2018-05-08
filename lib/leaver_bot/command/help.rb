module LeaverBot
  class Command
    class Help < Command
      COMMAND_REGEX = /^\/help$|\/start$/

      def self.matches(text)
        text =~ COMMAND_REGEX
      end

      def perform
        raise LeaverBot::InGroupError unless in_private?

        reply(LeaverBot::Message.help_text)
      end
    end
  end
end
