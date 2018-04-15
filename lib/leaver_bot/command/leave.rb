module LeaverBot
  class Command
    class Leave < Command
      attr_accessor :days

      def days
        @days ||= stripped_text.strip.to_i
      end

      def perform(type)
        if in_private?
          if registered_user?
            return unless days_valid?(type)

            type == 'reset' ? remove_leave : add_leave(type)
          else
            raise LeaverBot::UserNotRegisteredError
          end
        else
          raise LeaverBot::InGroupError
        end
      end

      def add_leave(type)
        LeaverBot::Leave.add(@message.from.username, days, type.downcase)

        if days == 1
          reply("Data #{type} untuk hari ini berhasil didaftarkan")
        else
          reply("Data #{type} sampai tanggal #{Date.today.next_day(days-1).strftime("%d-%m-%Y")} berhasil didaftarkan")
        end
      end

      def remove_leave
        LeaverBot::Leave.remove(@message.from.username, days)

        if days == 1
          reply("Data cuti/remote untuk hari ini berhasil dihapus")
        else
          reply("Data cuti/remote sampai tanggal #{Date.today.next_day(days-1).strftime("%d-%m-%Y")} berhasil dihapus")
        end
      end

      private

      def days_valid?(type)
        if days <= 0
          if type == 'reset'
            reply(LeaverBot::Message.reset_text)
          else
            reply(LeaverBot::Message.leave_text(type))
          end
          false
        else
          true
        end
      end
    end
  end
end
