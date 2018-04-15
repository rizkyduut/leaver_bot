module LeaverBot
  class Command
    class Status
      class Snack < Status
        COMMAND_REGEX = /^\/snack/

        def self.matches(text)
          text =~ COMMAND_REGEX
        end

        def perform
          super

          usernames = group.snack.today
          replies = []

          usernames.each do |username|
            replies.push("@#{username}") unless check_leave(username)
          end

          reply("Jangan lupa jajan ya hari ini #{replies.join(', ')}") if replies.present?
        end

        private

        def check_leave(username)
          LeaverBot::Leave.check_leave(username)
        end
      end
    end
  end
end
