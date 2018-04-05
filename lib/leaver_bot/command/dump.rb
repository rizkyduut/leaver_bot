module LeaverBot
  class Command
    class Dump < Command
      COMMAND_REGEX = /.*/

      def self.matches(text)
        text =~ COMMAND_REGEX
      end

      def perform
        puts raw_text
      end
    end
  end
end


