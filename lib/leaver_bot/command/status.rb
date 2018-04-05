module LeaverBot
  class Command
    class Status < Command
      HOLIDAY_KEY = 'holiday'.freeze

      attr_accessor :group

      def perform
        if in_private?
          reply('Perintah ini hanya bisa digunakan di dalam group')
        elsif holiday?
          reply('Liburan gih sana')
        else
          @group = get_group

          reply('Group ini belum didaftarkan') unless @group
        end
      end

      def holiday?
        Date.today.saturday? || Date.today.sunday? || $redis.get(HOLIDAY_KEY) == 'y'
      end

      private

      def get_group
        LeaverBot::Group.find_by(group_id: @message.chat.id)
      end
    end
  end
end
