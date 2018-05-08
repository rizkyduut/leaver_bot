module LeaverBot
  class Command
    class Meeting < Command
      REGEX_TIME = /(2[0-3]|1[0-9]):([0-5][0-9])$/

      def time
        @time ||= stripped_text.strip
      end

      def group
        @group ||= LeaverBot::Group.find_by(group_id: @message.chat.id)
      end

      def perform
        raise LeaverBot::TimeNotValidError unless valid_time?
        raise LeaverBot::GroupNotRegisteredError if group.nil?
        raise LeaverBot::PrivilegeError unless group.validate_admin(@message.from.id)
      end

      private

      def valid_time?
        validated_time = time.match(REGEX_TIME)
        return false if validated_time.nil? || validated_time[2].to_i % 15 != 0

        true
      end
    end
  end
end
