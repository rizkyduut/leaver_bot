module LeaverBot
  class Command
    class Meeting < Command

      def group
        @group ||= LeaverBot::Group.find_by(group_id: @message.chat.id)
      end

      def perform
        raise LeaverBot::GroupNotRegisteredError if group.nil?
        raise LeaverBot::PrivilegeError unless group.validate_admin(@message.from.id)
      end
    end
  end
end
