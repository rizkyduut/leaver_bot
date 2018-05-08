module LeaverBot
  class Command
    class CheckStatus < Command
      COMMAND_REGEX = /^\/check_status/

      def self.matches(text)
        text =~ COMMAND_REGEX
      end

      def perform
        if in_private?
          if registered_user?
            username = stripped_text.strip.gsub("@","")
            status = LeaverBot::Leave.check_status(username) || "@#{username} masuk kantor hari ini"

            reply(status)
          else
            raise LeaverBot::UserNotRegisteredError
          end
        else
          raise LeaverBot::InGroupError
        end
      end
    end
  end
end

