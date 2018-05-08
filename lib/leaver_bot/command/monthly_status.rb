module LeaverBot
  class Command
    class MonthlyStatus < Status
      COMMAND_REGEX = /^\/monthly_status/

      def self.matches(text)
        text =~ COMMAND_REGEX
      end

      def perform
        raise LeaverBot::InGroupError unless in_private?
        username = @message.from.username
        groups = get_group_by_username(username)

        raise LeaverBot::UserNotRegisteredInGroupError unless groups

        groups.each do |group|
          results = check_status_by_month(group)
          reply_status(results, group)
        end
      end

      private

      def get_group_by_username(username)
        LeaverBot::Group.where(user_list: username)
      end

      def check_status_by_month(group)
        LeaverBot::Leave.check_status_by_month(group)
      end

      def reply_status(results, group)
        header = "Absensi grup <b>#{group.name}</b> sampai akhir bulan #{Date.today.strftime("%B %Y")}"
        unless results.all?(&:nil?)
          results.unshift(header)
          reply(results.compact.join("\n"))
        else
          reply("#{header}\nTidak ada yang absen bulan ini. Yeay!")
        end
      end
    end
  end
end
