module LeaverBot
  class Command
    class HelpCommands < Command
      COMMAND_REGEX = /^\/help_commands$/

      def self.matches(text)
        text =~ COMMAND_REGEX
      end

      def perform
        raise LeaverBot::InGroupError unless in_private?

        reply(LeaverBot::Message.help_commands_text)
      end
    end
  end
end
