module LeaverBot
  class Command
    class Status < Command
      HOLIDAY_KEY = 'holiday'.freeze

      attr_accessor :group

      def group
        @group ||= LeaverBot::Group.find_by(group_id: @message.chat.id)
      end

      def perform
        if in_private?
          raise LeaverBot::InPrivateError
        elsif holiday?
          raise LeaverBot::InHolidayError
        else
          raise LeaverBot::GroupNotRegisteredError unless group
        end
      end

      def holiday?
        Date.today.saturday? || Date.today.sunday? || $redis.get(HOLIDAY_KEY) == 'y'
      end

    end
  end
end
