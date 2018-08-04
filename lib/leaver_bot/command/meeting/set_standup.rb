module LeaverBot
  class Command
    class Meeting
      class SetStandup < Meeting
        COMMAND_REGEX = /^(\/set_standup|Jam berapa)/
        REGEX_TIME = /(2[0-3]|1[0-9]|0[0-9]):([0-5][0-9])$/

        def self.matches(text)
          text =~ COMMAND_REGEX
        end

        def time
          @time ||= stripped_text.strip
        end

        def perform
          if raw_text == 'Atur yang mana?'
            options = {
              chat_id: @message.chat.id,
              message_id: @message.message_id,
              text: 'Atur waktu stand-up'
            }
            bot.api.edit_message_text(options)
            reply("Jam berapa? Isi dengan format HH:MM (format 24 jam, kelipatan 15 menit) ya!", {reply_markup: force_reply_markup})
          else
            validate_time!
            group.update(:standup => time)

            reply("Waktu stand-up <b>#{group.name}</b> telah di-set menjadi #{time}")
          end
        end

        private

        def validate_time!
          validated_time ||= time.match(REGEX_TIME)
          raise LeaverBot::TimeNotValidError if validated_time.nil?
          raise LeaverBot::TimeNotAllowedError if validated_time[2].to_i % 15 != 0
        end
      end
    end
  end
end
