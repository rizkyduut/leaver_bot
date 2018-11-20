module LeaverBot
  class Command
    class Meeting
      class Standup < Meeting
        COMMAND_REGEX = /^\/standup/

        def self.matches(text)
          text =~ COMMAND_REGEX
        end

        def perform
          raise LeaverBot::InPrivateError if in_private?
          super
          ask_standup
        end

        private

        def ask_standup
          kb = [
              Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Waktu stand-up', callback_data: '/set_standup'),
              #Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Skip hari', callback_data: '/skip_standup'),
          ]
          markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)

          send_message('Atur yang mana?', {reply_markup: markup})
        end
      end
    end
  end
end
