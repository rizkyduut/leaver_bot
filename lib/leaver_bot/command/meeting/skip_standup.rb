module LeaverBot
  class Command
    class Meeting
      class SkipStandup < Meeting
        COMMAND_REGEX = /^\/skip_standup/

        def self.matches(text)
          text =~ COMMAND_REGEX
        end

        def perform
          send_message("", {reply_markup: force_reply_markup})
        end
      end
    end
  end
end
