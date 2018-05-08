module LeaverBot
  class Command
    class Leave < Command
      attr_accessor :days, :date

      def process_input
        unless stripped_text.empty?
          days, @date = /(\d{1,2})(?: (.+))?/.match(stripped_text).captures
        end

        @days = days.to_i
      end

      def perform(type)
        if in_private?
          if registered_user?
            process_input
            return unless valid_days?(type)

            if @date.to_s.empty?
              type == 'reset' ? remove_leave : add_leave(type)
            else
              selected_date = Date.parse(@date) if valid_date?
              type == 'reset' ? remove_future_leave(selected_date) : add_future_leave(selected_date, type)
            end
          else
            raise LeaverBot::UserNotRegisteredError
          end
        else
          raise LeaverBot::InGroupError
        end
      end

      def add_leave(type)
        LeaverBot::Leave.add(@message.from.username, @days, type.downcase)

        if @days == 1
          reply("Data #{type} untuk hari ini berhasil didaftarkan")
        else
          reply("Data #{type} sampai tanggal #{display_date(Date.today.next_day(@days-1))} berhasil didaftarkan")
        end
      end

      def add_future_leave(date, type)
        if type == 'sakit'
          reply("Kamu tidak bisa menginput data sakit untuk waktu yang akan datang")
        elsif days == 1
          LeaverBot::Leave.add(@message.from.username, @days, type.downcase, date)

          reply("Data #{type} untuk tanggal #{display_date(date)} berhasil didaftarkan")
        else
          LeaverBot::Leave.add(@message.from.username, @days, type.downcase, date)

          reply("Data #{type} untuk tanggal #{display_date(date)} sampai #{display_date(next_date(date))} berhasil didaftarkan")
        end
      end

      def remove_leave
        LeaverBot::Leave.remove(@message.from.username, @days)

        if @days == 1
          reply("Data cuti/remote/sakit untuk hari ini berhasil dihapus")
        else
          reply("Data cuti/remote/sakit sampai tanggal #{display_date(Date.today.next_day(@days-1))} berhasil dihapus")
        end
      end

      def remove_future_leave(date)
        LeaverBot::Leave.remove(@message.from.username, @days, date)

        if @days == 1
          reply("Data cuti/remote untuk tanggal #{display_date(date)} berhasil dihapus")
        else
          reply("Data cuti/remote untuk tanggal #{display_date(date)} sampai #{display_date(next_date(date))} berhasil dihapus")
        end
      end

      private

      def valid_days?(type)
        if @days <= 0
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

      def valid_date?
        !!(@date.match(/\d{1,2}-\d{1,2}-\d{4}/) && Date.strptime(@date, "%d-%m-%Y"))
      rescue ArgumentError
        false
      end

      def next_date(current_date)
        current_date.next_day(@days-1)
      end
    end
  end
end
