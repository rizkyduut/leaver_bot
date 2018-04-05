module LeaverBot
  class Command
    class Reminder < Command
      attr_accessor :state

      COMMAND_REGEX = /^\/reminder/

      def self.matches(text)
        text =~ COMMAND_REGEX
      end

      def state
        @state ||= stripped_text.strip
      end

      def perform
        if in_private?
          if registered_user?
            if state == 'y'
              LeaverBot::Reminder.add(@message.from.username)
              reply('Reminder berhasil diaktifkan')
            elsif state == 'n'
              LeaverBot::Reminder.remove(@message.from.username)
              reply('Reminder berhasil dinonaktifkan')
            else
              reply(LeaverBot::Message.reminder_text)
            end
          else
            reply('Kamu belum terdaftar')
          end
        else
          reply('Japri aja ya')
        end
      end
    end
  end
end
