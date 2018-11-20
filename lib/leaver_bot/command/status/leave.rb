module LeaverBot
  class Command
    class Status
      class Leave < Status
        COMMAND_REGEX = /^\/status$/

        def self.matches(text)
          text =~ COMMAND_REGEX
        end

        def perform
          if in_private?
            ask_status
            return
          end

          super

          if usernames = group.user_list
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
            replies.unshift("Daftar absensi <b>#{group.name}</b> hari ini:")
            reply(replies.compact.join("\n"))
          else
            reply('Semua hadir hari ini. Yeay!')
          end
        end

        def ask_status
          kb = [
              Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Status kamu', callback_data: '/my_status'),
              Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Status grup kamu', callback_data: '/monthly_status'),
          ]
          markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)

          send_message('Yang mana?', {reply_markup: markup})
        end
      end
    end
  end
end
