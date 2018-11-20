module LeaverBot
  class Command
    class MyStatus < Command
      COMMAND_REGEX = /^\/my_status/

      def self.matches(text)
        text =~ COMMAND_REGEX
      end

      def perform
        if in_private?
          if registered_user?
            status = LeaverBot::Leave.my_status(sender)

            status = status.map do |stat|
              date = I18n.l(Date.parse(stat[0]), format: :long)
              s = stat[1].titlecase

              "#{date} - #{s}"
            end

            if status.empty?
              status = ["Belum ada absen yang kamu ajukan di bulan ini"]
            end

            month_year = I18n.l(Date.today, format: :month_year)
            status = status.unshift("Absensi kamu sampai akhir bulan #{month_year}:")
            status = status.join("\n")

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
