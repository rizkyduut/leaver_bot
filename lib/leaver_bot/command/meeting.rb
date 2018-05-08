module LeaverBot
  class Command
    class Meeting < Command
      REGEX_TIME = /(2[0-3]|1[0-9]|0[0-9]):([0-5][0-9])$/

      def time
        @time ||= stripped_text.strip
      end

      def group
        @group ||= LeaverBot::Group.find_by(group_id: @message.chat.id)
      end

      def perform
        validate_time!
        raise LeaverBot::GroupNotRegisteredError if group.nil?
        raise LeaverBot::PrivilegeError unless group.validate_admin(@message.from.id)
      end

      private

      def validate_time!
        validated_time = time.match(REGEX_TIME)
        raise LeaverBot::TimeNotValidError if validated_time.nil?
        raise LeaverBot::TimeNotAllowedError if validated_time[2].to_i % 15 != 0
      end
    end
  end
end
