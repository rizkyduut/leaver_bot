module LeaverBot
  class Command
    class Status
      class Leave < Status
        COMMAND_REGEX = /^\/status/

        def self.matches(text)
          text =~ COMMAND_REGEX
        end

        def perform
          super
          return unless @group

          if usernames = @group.user_list
            replies = []
            usernames.each do |username|
              replies.push(check_status(username))
            end

            reply_status(replies)
          else
            reply('Belum ada user yang didaftarkan dalam group ini')
          end
        end

        private

        def check_status(username)
          LeaverBot::Leave.check_status(username)
        end

        def reply_status(replies)
          unless replies.all?(&:nil?)
            replies.unshift('Berikut daftar yang tidak hadir hari ini:')
            reply(replies.compact.join("\n"))
          else
            reply('Semua hadir hari ini. Yeay!')
          end
        end
      end
    end
  end
end
