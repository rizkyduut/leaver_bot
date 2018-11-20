module LeaverBot
  class Command
    class Meeting
      class SkipStandup < Meeting
        COMMAND_REGEX = /^\/skip_standup/

        def self.matches(text)
          text =~ COMMAND_REGEX
        end

        def perform
          options = {
              chat_id: @message.chat.id,
              message_id: @message.message_id,
              text: 'Hari apa yang mau di-skip?'
            }
          bot.api.edit_message_text(options.merge({reply_markup: markup}))
        end

        private

        def markup
          kb = [
              Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Senin', callback_data: '/skip_standup 1'),
              Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Selasa', callback_data: '/skip_standup 2'),
              Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Rabu', callback_data: '/skip_standup 3'),
              Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Kamis', callback_data: '/skip_standup 4'),
              Telegram::Bot::Types::InlineKeyboardButton.new(text: "Jum'at", callback_data: '/skip_standup 5'),

          ]
          Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
        end
      end
    end
  end
end
