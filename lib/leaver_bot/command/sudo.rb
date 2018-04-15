module LeaverBot
  class Command
    class Sudo < Command
      def args
        stripped_text.strip
      end

      def perform
        raise LeaverBot::InGroupError if !in_private?
        raise LeaverBot::PrivilegeError unless super_admin?
      end

      def super_admin?
        @message.from.username == $super_admin_username
      end
    end
  end
end
