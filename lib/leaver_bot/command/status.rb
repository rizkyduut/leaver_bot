module LeaverBot
  class Command
    class Status < Command
      HOLIDAY_KEY = 'holiday'.freeze

      attr_accessor :group

      def perform
        if in_private?
          raise LeaverBot::InPrivateError
        elsif holiday?
          raise LeaverBot::InHolidayError
        else
          @group = get_group

          raise LeaverBot::GroupNotRegisteredError unless @group
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
