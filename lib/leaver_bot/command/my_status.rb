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
            status = LeaverBot::Leave.my_status(@message.from.username)

            status = status.map do |stat|
              date = Date.parse(stat[0]).strftime("%d %B %Y")
              s = stat[1].titlecase

              "#{date} - #{s}"
            end

            if status.empty?
              status = ["Belum ada cuti yang kamu ajukan di bulan ini"]
            end

            month_year = Date.today.strftime("%B %Y")
            status = status.unshift("Absensi kamu sampai akhir bulan #{month_year}")
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
